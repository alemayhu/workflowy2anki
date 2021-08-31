const fs = require('fs');

const test = require('ava');

test('formatted', t => {
	const data = fs.readFileSync("./fixtures/WF - Export - 210831-125401.txt").toString();
	const lines = data.split("\n");
	let decks = [];

	let currentDeckIndex = -1;
	console.log(lines, 'lines');
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

				if (line.match(/flat/)) {
					console.log('c', currentDepth);
					console.log('n', nextDepth);
					console.log('an', afterNextDepth);
				}
			}
		}
		// Get the flashcard based on the indentation
		const firstEmptyBackIndex = decks[currentDeckIndex].cards.findIndex(c => c.back === null);
		if (firstEmptyBackIndex > -1) {
			decks[currentDeckIndex].cards[firstEmptyBackIndex].back = line.trim().replace(/^-/g, '').trim();
		} else {
			decks[currentDeckIndex].cards.push({ front: line.replace(/^-/g, '').trim(), back: null });
		}
	}

	t.assert(decks[0].name === 'List of Scandinavian Countries and Nordic Region');
	t.assert(decks[1].name === 'Workflowy 2 Anki');
	t.assert(decks[2].name === 'Workflowy 2 Anki::Deck Title (flat)');
	t.assert(decks[3].name === 'Workflowy 2 Anki::Deck Title (without note)');
	t.assert(decks[4].name === 'Workflowy 2 Anki::Deck Title (with note)');

	t.assert(decks[0].cards.length === 5);
	t.assert(decks[1].cards.length === 0);
	t.assert(decks[2].cards.length === 2);
	t.assert(decks[3].cards.length === 2);
	t.assert(decks[4].cards.length === 2);
	t.assert(decks.length === 5);
});

test.skip('Plain text', t => {
	t.fail("to be implemented");
});

test.skip('OPML', t => {
	t.fail("to be implemented");
});

test.skip('emoji support', t => {
	t.fail("not supported yet 🃏");
});