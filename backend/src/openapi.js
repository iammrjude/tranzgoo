const packageJson = require('../package.json');

const bearerSecurity = [{ bearerAuth: [] }];

function jsonResponse(description, schema) {
  return {
    description,
    content: {
      'application/json': {
        schema: schema || { $ref: '#/components/schemas/ApiSuccess' }
      }
    }
  };
}

function htmlResponse(description) {
  return {
    description,
    content: {
      'text/html': {
        schema: {
          type: 'string'
        }
      }
    }
  };
}

function body(properties, required, example) {
  return {
    required: true,
    content: {
      'application/json': {
        schema: {
          type: 'object',
          properties,
          required
        },
        example
      }
    }
  };
}

function pathParam(name, description) {
  return {
    name,
    in: 'path',
    required: true,
    description,
    schema: {
      type: 'string'
    }
  };
}

function queryParam(name, description, schema) {
  return {
    name,
    in: 'query',
    required: false,
    description,
    schema: schema || {
      type: 'string'
    }
  };
}

const amountProperty = {
  oneOf: [
    { type: 'number' },
    { type: 'string' }
  ],
  example: 1000
};

const phoneProperty = {
  type: 'string',
  example: '08012345678'
};

const stringProperty = {
  type: 'string'
};

const standardErrors = {
  400: jsonResponse('Bad request', { $ref: '#/components/schemas/ApiError' }),
  401: jsonResponse('Missing or invalid authentication token', {
    $ref: '#/components/schemas/ApiError'
  }),
  404: jsonResponse('Resource not found', {
    $ref: '#/components/schemas/ApiError'
  }),
  500: jsonResponse('Unexpected server error', {
    $ref: '#/components/schemas/ApiError'
  })
};

