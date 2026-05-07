'use strict';
require('dotenv').config();
const express = require('express');
const rateLimit = require('express-rate-limit');

const authRoutes    = require('./routes/auth.routes');
const salaryRoutes  = require('./routes/salary.routes');
const voteRoutes    = require('./routes/vote.routes');
const searchRoutes  = require('./routes/search.routes');
const statsRoutes   = require('./routes/stats.routes');
const { errorHandler } = require('./middleware/error.middleware');
const { requestLogger } = require('./middleware/logger.middleware');

const app = express();

// ── Core Middleware ─────────────────────────────────────────────────────────
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// ── Request Logger ──────────────────────────────────────────────────────────
app.use(requestLogger);

// ── Rate Limiting ────200 requests / 15 min───────────────────────────────────────────────────────
// const limiter = rateLimit({
//   windowMs: 15 * 60 * 1000, // 15 minutes
//   max: 200,
//   standardHeaders: true,
//   legacyHeaders: false,
//   message: { error: 'Too many requests, please try again later.' },
// });
// app.use('/api', limiter);

const limiter = rateLimit({
  windowMs: 24 * 60 * 60 * 1000, // 24 hours
  max: 1000000,                  // 1 million requests
});
app.use('/api', limiter);

// ── Routes ──────────────────────────────────────────────────────────────────
app.use('/api', authRoutes);
app.use('/api/salary', salaryRoutes);
app.use('/api', voteRoutes);
app.use('/api', searchRoutes);
app.use('/api', statsRoutes);

// ── Health Check ─────────────────────────────────────────────────────────────
app.get('/health', (_req, res) => res.json({ status: 'ok', service: 'bff' }));

// ── 404 Handler ─────────────────────────────────────────────────────────────
app.use((_req, res) => {
  res.status(404).json({ error: 'Not found' });
});

// ── Global Error Handler ────────────────────────────────────────────────────
app.use(errorHandler);

module.exports = app;
