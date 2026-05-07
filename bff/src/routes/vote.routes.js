'use strict';
const { Router } = require('express');
const { authenticate } = require('../middleware/auth.middleware');
const { vote, getVoteCount } = require('../controllers/vote.controller'); 

const router = Router();

// POST /api/vote  (authentication REQUIRED)
router.post('/vote', authenticate, vote);

// GET /api/votes/:id/count  (no auth needed)
router.get('/votes/:id/count', getVoteCount);

module.exports = router;
