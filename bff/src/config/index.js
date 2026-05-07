'use strict';

/**
 * Centralised service URL configuration.
 * All URLs are sourced exclusively from environment variables —
 * they are never exposed to the frontend.
 */
module.exports = {
  identityServiceUrl : process.env.IDENTITY_SERVICE_URL || 'http://identity-service',
  salaryServiceUrl   : process.env.SALARY_SERVICE_URL   || 'http://salary-service',
  voteServiceUrl     : process.env.VOTE_SERVICE_URL      || 'http://vote-service',
  searchServiceUrl   : process.env.SEARCH_SERVICE_URL   || 'http://search-service',
  statsServiceUrl    : process.env.STATS_SERVICE_URL    || 'http://stats-service',
  jwtSecret          : process.env.JWT_SECRET            || 'changeme',
};
