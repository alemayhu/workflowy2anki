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
		const document = dom('body').first().children().toArray();
		let currentDeckIndex = -1;
		const decks = [];
		let parent = null;

		// Go through the body
		for (const element of document) {
			// For each element
			for (const child of element.children) {
				// If it's a list item
				if (child.name === 'li') {
					// Loop over all of the sub elements
					for (const grandChild of child.children) {
						// Top level list items are decks unless they are a list
						if (grandChild.name === "span") {
							currentDeckIndex++;
							decks.push({ name: dom(grandChild).text().trim(), cards: [] });
							parent = decks[currentDeckIndex].name
						} else if (grandChild.name === 'ul') {
							for (const greatGrandChild of grandChild.children) {
								// Found a subdeck
								if (greatGrandChild.children[1].children.length > 1) {
									let n = dom(greatGrandChild).find(".innerContentContainer").first().text()
									decks.push({ name: `${parent}::${n}`, cards: [] });
								}

								// else {
								// 	for (const gggc of greatGrandChild.children) {
								// 		for (const ggggc of gggc.children) {
								// 			console.log('xxxx', dom(ggggc).html())
								// 			let currentDeck = decks[currentDeckIndex];
								// 			const firstEmptyBackIndex = currentDeck.cards.findIndex(c => c.back === null);
								// 			if (firstEmptyBackIndex > -1) {
								// 				currentDeck.cards[firstEmptyBackIndex].back = dom(ggggc).html();
								// 			} else if (ggggc.name === 'span') {
								// 				currentDeck.cards.push({ front: dom(ggggc).html(), back: null });
								// 			}
								// 		}
								// 	}
								// }
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