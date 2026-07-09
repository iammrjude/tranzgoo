const mongoose = require('mongoose');

const notificationPreferencesSchema = new mongoose.Schema(
  {
    accountUpdates: {
      type: Boolean,
      default: true
    },
    transactions: {
      type: Boolean,
      default: true
    },
    promotions: {
      type: Boolean,
      default: false
    },
    securityAlerts: {
      type: Boolean,
      default: true
    }
  },
  {
    _id: false
  }
);

const userSchema = new mongoose.Schema(
  {
    fullName: {
      type: String,
      required: true,
      trim: true
    },
    email: {
      type: String,
      required: true,
      unique: true,
      lowercase: true,
      trim: true,
      index: true
    },
    phone: {
      type: String,
      required: true,
      trim: true
    },
    passwordHash: {
      type: String,
      required: true,
      select: false
    },
    tranzgoId: {
      type: String,
      required: true,
      unique: true,
      uppercase: true,
      index: true
    },
    profileImageUrl: {
      type: String,
      default: ''
    },
    referralCode: {
      type: String,
      required: true,
      unique: true,
      uppercase: true,
      index: true
    },
    referredBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      default: null
    },
    role: {
      type: String,
      enum: ['user', 'admin'],
      default: 'user'
    },
    status: {
      type: String,
      enum: ['active', 'blocked'],
      default: 'active'
    },
    lastLoginAt: {
      type: Date,
      default: null
    },
    passwordChangedAt: {
      type: Date,
      default: null
    },
    resetPasswordTokenHash: {
      type: String,
      default: '',
      select: false
    },
    resetPasswordExpiresAt: {
      type: Date,
      default: null,
      select: false
    },
    notificationPreferences: {
      type: notificationPreferencesSchema,
      default: () => ({})
    }
  },
  {
    timestamps: true
  }
);

userSchema.methods.toSafeObject = function toSafeObject() {
  return {
    id: this._id.toString(),
    fullName: this.fullName,
    email: this.email,
    phone: this.phone,
    tranzgoId: this.tranzgoId,
    profileImageUrl: this.profileImageUrl,
    referralCode: this.referralCode,
    role: this.role,
    status: this.status,
    lastLoginAt: this.lastLoginAt,
    passwordChangedAt: this.passwordChangedAt,
    notificationPreferences: this.notificationPreferences,
    createdAt: this.createdAt,
    updatedAt: this.updatedAt
  };
};

module.exports = mongoose.models.User || mongoose.model('User', userSchema);
