'use strict';
const axios = require('axios');
const { identityServiceUrl } = require('../config');

const client = axios.create({ baseURL: identityServiceUrl });

/**
 * Calls the identity-service POST /login endpoint.
 * @param {{ email: string, password: string }} credentials
 * @returns {Promise<{ token: string, user: object }>}
 */
const loginUser = async (credentials) => {
  const { data } = await client.post('/auth/login', credentials);
  return data;
};

/**
 * Calls the identity-service POST /auth/signup endpoint.
 * @param {{ email: string, password: string }} payload
 * @returns {Promise<object>}
 */
const signupUser = async (payload) => {
  const { data } = await client.post('/auth/signup', payload);
  return data;
};

module.exports = { loginUser, signupUser };
