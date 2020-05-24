const path = require('path')
const fs = require('fs')

import DeckHandler from '../src/handlers/DeckHandler'
import APKGBuilder from '../src/handlers/APKGBuilder'
import ZipHandler from '../src/handlers/ZipHandler'
import ExpressionHelper from '../src/handlers/ExpressionHelper'

def eq lhs, rhs, msg = null
	console.log('comparing', lhs, rhs, msg ? "reason: {msg}" : '')
	return if lhs == rhs
	try
		console.log("{JSON.stringify(lhs)} is not equal {JSON.stringify(rhs)}")
	catch e
		console.log('failed to show comparison failure')
	process.exit(1)

def test_fixture file_name, deck_name, card_count, files = {}, expectStyle = true
	try
		const file_path = path.join(__dirname, "fixtures", file_name)
		const example = fs.readFileSync(file_path).toString()
		const isMarkdown = ExpressionHelper.document?(example)
		let builder = DeckHandler.new(isMarkdown)
		const deck = builder.build(example)
		
		eq(deck.style != undefined, expectStyle, "Style is not set")

		console.log('deck.name', deck.name)
		eq(deck.name, deck_name, 'comparing deck names')
		eq(deck.cards.length, card_count, 'comparing deck count')

		if card_count > 0
			const zip_file_path = path.join(__dirname, "artifacts", "{deck.name}.apkg")
			await APKGBuilder.new().build(zip_file_path, deck, files)
			eq(fs.existsSync(zip_file_path), true, 'ensuring output was created')
	catch e
		console.error(e)
		process.exit(1)

def main
	console.time('execution time')
	console.log('Running tests')

	test_fixture('workflowy-export.opml', 'List of Scandinavian Countries and Nordic Region', 5, [], false)
	test_fixture('workflowy-export.txt', 'List of Scandinavian Countries and Nordic Region', 5, [], false)
	test_fixture('workflowy-export.html', 'DNS flashcards', 2)

	console.log('All assertions done 👍🏽')
	console.timeEnd('execution time')
	process.exit(0)

if process.main != module
	main()