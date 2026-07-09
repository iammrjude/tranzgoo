const { sendError, sendJson, setCorsHeaders } = require('./lib/api');

const routeDefinitions = [
  ['/', require('../routes')],
  ['/home', require('../routes/home')],
  ['/docs', require('../routes/docs')],
  ['/openapi.json', require('../routes/openapi')],

  ['/health', require('../routes/health')],
  ['/legal', require('../routes/legal')],

  ['/auth/register', require('../routes/auth/register')],
  ['/auth/login', require('../routes/auth/login')],
  ['/auth/me', require('../routes/auth/me')],
  ['/auth/change-password', require('../routes/auth/change-password')],
  ['/auth/forgot-password', require('../routes/auth/forgot-password')],
  ['/auth/reset-password', require('../routes/auth/reset-password')],

  ['/user/me', require('../routes/user/me')],
  ['/user/security', require('../routes/user/security')],
  ['/users/lookup/:tranzgoId', require('../routes/users/lookup/[tranzgoId]')],

  ['/wallet', require('../routes/wallet')],
  ['/wallet/funding-accounts', require('../routes/wallet/funding-accounts')],
  ['/wallet/transfer', require('../routes/wallet/transfer')],

  ['/transactions', require('../routes/transactions')],
  ['/transactions/:id', require('../routes/transactions/[id]')],

  ['/services', require('../routes/services')],
  ['/services/airtime/networks', require('../routes/services/airtime/networks')],
  ['/services/airtime/purchase', require('../routes/services/airtime/purchase')],
  ['/services/data/networks', require('../routes/services/data/networks')],
  ['/services/data/plans', require('../routes/services/data/plans')],
  ['/services/data/purchase', require('../routes/services/data/purchase')],
  ['/services/cable/providers', require('../routes/services/cable/providers')],
  ['/services/cable/packages', require('../routes/services/cable/packages')],
  ['/services/cable/validate', require('../routes/services/cable/validate')],
  ['/services/cable/purchase', require('../routes/services/cable/purchase')],
  [
    '/services/electricity/providers',
    require('../routes/services/electricity/providers')
  ],
  [
    '/services/electricity/validate-meter',
    require('../routes/services/electricity/validate-meter')
  ],
  [
    '/services/electricity/purchase',
    require('../routes/services/electricity/purchase')
  ],
  ['/services/education/products', require('../routes/services/education/products')],
  ['/services/education/purchase', require('../routes/services/education/purchase')],
  [
    '/services/airtime-to-cash/quote',
    require('../routes/services/airtime-to-cash/quote')
  ],
  [
    '/services/airtime-to-cash/submit',
    require('../routes/services/airtime-to-cash/submit')
  ],
  [
    '/services/airtime-to-cash/:id',
    require('../routes/services/airtime-to-cash/[id]')
  ],

  ['/notifications', require('../routes/notifications')],
  ['/notifications/preferences', require('../routes/notifications/preferences')],
  ['/notifications/:id/read', require('../routes/notifications/[id]/read')],
  ['/referrals', require('../routes/referrals')],
  ['/referrals/invite', require('../routes/referrals/invite')],
  ['/support/tickets', require('../routes/support/tickets')]
];

function escapeRegex(value) {
  return value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

function compileRoute([pattern, handler]) {
  const params = [];
  const segments = pattern.split('/').filter(Boolean);
  const regexSegments = segments.map((segment) => {
    if (!segment.startsWith(':')) {
      return escapeRegex(segment);
    }

    params.push(segment.slice(1));
    return '([^/]+)';
  });

  return {
    handler,
    params,
    pattern,
    regex: new RegExp(`^/${regexSegments.join('/')}/?$`)
  };
}

const routes = routeDefinitions.map(compileRoute);

function getApiPath(req) {
  const host = req.headers.host || 'localhost';
  const url = new URL(req.url || '/', `http://${host}`);
  const rewrittenPath = url.searchParams.get('path');
  let pathname = url.pathname;

  if (rewrittenPath !== null) {
    pathname = rewrittenPath ? `/${rewrittenPath}` : '/';
  } else if (pathname === '/api') {
    pathname = '/';
  } else if (pathname.startsWith('/api/')) {
    pathname = pathname.slice('/api'.length);
  }

  if (pathname === '/index') {
    pathname = '/';
  }

  if (pathname.length > 1 && pathname.endsWith('/')) {
    pathname = pathname.slice(0, -1);
  }

  return { pathname, url };
}

function getQuery(req, url, params) {
  const query =
    req.query && typeof req.query === 'object' && !Array.isArray(req.query)
      ? { ...req.query }
      : {};

  for (const [key, value] of url.searchParams.entries()) {
    query[key] = value;
  }

  delete query.path;

  return { ...query, ...params };
}

function findRoute(pathname) {
  for (const route of routes) {
    const match = route.regex.exec(pathname);

    if (!match) {
      continue;
    }

    const params = {};
    route.params.forEach((param, index) => {
      params[param] = decodeURIComponent(match[index + 1]);
    });

    return { handler: route.handler, params };
  }

  return null;
}

async function router(req, res) {
  setCorsHeaders(req, res);

  const { pathname, url } = getApiPath(req);
  const match = findRoute(pathname);

  if (!match) {
    if (req.method === 'OPTIONS') {
      return sendJson(res, 204, {});
    }

    return sendError(res, 404, `API route not found: ${pathname}`);
  }

  req.query = getQuery(req, url, match.params);
  return match.handler(req, res);
}

router.routes = routes;

module.exports = router;
