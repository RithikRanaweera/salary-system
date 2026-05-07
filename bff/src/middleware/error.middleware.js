'use strict';

/**
 * Global error handler.
 * Catches errors forwarded via next(err) throughout the app.
 * Returns a consistent { error: "message" } shape to the frontend.
 */
const errorHandler = (err, req, res, _next) => {
  // Log full error server-side only
  console.error(
    `[ERROR] ${req.method} ${req.originalUrl} — ${err.message}`,
    err.stack
  );

  // If the error came from an upstream microservice (axios), forward its status
  if (err.response) {
    const status = err.response.status || 502;
    const message =
      err.response.data?.error ||
      err.response.data?.message ||
      'Upstream service error';
    return res.status(status).json({ error: message });
  }

  // Generic server error
  const status = err.status || err.statusCode || 500;
  return res.status(status).json({ error: err.message || 'Internal server error' });
};

module.exports = { errorHandler };
