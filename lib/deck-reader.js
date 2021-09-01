const cheerio = require('cheerio');
class DeckReader {

	constructor() {
		this.decks = [];
	}

	cleanInput(input) {
		return input.trim().replace(/^-/g, '').replace(/^"/g, '').replace(/"$/g, "").trim();
	}

	/**
	 *  Read Workflowy text outline and transform it into decks
	 * @param {string} input 
	 * @returns  {Deck[]}
	 */
	readText(input) {
		const lines = input.split("\n");
		let decks = [];
		let currentDeckIndex = -1;
		let parent = null;
		const end = lines.length - 1;

		for (const line of lines) {
			if (!line || line.trim() === '') {
				continue;
			}
			const cleanLine = this.cleanInput(line);
			const currentDepth = line.search(/\S/);
			// first character is dash - must be top level then due to indentation
			if (currentDepth === 0) {
				let deck = { name: cleanLine, cards: [] };
				currentDeckIndex++;
				decks.push(deck);
				parent = deck.name;
				continue;
			}
			const currentIndex = lines.indexOf(line);
			if (currentIndex + 1 < end) {
				const nextLine = lines[currentIndex + 1];
				const nextDepth = nextLine.search(/\S/);
				if (currentIndex + 2 < end) {
					const afterNextLine = lines[currentIndex + 2];
					const afterNextDepth = afterNextLine.search(/\S/);
					if (
						(currentDepth + 2 === nextDepth && currentDepth + 4 === afterNextDepth)
						|| (currentDepth + 2 === nextDepth && currentDepth + 2 === afterNextDepth)
					) {
						let deck = { name: `${parent}::${this.cleanInput(line)}`, cards: [] };
						currentDeckIndex++;
						decks.push(deck);
						continue;
					}
				}
			}
			let currentDeck = decks[currentDeckIndex];
			// Get the flashcard based on the indentation
			const firstEmptyBackIndex = currentDeck.cards.findIndex(c => c.back === null);
			if (firstEmptyBackIndex > -1) {
				currentDeck.cards[firstEmptyBackIndex].back = cleanLine;
			} else {
				currentDeck.cards.push({ front: cleanLine, back: null });
			}
		}

		return decks;
	}

	readHTML(input) {
		const dom = cheerio.load(input);
		console.log('dom.load', dom.html());
		const lists = dom('body ul').first().children().toArray();
		let currentDeckIndex = -1;
		const decks = [];

		for (const list of lists) {
			for (const child of list.children) {
				if (child.name === "span") {
					currentDeckIndex++;
					decks.push({ name: dom(child).text().trim(), cards: [] });
				} else if (child.name === 'ul') {
					let currentDeck = decks[currentDeckIndex];
					for (const grandChild of child.children) {
						for (const greatGrandChild of grandChild.children) {
							if (greatGrandChild.children.length === 1) {
								console.log('ggc: -> ', dom(greatGrandChild).text().trim());
								// 	currentDeckIndex++;
								// 	decks.push({ name: dom(child).text(), cards: [] });
								// 	continue;
							}
							const firstEmptyBackIndex = currentDeck.cards.findIndex(c => c.back === null);
							if (firstEmptyBackIndex > -1) {
								currentDeck.cards[firstEmptyBackIndex].back = dom(greatGrandChild).html();
							} else if (greatGrandChild.name === 'span') {
								currentDeck.cards.push({ front: dom(greatGrandChild).html(), back: null });
							}
						}
					}
				}
			}
		}
		console.log('decks', decks);
		return decks;
	}
}

module.exports.DeckReader = DeckReader;