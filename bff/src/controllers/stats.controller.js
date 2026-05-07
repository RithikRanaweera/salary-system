'use strict';
const { getStats, getTopCompanies } = require('../services/stats.service');

/**
 * GET /api/stats
 * Fetches aggregated salary statistics from stats-service.
 * Returns: { average, median, total }
 */
const stats = async (req, res, next) => {
  try {
    const result = await getStats();
    return res.status(200).json(result);
  } catch (err) {
    next(err);
  }
};

/**
 * GET /api/stats/top-companies
 */
const topCompanies = async (req, res, next) => {
  try {
    const result = await getTopCompanies();
    return res.status(200).json(result);
  } catch (err) {
    next(err);
  }
};

module.exports = { stats, topCompanies };
