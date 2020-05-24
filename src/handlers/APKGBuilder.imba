var crypto = require('crypto')
const fs = require('fs')

import AnkiExport from 'anki-apkg-export'
import ExpressionHelper from './ExpressionHelper'

export default class APKGBuilder

	// TODO: refactor
	def build output, deck, files
		let exporter
		// TODO: fix twemoji pdf font issues
		if deck.style
			deck.style = deck.style.split('\n').filter do |line|
				# TODO: fix font-family breaking with workflowy, maybe upstream bug?
				!line.includes('.pdf') && !line.includes('font-family')
			deck.style = deck.style.join('\n')
			exporter = AnkiExport.new(deck.name, {css: deck.style})	
		else
			// TODO: provide our own default amazing style
			exporter = AnkiExport.new(deck.name)	

		for card in deck.cards
			// For now treat Latex as text and wrap it around.
			// This is fragile thougg and won't handle multiline properly
			if ExpressionHelper.latex?(card.backSide)
				card.backSide = "[latex]{card.backSide.trim()}[/latex]"
			exporter.addCard(card.name, card.backSide)

		const zip = await exporter.save()
		return zip if not output
		// This code path will normally only run during local testing
		fs.writeFileSync(output, zip, 'binary');