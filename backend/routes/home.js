const { sendHtml, withApi } = require('../src/lib/api');
const packageJson = require('../package.json');

function getEnvironment() {
  return process.env.NODE_ENV || 'development';
}

module.exports = withApi(
  async function home(req, res) {
    return sendHtml(
      res,
      200,
      `<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>TranzGOO API</title>
  <style>
    :root {
      color-scheme: light;
      font-family: Arial, Helvetica, sans-serif;
      background: #f6f8fb;
      color: #18202f;
    }

    body {
      margin: 0;
      min-height: 100vh;
      display: grid;
      place-items: center;
    }

    main {
      width: min(720px, calc(100% - 32px));
      background: #ffffff;
      border: 1px solid #dde3ed;
      border-radius: 8px;
      padding: 32px;
      box-shadow: 0 16px 40px rgba(24, 32, 47, 0.08);
    }

    h1 {
      margin: 0 0 8px;
      font-size: 32px;
      line-height: 1.2;
    }

    p {
      margin: 0;
      color: #526071;
      line-height: 1.6;
    }

    .status {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      margin: 24px 0;
      padding: 8px 12px;
      border-radius: 999px;
      background: #e9f9ef;
      color: #176c38;
      font-weight: 700;
    }

    .dot {
      width: 10px;
      height: 10px;
      border-radius: 50%;
      background: #20a454;
    }

    dl {
      display: grid;
      grid-template-columns: 140px 1fr;
      gap: 12px 18px;
      margin: 0 0 28px;
    }

    dt {
      color: #6a7688;
      font-weight: 700;
    }

    dd {
      margin: 0;
    }

    nav {
      display: flex;
      flex-wrap: wrap;
      gap: 12px;
    }

    a {
      display: inline-flex;
      align-items: center;
      min-height: 40px;
      padding: 0 14px;
      border: 1px solid #c9d3e2;
      border-radius: 6px;
      color: #174ea6;
      text-decoration: none;
      font-weight: 700;
    }

    a.primary {
      border-color: #174ea6;
      background: #174ea6;
      color: #ffffff;
    }

    @media (max-width: 560px) {
      main {
        padding: 24px;
      }

      dl {
        grid-template-columns: 1fr;
        gap: 4px;
      }
    }
  </style>
</head>
<body>
  <main>
    <h1>TranzGOO API</h1>
    <p>The backend service is running. API endpoints are available under <strong>/api</strong>.</p>

    <div class="status"><span class="dot"></span> Status OK</div>

    <dl>
      <dt>Version</dt>
      <dd>${packageJson.version}</dd>
      <dt>Environment</dt>
      <dd>${getEnvironment()}</dd>
      <dt>Function layout</dt>
      <dd>One Vercel catch-all function with internal route handlers</dd>
    </dl>

    <nav aria-label="API links">
      <a class="primary" href="/api/docs">Swagger Docs</a>
      <a href="/api/health">Health Check</a>
      <a href="/api/openapi.json">OpenAPI JSON</a>
    </nav>
  </main>
</body>
</html>`
    );
  },
  {
    methods: ['GET']
  }
);
