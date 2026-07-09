const { sendHtml, withApi } = require('../src/lib/api');
const packageJson = require('../package.json');

module.exports = withApi(
  async function docs(req, res) {
    return sendHtml(
      res,
      200,
      `<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>TranzGOO API Docs</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swagger-ui-dist@5/swagger-ui.css">
  <style>
    body {
      margin: 0;
      background: #f7f8fb;
    }

    .topbar {
      display: none;
    }

    header {
      padding: 18px 28px;
      background: #18202f;
      color: #ffffff;
      font-family: Arial, Helvetica, sans-serif;
    }

    header h1 {
      margin: 0;
      font-size: 22px;
    }

    header p {
      margin: 6px 0 0;
      color: #c8d2df;
    }
  </style>
</head>
<body>
  <header>
    <h1>TranzGOO API Documentation</h1>
    <p>Interactive Swagger UI for version ${packageJson.version}</p>
  </header>
  <div id="swagger-ui"></div>
  <script src="https://cdn.jsdelivr.net/npm/swagger-ui-dist@5/swagger-ui-bundle.js"></script>
  <script>
    window.addEventListener('load', function () {
      window.ui = SwaggerUIBundle({
        url: '/api/openapi.json',
        dom_id: '#swagger-ui',
        deepLinking: true,
        displayRequestDuration: true,
        presets: [SwaggerUIBundle.presets.apis],
        layout: 'BaseLayout'
      });
    });
  </script>
</body>
</html>`
    );
  },
  {
    methods: ['GET']
  }
);
