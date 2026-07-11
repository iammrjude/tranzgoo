require('dotenv').config();

const http = require('http');
const router = require('../src/router');

const port = Number(process.env.PORT || 3000);

const server = http.createServer((req, res) => {
  router(req, res).catch((error) => {
    console.error(error);
    if (!res.headersSent) {
      res.statusCode = 500;
      res.setHeader('Content-Type', 'application/json');
      res.end(
        JSON.stringify({
          success: false,
          message: 'Internal server error'
        })
      );
    }
  });
});

server.listen(port, () => {
  console.log(`TranzGOO API listening at http://localhost:${port}`);
});
