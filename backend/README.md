# TranzGOO API

Node.js API for the TranzGOO Flutter app. It is designed to run locally with Vercel CLI and deploy to Vercel as serverless functions.

## What This Backend Includes

- Email/password registration and login
- JWT-protected user profile route
- Wallet balance and funding account routes
- Wallet transfer to another TranzGOO ID
- Transaction history
- Mock service catalogs and purchase endpoints for airtime, data, cable, electricity, education, and airtime-to-cash
- Basic notifications, referrals, support tickets, and legal content routes

The service purchase endpoints currently simulate purchases by debiting the user's wallet and creating a transaction. Real telecom, bill payment, and virtual account providers can be connected later.

## Requirements

- Node.js 18 or newer
- MongoDB Atlas database
- Vercel CLI for local serverless development

## Local Setup

From the repository root:

```powershell
cd backend
npm install
Copy-Item .env.example .env
```

Edit `backend/.env` and set:

```text
MONGODB_URI=your-mongodb-atlas-connection-string
JWT_SECRET=a-long-random-secret
JWT_EXPIRES_IN=7d
CORS_ORIGIN=http://localhost:3000
```

Start the API locally:

```powershell
npm install -g vercel
npm run dev
```

Vercel CLI usually serves the API at:

```text
http://localhost:3000/api/health
```

## Deploy To Vercel

1. Push this repository to GitHub.
2. In Vercel, create a new project.
3. Choose this repo.
4. Set the root directory to:

```text
backend
```

5. Add environment variables in Vercel Project Settings:

```text
MONGODB_URI
JWT_SECRET
JWT_EXPIRES_IN
CORS_ORIGIN
NODE_ENV=production
```

6. Deploy.

After deployment, test:

```text
https://your-vercel-domain.vercel.app/api/health
```

Useful official docs:

- Vercel Node.js Runtime: <https://vercel.com/docs/functions/runtimes/node-js>
- Vercel Environment Variables: <https://vercel.com/docs/environment-variables>
- MongoDB Atlas free cluster: <https://www.mongodb.com/docs/atlas/tutorial/deploy-free-tier-cluster>

## Main Routes

### Auth

```text
POST /api/auth/register
POST /api/auth/login
GET  /api/auth/me
```

### User

```text
GET   /api/user/me
PATCH /api/user/me
GET   /api/users/lookup/:tranzgoId
```

### Wallet

```text
GET  /api/wallet
GET  /api/wallet/funding-accounts
POST /api/wallet/transfer
```

### Transactions

```text
GET /api/transactions
GET /api/transactions/:id
```

### Services

```text
GET  /api/services
GET  /api/services/airtime/networks
POST /api/services/airtime/purchase
GET  /api/services/data/networks
GET  /api/services/data/plans?network=mtn
POST /api/services/data/purchase
GET  /api/services/cable/providers
GET  /api/services/cable/packages?provider=dstv
POST /api/services/cable/validate
POST /api/services/cable/purchase
GET  /api/services/electricity/providers
POST /api/services/electricity/validate-meter
POST /api/services/electricity/purchase
GET  /api/services/education/products
POST /api/services/education/purchase
POST /api/services/airtime-to-cash/quote
POST /api/services/airtime-to-cash/submit
GET  /api/services/airtime-to-cash/:id
```

### Other

```text
GET   /api/notifications
PATCH /api/notifications/:id/read
GET   /api/referrals
POST  /api/referrals/invite
POST  /api/support/tickets
GET   /api/legal
```

## Auth Header

Protected routes require:

```text
Authorization: Bearer YOUR_JWT_TOKEN
```

## Example Register Request

```json
{
  "fullName": "John Doe",
  "email": "john@example.com",
  "phone": "08012345678",
  "password": "secret123",
  "confirmPassword": "secret123"
}
```

## Example Login Request

```json
{
  "email": "john@example.com",
  "password": "secret123"
}
```

## Notes

- Do not commit `backend/.env`.
- MongoDB connection strings and JWT secrets must be stored as environment variables.
- For production wallet funding, connect a payment provider or virtual account provider and replace the demo funding-account response.
