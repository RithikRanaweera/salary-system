'use strict';
const jwt = require('jsonwebtoken');
const { jwtSecret } = require('../config');

/**
 * Extracts and verifies the JWT token from the Authorization header.
 * Attaches the decoded payload to req.user.
 * Returns 401 if the token is missing or invalid.
 */
const authenticate = (req, res, next) => {
  const authHeader = req.headers['authorization'];

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({ error: 'Unauthorized: missing token' });
  }

  const token = authHeader.split(' ')[1];

  try {
    const decoded = jwt.verify(token, jwtSecret);
    req.user = decoded;
    next();
  } catch (err) {
    const message =
      err.name === 'TokenExpiredError'
        ? 'Unauthorized: token expired'
        : 'Unauthorized: invalid token';
    return res.status(401).json({ error: message });
  }
};

module.exports = { authenticate };
