const fs = require('fs');

const test = require('ava');

const { DeckReader } = require('./lib/deck-reader');

test('Plain text', t => {
	const data = fs.readFileSync("./fixtures/WF - Export - 210831-125401.txt").toString();
	const reader = new DeckReader();
	const decks = reader.readText(data);

	// fs.writeFileSync('x.output.json', JSON.stringify(decks, null, 2));

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

	// Check note variant is handled properly
	t.assert(decks[4].cards[0].front === 'Card 1, side 1');
	t.assert(decks[4].cards[0].back === 'Card 1, side 2');
});

test.skip('Formatted - HTML', t => {
	t.fail("to be implemented");
});

test.skip('OPML', t => {
	t.fail("to be implemented");
});

test.skip('emoji support', t => {
	t.fail("not supported yet 🃏");
});