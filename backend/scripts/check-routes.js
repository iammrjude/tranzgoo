const fs = require('fs');
const path = require('path');
const { Readable } = require('stream');

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

function sampleValue(param) {
  const values = {
    id: '507f1f77bcf86cd799439011',
    tranzgoId: 'TG123456'
  };

  return values[param] || 'sample';
}

function samplePath(pattern) {
  return pattern
    .split('/')
    .map((segment) => {
      return segment.startsWith(':') ? sampleValue(segment.slice(1)) : segment;
    })
    .join('/');
}

function publicUrl(pattern) {
  if (pattern === '/') {
    return '/';
  }

  return `/api${samplePath(pattern)}`;
}

function rewrittenUrl(pattern) {
  if (pattern === '/') {
    return '/api/index?path=home';
  }

  return `/api/index?path=${samplePath(pattern).slice(1)}`;
}

function createResponse(resolve) {
  return {
    body: '',
    headers: {},
    statusCode: 200,
    setHeader(key, value) {
      this.headers[key.toLowerCase()] = value;
    },
    end(body) {
      this.body = body || '';
      resolve(this);
    }
  };
}

async function callRouter(url, method) {
  return new Promise((resolve, reject) => {
    const req = Readable.from([]);
    req.method = method;
    req.url = url;
    req.headers = {
      host: 'localhost:3000',
      origin: 'http://localhost:62956'
    };

    const res = createResponse(resolve);
    router(req, res).catch(reject);
  });
}

async function assertRouteResolves(route, url) {
  const method = route.handler.methods[0];
  const response = await callRouter(url, method);

  if (
    response.statusCode === 404 &&
    String(response.body).includes('API route not found')
  ) {
    throw new Error(`${method} ${url} did not resolve to a backend route.`);
  }

  if (!response.headers['access-control-allow-origin']) {
    throw new Error(`${method} ${url} did not include CORS headers.`);
  }
}

async function checkPublicUrls() {
  for (const route of router.routes) {
    await assertRouteResolves(route, publicUrl(route.pattern));
    await assertRouteResolves(route, rewrittenUrl(route.pattern));
  }
}

checkPublicUrls().then(() => {
  console.log('All API route files and public URLs loaded successfully.');
});
