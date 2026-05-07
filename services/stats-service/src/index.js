'use strict';

const express = require('express');
const { Pool } = require('pg');

const app = express();
const PORT = process.env.PORT || 8085;

// ── Postgres connection pool ─────────────────────────────────
const pool = new Pool({
  host:     process.env.DB_HOST     || 'localhost',
  port:     process.env.DB_PORT     || 5432,
  database: process.env.DB_NAME     || 'techsalary',
  user:     process.env.DB_USER     || 'techsalary',
  password: process.env.DB_PASSWORD || 'techsalary_pass',
});

// ── Health check ─────────────────────────────────────────────
app.get('/health', async (_req, res) => {
  try {
    await pool.query('SELECT 1');
    res.json({ status: 'UP' });
  } catch {
    res.status(503).json({ status: 'DOWN' });
  }
});

// ── GET /stats ───────────────────────────────────────────────
app.get('/stats', async (_req, res) => {
  try {
    const result = await pool.query(`
      SELECT
        COALESCE(AVG(gross_salary), 0)                       AS average,
        COALESCE(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY gross_salary), 0) AS median,
        COUNT(*)::int                                        AS total
      FROM salary.submissions
    `);

    const row = result.rows[0];
    res.json({
      average: parseFloat(Number(row.average).toFixed(2)),
      median:  parseFloat(Number(row.median).toFixed(2)),
      total:   row.total,
    });
  } catch (err) {
    console.error('Stats query failed:', err.message);
    res.status(500).json({ error: 'Failed to fetch stats' });
  }
});

// ── GET /stats/top-companies ─────────────────────────────────
app.get('/stats/top-companies', async (_req, res) => {
  try {
    const result = await pool.query(`
      SELECT company, ROUND(AVG(gross_salary))::int AS avg_salary
      FROM salary.submissions
      GROUP BY company
      ORDER BY avg_salary DESC
      LIMIT 5
    `);
    res.json(result.rows);
  } catch (err) {
    console.error('Top companies query failed:', err.message);
    res.status(500).json({ error: 'Failed to fetch top companies' });
  }
});

// ── Start server ─────────────────────────────────────────────
app.listen(PORT, () => {
  console.log(`stats-service listening on port ${PORT}`);
});
