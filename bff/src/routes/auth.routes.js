'use strict';
const { Router } = require('express');
const { login, signup } = require('../controllers/auth.controller');

const router = Router();

// POST /api/login
router.post('/login', login);

// POST /api/signup
router.post('/signup', signup);

module.exports = router;
