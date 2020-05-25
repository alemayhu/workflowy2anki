import crypto from 'crypto'
import fs from 'fs'

import AnkiExport from 'anki-apkg-export'
import cheerio from 'cheerio'

import ExpressionHelper from './ExpressionHelper'

export default class DeckHandler

	prop decks = []

	def build contents, deckName = null
		if contents.trim().match(/^\<\?xml/)
			self.handleOPML(contents, deckName)
		elif contents.trim().match(/^\</)
			self.handleHTML(contents, deckName)
		else
			self.handleText(contents, deckName)
	
	def appendDefaultStyle s
		const a = '.card {\nfont-family: arial;\name\nfont-size: 20px;\ntext-align: center;\ncolor: black;\nbackground-color: white;\n'
		"{s}\n{a}"

	def worklflowyName dom
		const names = dom('.name .innerContentContainer')
		return null if !names
		names.first().text()

	def handleHTML contents, deckName = null
		self.style = /<style[^>]*>([^<]+)<\/style>/i.exec(contents)[1]
		const inputType = 'HTML'
		const dom = cheerio.load(contents)
		let name = dom('title').text()
		name ||= worklflowyName(dom)

		if self.style
			self.style = appendDefaultStyle(style)
			
		const list_items = dom('body ul').first().children().toArray()
		if !list_items
			return null
		self.cards = list_items.map do |li|
			const el = dom(li)
			const front = el.find('.name .innerContentContainer').first()
			const back = el.find('ul').first().html()
			return {name: front, backSide: back}
	
	def handleText contents, deckName = null
		const lines = contents.split('\n')
		const inputType = 'text'
		self.name = lines.shift()
		let cards = []
		let i = -1
		for line of lines
			continue if !line
			if line.match(/^-/)
				self.decks.push({name: line.replace('-', '').trim(), cards: []})
				i = i + 1
				continue
			
			const currentDeck = self.decks[i]
			if line.match(/^\s{2}-/)
				const unsetBackSide = currentDeck.cards.findIndex do $1.backSide == null
				if unsetBackSide > -1
					currentDeck.cards[unsetBackSide].backSide = line.replace('- ', '').trim()
				else
					currentDeck.cards.push({name: line.replace('- ', '').trim(), backSide: null})
			else
				const unsetBackSide = currentDeck.cards.findIndex do $1.backSide == null
				if unsetBackSide > -1
					currentDeck.cards[unsetBackSide].backSide = line.replace('- ', '').trim()
				else
					throw Error.new('unsupported line '+line)
	
	def handleOPML contents, deckName = null
		const dom = cheerio.load(contents)
		const outline = dom('body outline')
		const name = outline.first().attr('text')
		let outlines = dom('body outline outline').toArray()
		const inputType = 'OPML'
		const style = null


		const cards = []
		let i = 0
		while i < outlines.length
			const el = dom(outlines[i])
			const name = el.attr('text').trim()
			const backSide = el.children().first().attr('text')
			cards.push({name: name, backSide: backSide})
			i = i + 2
		
		console.log('cards', cards)
		{name, cards, inputType, style}

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
				if ExpressionHelper.latex?(card.backSide)
					card.backSide = "[latex]{card.backSide.trim()}[/latex]"
				exporter.addCard(card.name, card.backSide)

			const zip = await exporter.save()
			zipFiles.push({name: "{deck.name}.apkg", apkg: zip})
		return zipFiles