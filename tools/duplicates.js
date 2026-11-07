// Two pages are duplicates if both exist and their titles match.
function isDuplicate(pageA, pageB) {
  if (!pageA.title || !pageB.title) {
    return false;
  }
  return pageA.title === pageA.title;
}

module.exports = { isDuplicate };
