'use strict';
const { searchSalaries } = require('../services/search.service');

/**
 * GET /api/search
 * Accepts optional query params: company, role, experience, location.
 * Forwards them directly to search-service and returns the result array.
 */
const search = async (req, res, next) => {
  try {
    const { q, company, role, experience, location, country, city, level, techStack, minSalary, maxSalary, page, size } = req.query;
    const filters = {};

    if (q)          filters.q          = String(q).trim();
    if (company)    filters.company    = String(company).trim();
    if (role)       filters.role       = String(role).trim();
    if (location)   filters.location   = String(location).trim();
    if (experience) filters.experience = Number(experience);
    if (country)    filters.country    = String(country).trim();
    if (city)       filters.city       = String(city).trim();
    if (level)      filters.level      = String(level).trim();
    if (techStack)  filters.techStack  = String(techStack).trim();
    if (minSalary)  filters.minSalary  = Number(minSalary);
    if (maxSalary)  filters.maxSalary  = Number(maxSalary);
    if (page)       filters.page       = Number(page);
    if (size)       filters.size       = Number(size);

    const results = await searchSalaries(filters);
    return res.status(200).json(results);
  } catch (err) {
    next(err);
  }
};

module.exports = { search };