module.exports = {
  openapi: '3.0.3',
  info: {
    title: 'TranzGOO API',
    version: packageJson.version,
    description:
      'Backend API for TranzGOO authentication, wallet, transactions, services, notifications, referrals, support, and legal content.'
  },
  servers: [
    {
      url: 'http://localhost:3000',
      description: 'Local development'
    },
    {
      url: 'https://your-vercel-domain.vercel.app',
      description: 'Production'
    }
  ],
  tags: [
    { name: 'Status' },
    { name: 'Documentation' },
    { name: 'Auth' },
    { name: 'User' },
    { name: 'Wallet' },
    { name: 'Transactions' },
    { name: 'Services' },
    { name: 'Notifications' },
    { name: 'Referrals' },
    { name: 'Support' },
    { name: 'Legal' }
  ],
  paths: {
    '/': {
      get: {
        tags: ['Status'],
        summary: 'API landing page',
        responses: {
          200: htmlResponse('HTML status page')
        }
      }
    },
    '/api/health': {
      get: {
        tags: ['Status'],
        summary: 'Health check',
        responses: {
          200: jsonResponse('Backend health status')
        }
      }
    },
    '/api/docs': {
      get: {
        tags: ['Documentation'],
        summary: 'Swagger UI documentation',
        responses: {
          200: htmlResponse('Swagger UI page')
        }
      }
    },
    '/api/openapi.json': {
      get: {
        tags: ['Documentation'],
        summary: 'OpenAPI document',
        responses: {
          200: jsonResponse('OpenAPI JSON document')
        }
      }
    },
    '/api/auth/register': {
      post: {
        tags: ['Auth'],
        summary: 'Create a new user account',
        requestBody: body(
          {
            fullName: { type: 'string', example: 'John Doe' },
            email: { type: 'string', format: 'email', example: 'john@example.com' },
            phone: phoneProperty,
            password: { type: 'string', format: 'password', example: 'secret123' },
            confirmPassword: {
              type: 'string',
              format: 'password',
              example: 'secret123'
            }
          },
          ['fullName', 'email', 'phone', 'password', 'confirmPassword'],
          {
            fullName: 'John Doe',
            email: 'john@example.com',
            phone: '08012345678',
            password: 'secret123',
            confirmPassword: 'secret123'
          }
        ),
        responses: {
          201: jsonResponse('Registration successful', {
            $ref: '#/components/schemas/AuthResponse'
          }),
          409: jsonResponse('Email or phone already exists', {
            $ref: '#/components/schemas/ApiError'
          }),
          ...standardErrors
        }
      }
    },
    '/api/auth/login': {
      post: {
        tags: ['Auth'],
        summary: 'Log in with email and password',
        requestBody: body(
          {
            email: { type: 'string', format: 'email', example: 'john@example.com' },
            password: { type: 'string', format: 'password', example: 'secret123' }
          },
          ['email', 'password'],
          {
            email: 'john@example.com',
            password: 'secret123'
          }
        ),
        responses: {
          200: jsonResponse('Login successful', {
            $ref: '#/components/schemas/AuthResponse'
          }),
          ...standardErrors
        }
      }
    },
    '/api/auth/me': {
      get: {
        tags: ['Auth'],
        summary: 'Get the authenticated user',
        security: bearerSecurity,
        responses: {
          200: jsonResponse('Current user'),
          ...standardErrors
        }
      }
    },
    '/api/user/me': {
      get: {
        tags: ['User'],
        summary: 'Get the authenticated user profile',
        security: bearerSecurity,
        responses: {
          200: jsonResponse('Current user profile'),
          ...standardErrors
        }
      },
      patch: {
        tags: ['User'],
        summary: 'Update the authenticated user profile',
        security: bearerSecurity,
        requestBody: body(
          {
            fullName: { type: 'string', example: 'John Doe' },
            email: { type: 'string', format: 'email', example: 'john@example.com' },
            phone: phoneProperty,
            profileImageUrl: {
              type: 'string',
              format: 'uri',
              example: 'https://example.com/avatar.jpg'
            }
          },
          [],
          {
            fullName: 'John Doe',
            phone: '08012345678'
          }
        ),
        responses: {
          200: jsonResponse('Profile updated'),
          409: jsonResponse('Email or phone already exists', {
            $ref: '#/components/schemas/ApiError'
          }),
          ...standardErrors
        }
      }
    },
    '/api/users/lookup/{tranzgoId}': {
      get: {
        tags: ['User'],
        summary: 'Look up a user by TranzGOO ID',
        security: bearerSecurity,
        parameters: [pathParam('tranzgoId', 'Receiver TranzGOO ID')],
        responses: {
          200: jsonResponse('Matching user summary'),
          ...standardErrors
        }
      }
    },
    '/api/wallet': {
      get: {
        tags: ['Wallet'],
        summary: 'Get wallet balance',
        security: bearerSecurity,
        responses: {
          200: jsonResponse('Wallet balance'),
          ...standardErrors
        }
      }
    },
    '/api/wallet/funding-accounts': {
      get: {
        tags: ['Wallet'],
        summary: 'Get wallet funding accounts',
        security: bearerSecurity,
        responses: {
          200: jsonResponse('Funding accounts'),
          ...standardErrors
        }
      }
    },
    '/api/wallet/transfer': {
      post: {
        tags: ['Wallet'],
        summary: 'Transfer wallet balance to another TranzGOO user',
        security: bearerSecurity,
        requestBody: body(
          {
            receiverTranzgoId: { type: 'string', example: 'TG123456' },
            amount: amountProperty,
            note: { type: 'string', example: 'Lunch payment' }
          },
          ['receiverTranzgoId', 'amount'],
          {
            receiverTranzgoId: 'TG123456',
            amount: 1000,
            note: 'Lunch payment'
          }
        ),
        responses: {
          201: jsonResponse('Transfer successful'),
          ...standardErrors
        }
      }
    },
    '/api/transactions': {
      get: {
        tags: ['Transactions'],
        summary: 'List transaction history',
        security: bearerSecurity,
        parameters: [
          queryParam('page', 'Page number', { type: 'integer', minimum: 1, default: 1 }),
          queryParam('limit', 'Results per page', {
            type: 'integer',
            minimum: 1,
            maximum: 100,
            default: 20
          })
        ],
        responses: {
          200: jsonResponse('Transaction list'),
          ...standardErrors
        }
      }
    },
    '/api/transactions/{id}': {
      get: {
        tags: ['Transactions'],
        summary: 'Get one transaction',
        security: bearerSecurity,
        parameters: [pathParam('id', 'Transaction MongoDB ObjectId')],
        responses: {
          200: jsonResponse('Transaction details'),
          ...standardErrors
        }
      }
    },
    '/api/services': {
      get: {
        tags: ['Services'],
        summary: 'List available service categories',
        security: bearerSecurity,
        responses: {
          200: jsonResponse('Service categories'),
          ...standardErrors
        }
      }
    },
    '/api/services/airtime/networks': {
      get: {
        tags: ['Services'],
        summary: 'List airtime networks',
        security: bearerSecurity,
        responses: {
          200: jsonResponse('Airtime networks'),
          ...standardErrors
        }
      }
    },
    '/api/services/airtime/purchase': {
      post: {
        tags: ['Services'],
        summary: 'Buy airtime',
        security: bearerSecurity,
        requestBody: body(
          {
            network: { type: 'string', example: 'mtn' },
            phone: phoneProperty,
            amount: amountProperty
          },
          ['network', 'phone', 'amount'],
          {
            network: 'mtn',
            phone: '08012345678',
            amount: 1000
          }
        ),
        responses: {
          201: jsonResponse('Airtime purchase successful'),
          ...standardErrors
        }
      }
    },
    '/api/services/data/networks': {
      get: {
        tags: ['Services'],
        summary: 'List data networks',
        security: bearerSecurity,
        responses: {
          200: jsonResponse('Data networks'),
          ...standardErrors
        }
      }
    },
    '/api/services/data/plans': {
      get: {
        tags: ['Services'],
        summary: 'List data plans',
        security: bearerSecurity,
        parameters: [queryParam('network', 'Optional network id such as mtn')],
        responses: {
          200: jsonResponse('Data plans'),
          ...standardErrors
        }
      }
    },
    '/api/services/data/purchase': {
      post: {
        tags: ['Services'],
        summary: 'Buy a data bundle',
        security: bearerSecurity,
        requestBody: body(
          {
            planId: { type: 'string', example: 'mtn-1gb-30d' },
            phone: phoneProperty
          },
          ['planId', 'phone'],
          {
            planId: 'mtn-1gb-30d',
            phone: '08012345678'
          }
        ),
        responses: {
          201: jsonResponse('Data purchase successful'),
          ...standardErrors
        }
      }
    },
    '/api/services/cable/providers': {
      get: {
        tags: ['Services'],
        summary: 'List cable providers',
        security: bearerSecurity,
        responses: {
          200: jsonResponse('Cable providers'),
          ...standardErrors
        }
      }
    },
    '/api/services/cable/packages': {
      get: {
        tags: ['Services'],
        summary: 'List cable packages',
        security: bearerSecurity,
        parameters: [queryParam('provider', 'Optional provider id such as dstv')],
        responses: {
          200: jsonResponse('Cable packages'),
          ...standardErrors
        }
      }
    },
    '/api/services/cable/validate': {
      post: {
        tags: ['Services'],
        summary: 'Validate a cable smart card number',
        security: bearerSecurity,
        requestBody: body(
          {
            provider: { type: 'string', example: 'dstv' },
            smartCardNumber: { type: 'string', example: '1234567890' }
          },
          ['provider', 'smartCardNumber'],
          {
            provider: 'dstv',
            smartCardNumber: '1234567890'
          }
        ),
        responses: {
          200: jsonResponse('Cable customer details'),
          ...standardErrors
        }
      }
    },
    '/api/services/cable/purchase': {
      post: {
        tags: ['Services'],
        summary: 'Pay for a cable package',
        security: bearerSecurity,
        requestBody: body(
          {
            packageId: { type: 'string', example: 'dstv-padi' },
            smartCardNumber: { type: 'string', example: '1234567890' }
          },
          ['packageId', 'smartCardNumber'],
          {
            packageId: 'dstv-padi',
            smartCardNumber: '1234567890'
          }
        ),
        responses: {
          201: jsonResponse('Cable purchase successful'),
          ...standardErrors
        }
      }
    },
    '/api/services/electricity/providers': {
      get: {
        tags: ['Services'],
        summary: 'List electricity providers',
        security: bearerSecurity,
        responses: {
          200: jsonResponse('Electricity providers'),
          ...standardErrors
        }
      }
    },
    '/api/services/electricity/validate-meter': {
      post: {
        tags: ['Services'],
        summary: 'Validate an electricity meter number',
        security: bearerSecurity,
        requestBody: body(
          {
            provider: { type: 'string', example: 'ekedc' },
            meterNumber: { type: 'string', example: '12345678901' }
          },
          ['provider', 'meterNumber'],
          {
            provider: 'ekedc',
            meterNumber: '12345678901'
          }
        ),
        responses: {
          200: jsonResponse('Electricity customer details'),
          ...standardErrors
        }
      }
    },
    '/api/services/electricity/purchase': {
      post: {
        tags: ['Services'],
        summary: 'Buy electricity token',
        security: bearerSecurity,
        requestBody: body(
          {
            provider: { type: 'string', example: 'ekedc' },
            meterNumber: { type: 'string', example: '12345678901' },
            amount: amountProperty
          },
          ['provider', 'meterNumber', 'amount'],
          {
            provider: 'ekedc',
            meterNumber: '12345678901',
            amount: 5000
          }
        ),
        responses: {
          201: jsonResponse('Electricity purchase successful'),
          ...standardErrors
        }
      }
    },
    '/api/services/education/products': {
      get: {
        tags: ['Services'],
        summary: 'List education products',
        security: bearerSecurity,
        responses: {
          200: jsonResponse('Education products'),
          ...standardErrors
        }
      }
    },
    '/api/services/education/purchase': {
      post: {
        tags: ['Services'],
        summary: 'Buy an education product',
        security: bearerSecurity,
        requestBody: body(
          {
            productId: { type: 'string', example: 'waec-result-checker' }
          },
          ['productId'],
          {
            productId: 'waec-result-checker'
          }
        ),
        responses: {
          201: jsonResponse('Education purchase successful'),
          ...standardErrors
        }
      }
    },
    '/api/services/airtime-to-cash/quote': {
      post: {
        tags: ['Services'],
        summary: 'Get an airtime-to-cash quote',
        security: bearerSecurity,
        requestBody: body(
          {
            amount: amountProperty
          },
          ['amount'],
          {
            amount: 1000
          }
        ),
        responses: {
          200: jsonResponse('Airtime-to-cash quote'),
          ...standardErrors
        }
      }
    },
    '/api/services/airtime-to-cash/submit': {
      post: {
        tags: ['Services'],
        summary: 'Submit an airtime-to-cash request',
        security: bearerSecurity,
        requestBody: body(
          {
            network: { type: 'string', example: 'mtn' },
            phone: phoneProperty,
            amount: amountProperty
          },
          ['network', 'phone', 'amount'],
          {
            network: 'mtn',
            phone: '08012345678',
            amount: 1000
          }
        ),
        responses: {
          201: jsonResponse('Airtime-to-cash request submitted'),
          ...standardErrors
        }
      }
    },
    '/api/services/airtime-to-cash/{id}': {
      get: {
        tags: ['Services'],
        summary: 'Get an airtime-to-cash request',
        security: bearerSecurity,
        parameters: [pathParam('id', 'Airtime-to-cash request MongoDB ObjectId')],
        responses: {
          200: jsonResponse('Airtime-to-cash request details'),
          ...standardErrors
        }
      }
    },
    '/api/notifications': {
      get: {
        tags: ['Notifications'],
        summary: 'List notifications',
        security: bearerSecurity,
        responses: {
          200: jsonResponse('Notifications'),
          ...standardErrors
        }
      }
    },
    '/api/notifications/{id}/read': {
      patch: {
        tags: ['Notifications'],
        summary: 'Mark a notification as read',
        security: bearerSecurity,
        parameters: [pathParam('id', 'Notification MongoDB ObjectId')],
        responses: {
          200: jsonResponse('Notification marked as read'),
          ...standardErrors
        }
      }
    },
    '/api/referrals': {
      get: {
        tags: ['Referrals'],
        summary: 'Get referral details',
        security: bearerSecurity,
        responses: {
          200: jsonResponse('Referral details'),
          ...standardErrors
        }
      }
    },
    '/api/referrals/invite': {
      post: {
        tags: ['Referrals'],
        summary: 'Create a referral invite message',
        security: bearerSecurity,
        requestBody: body(
          {
            recipient: { type: 'string', example: 'friend@example.com' }
          },
          ['recipient'],
          {
            recipient: 'friend@example.com'
          }
        ),
        responses: {
          200: jsonResponse('Referral invite prepared'),
          ...standardErrors
        }
      }
    },
    '/api/support/tickets': {
      get: {
        tags: ['Support'],
        summary: 'List support tickets',
        security: bearerSecurity,
        responses: {
          200: jsonResponse('Support tickets'),
          ...standardErrors
        }
      },
      post: {
        tags: ['Support'],
        summary: 'Create a support ticket',
        security: bearerSecurity,
        requestBody: body(
          {
            subject: { type: 'string', example: 'Unable to buy airtime' },
            message: {
              type: 'string',
              example: 'The airtime purchase failed but my wallet was debited.'
            }
          },
          ['subject', 'message'],
          {
            subject: 'Unable to buy airtime',
            message: 'The airtime purchase failed but my wallet was debited.'
          }
        ),
        responses: {
          201: jsonResponse('Support ticket created'),
          ...standardErrors
        }
      }
    },
    '/api/legal': {
      get: {
        tags: ['Legal'],
        summary: 'Get legal content links and summaries',
        responses: {
          200: jsonResponse('Legal content'),
          ...standardErrors
        }
      }
    }
  },
  components: {
    securitySchemes: {
      bearerAuth: {
        type: 'http',
        scheme: 'bearer',
        bearerFormat: 'JWT'
      }
    },
    schemas: {
      ApiSuccess: {
        type: 'object',
        properties: {
          success: { type: 'boolean', example: true },
          message: { type: 'string', nullable: true },
          data: { type: 'object' }
        }
      },
      ApiError: {
        type: 'object',
        properties: {
          success: { type: 'boolean', example: false },
          message: { type: 'string', example: 'Invalid request' },
          details: { type: 'object', nullable: true }
        }
      },
      AuthResponse: {
        type: 'object',
        properties: {
          success: { type: 'boolean', example: true },
          message: { type: 'string', example: 'Login successful' },
          data: {
            type: 'object',
            properties: {
              token: { type: 'string' },
              user: { $ref: '#/components/schemas/User' }
            }
          }
        }
      },
      User: {
        type: 'object',
        properties: {
          id: { type: 'string' },
          fullName: { type: 'string' },
          email: { type: 'string', format: 'email' },
          phone: { type: 'string' },
          tranzgoId: { type: 'string' },
          referralCode: { type: 'string' },
          status: { type: 'string' },
          profileImageUrl: { type: 'string', nullable: true }
        }
      },
      Wallet: {
        type: 'object',
        properties: {
          currency: { type: 'string', example: 'NGN' },
          balance: { type: 'string', example: '1000.00' },
          balanceKobo: { type: 'integer', example: 100000 },
          lockedBalance: { type: 'string', example: '0.00' },
          lockedBalanceKobo: { type: 'integer', example: 0 }
        }
      },
      Transaction: {
        type: 'object',
        properties: {
          id: { type: 'string' },
          reference: { type: 'string' },
          type: { type: 'string' },
          direction: { type: 'string', enum: ['credit', 'debit'] },
          amountKobo: { type: 'integer' },
          balanceAfterKobo: { type: 'integer' },
          status: { type: 'string' },
          description: { type: 'string' },
          metadata: { type: 'object' },
          createdAt: { type: 'string', format: 'date-time' }
        }
      }
    }
  }
};
