'use strict';
const { Router } = require('express');
const { stats, topCompanies } = require('../controllers/stats.controller');

const router = Router();

// GET /api/stats
router.get('/stats', stats);

// GET /api/stats/top-companies
router.get('/stats/top-companies', topCompanies);

module.exports = router;
