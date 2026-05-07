'use strict';
const { loginUser, signupUser } = require('../services/identity.service');

/**
 * POST /api/login
 * Validates body, forwards credentials to identity-service, returns JWT.
 */
const login = async (req, res, next) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({ error: 'email and password are required' });
    }

    const result = await loginUser({ email, password });
    return res.status(200).json(result);
  } catch (err) {
    next(err);
  }
};

/**
 * POST /api/signup
 * Validates body, forwards registration payload to identity-service.
 */
const signup = async (req, res, next) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({ error: 'email and password are required' });
    }

    const result = await signupUser({ email, password });
    return res.status(201).json(result);
  } catch (err) {
    next(err);
  }
};

module.exports = { login, signup };
