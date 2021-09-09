import crypto from 'crypto'
import fs from 'fs'

import AnkiExport from 'anki-apkg-export'
import cheerio from 'cheerio'

import ExpressionHelper from './ExpressionHelper'

import {DeckReader} from 'workflow2anki'

export default class DeckHandler

	prop decks = []

	def build contents, deckName = null
			self.handleText(contents, deckName)
	
	def appendDefaultStyle s
		const a = '.card {\nfont-family: arial;\name\nfont-size: 20px;\ntext-align: center;\ncolor: black;\nbackground-color: white;\n'
		"{s}\n{a}"

	def worklflowyName dom
		const names = dom('.name .innerContentContainer')
		return null if !names
		names.first().text()

	# TODO: check for more places where this can be used
	def  findNullIndex coll, field
		return coll.findIndex do |x| x[field] == null

	def handleText contents, deckName = null
		const reader = DeckReader.new()
		const decks = reader.readText(contents)
		self.decks = decks
		if self.decks.length > 0
			self.name = self.decks[0].name
	
	def cleanStyle s
		// TODO: fix twemoji pdf font issues
		const style = s.split('\n').filter do |line|
					# TODO: fix font-family breaking with workflowy, maybe upstream bug?
					!line.includes('.pdf') && !line.includes('font-family')
		style.join('\n')
		
	def apkg
		const zipFiles = []		
		for deck in self.decks
			let exporter
			if deck.style
				const style = self.cleanStyle(deck.style)
				exporter = AnkiExport.new(deck.name, {css: style})	
			else
				exporter = AnkiExport.new(deck.name)	

			for card in deck.cards
				// For now treat Latex as text and wrap it around.
				// This is fragile thougg and won't handle multiline properly
				console.log('card', card)
				if ExpressionHelper.latex?(card.backSide)
					card.backSide = "[latex]{card.backSide.trim()}[/latex]"
				exporter.addCard(card.front, card.back)

			const zip = await exporter.save()
			zipFiles.push({name: "{deck.name}.apkg", apkg: zip})
		return zipFiles