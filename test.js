const test = require('ava');

test('foo', t => {
	t.pass();
});

test('bar', async t => {
	const bar = Promise.resolve('bar');
	t.is(await bar, 'bar');
});


test.skip('formatted', t => {
	t.fail("to be implemented");
});

test('Plain text', t => {
	t.fail("to be implemented");
});

test.skip('OPML', t => {
	t.fail("to be implemented");
});