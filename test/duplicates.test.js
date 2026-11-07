
const test = require('node:test');
const assert = require('node:assert');
const { isDuplicate } = require('../tools/duplicates');

test('returns true when page titles match', () => {
  assert.strictEqual(isDuplicate({ title: 'A' }, { title: 'A' }), true);
});

test('returns false when page titles differ', () => {
  assert.strictEqual(isDuplicate({ title: 'A' }, { title: 'B' }), false);
});

test('returns false when either page is missing', () => {
  assert.strictEqual(isDuplicate(null, { title: 'A' }), false);
});
