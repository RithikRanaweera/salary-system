'use strict';
const axios = require('axios');
const { searchServiceUrl } = require('../config');

const client = axios.create({ baseURL: searchServiceUrl });

/**
 * Calls the search-service with the provided filter query parameters.
 * @param {{ company?: string, role?: string, experience?: string, location?: string }} filters
 * @returns {Promise<object[]>}
 */
const searchSalaries = async (filters) => {
  const { data } = await client.get('/search', { params: filters });
  return data;
};

module.exports = { searchSalaries };
