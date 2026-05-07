'use strict';
const { Router } = require('express');
const { submit } = require('../controllers/salary.controller');

const router = Router();

// POST /api/salary/submit  (no auth required — anonymous submissions allowed)
router.post('/submit', submit);

module.exports = router;
