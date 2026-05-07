'use strict';

const express = require('express');
const { Pool } = require('pg');

const app = express();
const PORT = process.env.PORT || 8084;

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

// ── GET /search ──────────────────────────────────────────────
// Query params: company, role, location, experience, level,
//               country, city, techStack, minSalary, maxSalary,
//               sortBy (salary|date), sortDir (asc|desc),
//               page (0-indexed), size
app.get('/search', async (req, res) => {
  try {
    const {
      q, company, role, location, experience, level,
      country, city, techStack,
      minSalary, maxSalary,
      sortBy = 'date', sortDir = 'desc',
      page = '0', size = '20',
    } = req.query;

    const conditions = [];
    const params = [];
    let idx = 1;

    // q — general search: matches company OR job_title
    if (q) {
      conditions.push(`(s.company ILIKE $${idx} OR s.job_title ILIKE $${idx})`);
      params.push(`%${q}%`);
      idx++;
    }

    // company — partial match (ILIKE)
    if (company) {
      conditions.push(`s.company ILIKE $${idx++}`);
      params.push(`%${company}%`);
    }

    // role / job_title — partial match (ILIKE)
    if (role) {
      conditions.push(`s.job_title ILIKE $${idx++}`);
      params.push(`%${role}%`);
    }

    // location — matches country OR city
    if (location) {
      conditions.push(`(s.country ILIKE $${idx} OR s.city ILIKE $${idx})`);
      params.push(`%${location}%`);
      idx++;
    }

    // country — exact match (case-insensitive)
    if (country) {
      conditions.push(`LOWER(s.country) = LOWER($${idx++})`);
      params.push(country);
    }

    // city — partial match
    if (city) {
      conditions.push(`s.city ILIKE $${idx++}`);
      params.push(`%${city}%`);
    }

    // experience_years — exact match
    if (experience) {
      conditions.push(`s.experience_years = $${idx++}`);
      params.push(Number(experience));
    }

    // level — exact match (JUNIOR, MID, SENIOR, etc.)
    if (level) {
      conditions.push(`UPPER(s.level) = UPPER($${idx++})`);
      params.push(level);
    }

    // tech stack — array contains (case-insensitive)
    if (techStack) {
      conditions.push(`EXISTS (SELECT 1 FROM unnest(s.tech_stack) AS t WHERE t ILIKE $${idx++})`);
      params.push(`%${techStack}%`);
    }

    // salary range
    if (minSalary) {
      conditions.push(`s.gross_salary >= $${idx++}`);
      params.push(Number(minSalary));
    }
    if (maxSalary) {
      conditions.push(`s.gross_salary <= $${idx++}`);
      params.push(Number(maxSalary));
    }

    const whereClause = conditions.length > 0
      ? 'WHERE ' + conditions.join(' AND ')
      : '';

    // Sorting
    const sortColumns = {
      salary: 's.gross_salary',
      date:   's.submitted_at',
      title:  's.job_title',
      company:'s.company',
    };
    const orderCol = sortColumns[sortBy] || 's.submitted_at';
    const orderDir = sortDir === 'asc' ? 'ASC' : 'DESC';

    // Pagination
    const pageNum  = Math.max(0, parseInt(page, 10) || 0);
    const pageSize = Math.min(100, Math.max(1, parseInt(size, 10) || 20));
    const offset   = pageNum * pageSize;

    // Count query
    const countResult = await pool.query(
      `SELECT COUNT(*)::int AS total FROM salary.submissions s ${whereClause}`,
      params,
    );
    const total = countResult.rows[0].total;

    // Data query
    const dataResult = await pool.query(
      `SELECT
         s.id, s.job_title, s.company, s.country, s.city,
         s.experience_years, s.level, s.gross_salary, s.currency,
         s.tech_stack, s.status, s.anonymize,
         s.submitted_at, s.approved_at
       FROM salary.submissions s
       ${whereClause}
       ORDER BY ${orderCol} ${orderDir}
       LIMIT ${pageSize} OFFSET ${offset}`,
      params,
    );

    const totalPages = Math.ceil(total / pageSize);

    res.json({
      results: dataResult.rows.map(row => ({
        id:              row.id,
        jobTitle:        row.job_title,
        company:         row.company,
        country:         row.country,
        city:            row.city,
        experienceYears: row.experience_years,
        level:           row.level,
        grossSalary:     parseFloat(row.gross_salary),
        currency:        row.currency,
        techStack:       row.tech_stack || [],
        status:          row.status,
        submittedAt:     row.submitted_at,
        approvedAt:      row.approved_at,
      })),
      page:          pageNum,
      size:          pageSize,
      totalElements: total,
      totalPages,
      hasNext:       pageNum < totalPages - 1,
      hasPrevious:   pageNum > 0,
    });
  } catch (err) {
    console.error('Search query failed:', err.message);
    res.status(500).json({ error: 'Failed to execute search' });
  }
});

// ── GET /search/filters ──────────────────────────────────────
app.get('/search/filters', async (_req, res) => {
  try {
    const [countries, companies, jobTitles, cities] = await Promise.all([
      pool.query('SELECT DISTINCT country FROM salary.submissions ORDER BY country'),
      pool.query('SELECT DISTINCT company FROM salary.submissions WHERE company IS NOT NULL ORDER BY company'),
      pool.query('SELECT DISTINCT job_title FROM salary.submissions ORDER BY job_title'),
      pool.query('SELECT DISTINCT city FROM salary.submissions WHERE city IS NOT NULL ORDER BY city'),
    ]);

    res.json({
      countries: countries.rows.map(r => r.country),
      companies: companies.rows.map(r => r.company),
      jobTitles: jobTitles.rows.map(r => r.job_title),
      cities:    cities.rows.map(r => r.city),
    });
  } catch (err) {
    console.error('Filters query failed:', err.message);
    res.status(500).json({ error: 'Failed to fetch filters' });
  }
});

// ── Start server ─────────────────────────────────────────────
app.listen(PORT, () => {
  console.log(`search-service listening on port ${PORT}`);
});
