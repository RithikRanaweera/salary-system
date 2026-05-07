'use strict';
const { Router } = require('express');
const { search } = require('../controllers/search.controller');

const router = Router();

// GET /api/search?company=&role=&experience=&location=
router.get('/search', search);

module.exports = router;
