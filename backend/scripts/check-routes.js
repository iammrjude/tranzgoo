const fs = require('fs');
const path = require('path');

const apiDir = path.join(__dirname, '..', 'api');
const routesDir = path.join(__dirname, '..', 'routes');
const router = require('../src/router');

function walk(dir) {
  return fs.readdirSync(dir, { withFileTypes: true }).flatMap((entry) => {
    const fullPath = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      return walk(fullPath);
    }
    return fullPath.endsWith('.js') ? [fullPath] : [];
  });
}

const functionEntrypoints = walk(apiDir);
const routeHandlers = walk(routesDir);

console.log(`Found ${functionEntrypoints.length} Vercel function entrypoint file(s).`);
console.log(`Found ${routeHandlers.length} internal API route handler file(s).`);
console.log(`Router exposes ${router.routes.length} API route(s).`);

if (functionEntrypoints.length > 12) {
  throw new Error('Vercel Hobby deployments can include no more than 12 functions.');
}

if (router.routes.length !== routeHandlers.length) {
  throw new Error(
    `Router route count (${router.routes.length}) does not match route handler count (${routeHandlers.length}).`
  );
}

for (const entrypoint of functionEntrypoints) {
  require(entrypoint);
}

console.log('All API routes loaded successfully.');
