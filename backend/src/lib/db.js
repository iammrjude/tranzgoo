const mongoose = require('mongoose');

const cached = global.__tranzgooMongoose || {
  connection: null,
  promise: null
};

global.__tranzgooMongoose = cached;

async function connectDb() {
  if (cached.connection) {
    return cached.connection;
  }

  const uri = process.env.MONGODB_URI;

  if (!uri) {
    throw new Error('MONGODB_URI is not configured');
  }

  if (!cached.promise) {
    cached.promise = mongoose.connect(uri, {
      bufferCommands: false
    });
  }

  cached.connection = await cached.promise;
  return cached.connection;
}

module.exports = {
  connectDb
};
