'use strict';
const axios = require('axios');
const { salaryServiceUrl } = require('../config');

const client = axios.create({ baseURL: salaryServiceUrl });

/**
 * Forwards a salary submission to the salary-service.
 * @param {{ company: string, role: string, salary: number, experience: number, location?: string, anonymous: boolean }} payload
 * @returns {Promise<object>}
 */
const submitSalary = async (payload) => {
  const { data } = await client.post('/v1/salaries', payload);
  return data;
};

module.exports = { submitSalary };
