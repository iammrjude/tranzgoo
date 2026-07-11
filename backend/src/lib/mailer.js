const nodemailer = require('nodemailer');

let transporter;

function truthy(value) {
  return ['1', 'true', 'yes'].includes(String(value || '').toLowerCase());
}

function getSender() {
  return (
    process.env.MAIL_FROM ||
    process.env.SMTP_FROM ||
    process.env.EMAIL_FROM ||
    ''
  ).trim();
}

function hasMailTransport() {
  return Boolean(process.env.SMTP_HOST && getSender());
}

function getTransporter() {
  if (transporter) {
    return transporter;
  }

  const secure = truthy(process.env.SMTP_SECURE);
  const options = {
    host: process.env.SMTP_HOST,
    port: Number(process.env.SMTP_PORT || (secure ? 465 : 587)),
    secure
  };

  if (process.env.SMTP_USER || process.env.SMTP_PASS) {
    options.auth = {
      user: process.env.SMTP_USER,
      pass: process.env.SMTP_PASS
    };
  }

  transporter = nodemailer.createTransport(options);
  return transporter;
}

function escapeHtml(value) {
  return String(value)
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;')
    .replaceAll("'", '&#39;');
}

async function sendPasswordResetEmail({ to, resetToken, expiresInMinutes }) {
  const appName = process.env.APP_NAME || 'TranzGOO';
  const resetUrl = process.env.PASSWORD_RESET_URL
    ? `${process.env.PASSWORD_RESET_URL}?token=${encodeURIComponent(resetToken)}`
    : '';

  const textLines = [
    `Your ${appName} password reset code is:`,
    '',
    resetToken,
    '',
    `This code expires in ${expiresInMinutes} minutes.`,
    resetUrl ? `Reset link: ${resetUrl}` : '',
    '',
    'If you did not request this, you can ignore this email.'
  ].filter(Boolean);

  const htmlResetLink = resetUrl
    ? `<p><a href="${escapeHtml(resetUrl)}">Open password reset</a></p>`
    : '';

  await getTransporter().sendMail({
    from: getSender(),
    to,
    subject: `${appName} password reset code`,
    text: textLines.join('\n'),
    html: `
      <p>Your ${escapeHtml(appName)} password reset code is:</p>
      <p><strong>${escapeHtml(resetToken)}</strong></p>
      <p>This code expires in ${expiresInMinutes} minutes.</p>
      ${htmlResetLink}
      <p>If you did not request this, you can ignore this email.</p>
    `
  });
}

module.exports = {
  hasMailTransport,
  sendPasswordResetEmail
};
