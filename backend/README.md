# TranzGOO API

Node.js API for the TranzGOO Flutter app. It runs locally with a small Node server and deploys to Vercel as one catch-all Serverless Function.

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

- Node.js 24.x
- MongoDB Atlas database

## Project Structure

```text
api/index.js        One Vercel Serverless Function entrypoint
routes/             Internal route handlers kept as separate files
src/router.js       Dispatches /api/* requests to the right handler
src/openapi.js      OpenAPI document used by Swagger UI
```

This keeps the code organized across 35 handler files while Vercel only counts one deployed Serverless Function.

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
APP_NAME=TranzGOO

# Required in production for forgot-password emails
SMTP_HOST=smtp.example.com
SMTP_PORT=587
SMTP_SECURE=false
SMTP_USER=your-smtp-username
SMTP_PASS=your-smtp-password
MAIL_FROM="TranzGOO <no-reply@example.com>"

# Optional. Adds ?token=... links to reset emails.
PASSWORD_RESET_URL=https://your-app.example.com/reset-password
```

Start the API locally:

```powershell
npm run dev
```

The local server serves the API at:

```text
http://localhost:3000/
http://localhost:3000/api/health
http://localhost:3000/api/docs
http://localhost:3000/api/openapi.json
```

Validate the route setup:

```powershell
npm run check
```

That check confirms the Vercel function count stays under the Hobby plan limit.

## Deploy To Vercel

1. Push this repository to GitHub.
1. In Vercel, create a new project.
1. Choose this repo.
1. Set the root directory to:

```text
backend
```

1. Add environment variables in Vercel Project Settings:

```text
MONGODB_URI
JWT_SECRET
JWT_EXPIRES_IN
CORS_ORIGIN
NODE_ENV=production
APP_NAME
SMTP_HOST
SMTP_PORT
SMTP_SECURE
SMTP_USER
SMTP_PASS
MAIL_FROM
PASSWORD_RESET_URL
```

1. Deploy.

After deployment, test:

```text
https://your-vercel-domain.vercel.app/api/health
```

Useful official docs:

- Vercel Node.js Runtime: <https://vercel.com/docs/functions/runtimes/node-js>
- Vercel Environment Variables: <https://vercel.com/docs/environment-variables>
- MongoDB Atlas free cluster: <https://www.mongodb.com/docs/atlas/tutorial/deploy-free-tier-cluster>

## Main Routes

### Status And Docs

```text
GET /                         HTML API status page
GET /api/health               JSON health check
GET /api/docs                 Swagger UI documentation
GET /api/openapi.json         Raw OpenAPI document
```

### Auth

```text
POST /api/auth/register
POST /api/auth/login
POST /api/auth/forgot-password
POST /api/auth/verify-reset-code
POST /api/auth/reset-password
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

## Password Reset Email

`POST /api/auth/forgot-password` creates a 15-minute reset code. In
development, if SMTP is not configured, the API returns the code in the response
so the Flutter app can show a development reset code. In production,
Nodemailer sends the code through the SMTP settings above, and the API fails if
those settings are missing.

`POST /api/auth/verify-reset-code` checks that a reset code is valid and has not
expired before the app asks the user to choose a new password. The code remains
usable for the final `POST /api/auth/reset-password` call until it expires or the
password reset succeeds.

## Notes

- Do not commit `backend/.env`.
- MongoDB connection strings and JWT secrets must be stored as environment variables.
- For production wallet funding, connect a payment provider or virtual account provider and replace the demo funding-account response.
