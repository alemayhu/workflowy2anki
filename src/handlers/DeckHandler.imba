import cheerio from 'cheerio'

import ExpressionHelper from './ExpressionHelper'

export default class DeckHandler

	def pickDefaultDeckName firstLine
		const name = firstLine ? firstLine.trim() : 'Untitled Deck'
		firstLine.trim().replace(/^# /, '')

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
		const inputType = 'HTML'
		const dom = cheerio.load(contents)
		let name = dom('title').text()
		name ||= worklflowyName(dom)
		let style = /<style[^>]*>([^<]+)<\/style>/i.exec(contents)[1]
		if style
			style = appendDefaultStyle(style)
		const toggleList = dom('.toggle li').toArray()
		let cards = toggleList.map do |t|
			const toggle = dom(t).find('details')
			const summary = toggle.find('summary').html()
			const backSide = toggle.html()
			return {name: summary, backSide: backSide}

		if cards.length == 0
			const list_items = dom('body ul').first().children().toArray()
			if !list_items
				return null
			cards = list_items.map do |li|
				const el = dom(li)
				const front = el.find('.name .innerContentContainer').first()
				const back = el.find('ul').first().html()
				return {name: front, backSide: back}

		{name, cards, inputType, style}
	
	def handleText contents, deckName = null
		const lines = contents.split('\n')
		const style = null
		const inputType = 'text'
		const name = lines.shift()
		console.log('lines', lines)
		let cards = []
		let i = -1
		for line of lines
			continue if !line
			if line.match(/^-/) || !cards[i]
				i = i + 1
				cards[i] = {name: line.replace('- ', '').trim(), backSide: ''}
			else
				cards[i].backSide += line.replace('  - ', '').trim()
		
		{name, cards, inputType, style}
	
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