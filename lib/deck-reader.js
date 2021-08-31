class DeckReader {

	constructor() {
		this.decks = [];
	}

	/**
	 *  Read formatted Workflowy outline and transform it into decks
	 * @param {string} input 
	 * @returns  {Deck[]}
	 */
	readFormatted(input) {
		const lines = input.split("\n");
		let decks = [];
		let currentDeckIndex = -1;
		let parent = null;

		const end = lines.length - 1;
		for (const line of lines) {
			if (!line || line.trim() === '') {
				continue;
			}
			const currentDepth = line.search(/\S/);
			// first character is dash - must be top level then due to indentation
			if (currentDepth === 0) {
				let deck = { name: line.replace(/^-/g, '').trim(), cards: [] };
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
						let deck = { name: `${parent}::${line.trim().replace(/-/g, '').trim()}`, cards: [] };
						currentDeckIndex++;
						decks.push(deck);
						continue;
					}
				}
			}
			// Get the flashcard based on the indentation
			const firstEmptyBackIndex = decks[currentDeckIndex].cards.findIndex(c => c.back === null);
			if (firstEmptyBackIndex > -1) {
				decks[currentDeckIndex].cards[firstEmptyBackIndex].back = line.trim().replace(/^-/g, '').replace(/^"/g, '').replace(/"$/g, "").trim();
			} else {
				decks[currentDeckIndex].cards.push({ front: line.replace(/-/g, '').trim(), back: null });
			}
		}

		return decks;
	}
}

module.exports.DeckReader = DeckReader;