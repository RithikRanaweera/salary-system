'use strict';
const axios = require('axios');
const { voteServiceUrl } = require('../config');

const client = axios.create({ baseURL: voteServiceUrl });

const castVote = async (payload, authHeader) => {
  const { data } = await client.post('/votes', payload, {
    headers: { 'Authorization': authHeader },
  });
  return data;
};

const fetchVoteCount = async (submissionId) => {
  const { data } = await client.get(`/votes/${submissionId}/count`);
  return data;
};

module.exports = { castVote, fetchVoteCount };