const { test } = require('node:test');
const assert = require('node:assert');
const { isDuplicate } = require('../tools/duplicates');

test('returns true when page titles match', () => {
  assert.strictEqual(isDuplicate({ title: 'My Page' }, { title: 'My Page' }), true);
});

test('returns false when page titles differ', () => {
  assert.strictEqual(isDuplicate({ title: 'Page A' }, { title: 'Page B' }), false);
});
