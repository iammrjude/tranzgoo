const { sendJson, withApi } = require('../src/lib/api');
const openApiDocument = require('../src/openapi');

module.exports = withApi(
  async function openapi(req, res) {
    return sendJson(res, 200, openApiDocument);
  },
  {
    methods: ['GET']
  }
);
