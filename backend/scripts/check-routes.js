const fs = require('fs');
const path = require('path');

const apiDir = path.join(__dirname, '..', 'api');

function walk(dir) {
  return fs.readdirSync(dir, { withFileTypes: true }).flatMap((entry) => {
    const fullPath = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      return walk(fullPath);
    }
    return fullPath.endsWith('.js') ? [fullPath] : [];
  });
}

const routes = walk(apiDir);
console.log(`Found ${routes.length} API route files.`);

for (const route of routes) {
  require(route);
}

console.log('All API route files loaded successfully.');
