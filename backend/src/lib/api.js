const { ApiError } = require('./errors');

function setCorsHeaders(req, res) {
  const origin = process.env.CORS_ORIGIN || '*';

  res.setHeader('Access-Control-Allow-Origin', origin);
  res.setHeader('Access-Control-Allow-Methods', 'GET,POST,PATCH,DELETE,OPTIONS');
  res.setHeader(
    'Access-Control-Allow-Headers',
    'Content-Type, Authorization, X-Requested-With'
  );
}

function sendJson(res, statusCode, payload) {
  res.statusCode = statusCode;
  res.setHeader('Content-Type', 'application/json');
  res.end(JSON.stringify(payload));
}

function sendSuccess(res, statusCode, data, message) {
  sendJson(res, statusCode, {
    success: true,
    message,
    data
  });
}

function sendError(res, statusCode, message, details) {
  sendJson(res, statusCode, {
    success: false,
    message,
    details
  });
}

async function readJsonBody(req) {
  if (req.body && typeof req.body === 'object') {
    return req.body;
  }

  if (typeof req.body === 'string') {
    return req.body.trim() ? JSON.parse(req.body) : {};
  }

  const chunks = [];

  for await (const chunk of req) {
    chunks.push(chunk);
  }

  const raw = Buffer.concat(chunks).toString('utf8');
  return raw.trim() ? JSON.parse(raw) : {};
}

function withApi(handler, options = {}) {
  const methods = options.methods || ['GET'];

  return async function apiHandler(req, res) {
    setCorsHeaders(req, res);

    if (req.method === 'OPTIONS') {
      return sendJson(res, 204, {});
    }

    if (!methods.includes(req.method)) {
      res.setHeader('Allow', methods.join(', '));
      return sendError(res, 405, `Method ${req.method} not allowed`);
    }

    try {
      return await handler(req, res);
    } catch (error) {
      if (error instanceof SyntaxError) {
        return sendError(res, 400, 'Invalid JSON request body');
      }

      if (error instanceof ApiError) {
        return sendError(res, error.statusCode, error.message, error.details);
      }

      console.error(error);
      return sendError(res, 500, 'Internal server error');
    }
  };
}

module.exports = {
  readJsonBody,
  sendError,
  sendJson,
  sendSuccess,
  withApi
};
