'use strict';
const { submitSalary } = require('../services/salary.service');

/**
 * POST /api/salary/submit
 * Validates required fields then forwards the submission to salary-service.
 * No authentication required — anonymous submissions are supported.
 */
const submit = async (req, res, next) => {
  try {
    const { jobTitle, company, country, city, experienceYears, level, grossSalary, currency, techStack, anonymize } = req.body;

    if (!jobTitle || grossSalary === undefined || !country) {
      return res.status(400).json({
        error: 'jobTitle, grossSalary, and country are required',
      });
    }

    if (isNaN(Number(grossSalary))) {
      return res.status(400).json({
        error: 'grossSalary must be numeric',
      });
    }

    const payload = {
      jobTitle:        String(jobTitle).trim(),
      company:         company ? String(company).trim() : null,
      country:         String(country).trim(),
      city:            city ? String(city).trim() : null,
      experienceYears: experienceYears != null ? Number(experienceYears) : null,
      level:           level || null,
      grossSalary:     Number(grossSalary),
      currency:        currency || 'LKR',
      techStack:       Array.isArray(techStack) ? techStack : [],
      anonymize:       anonymize !== false,
    };

    const result = await submitSalary(payload);
    return res.status(201).json(result);
  } catch (err) {
    next(err);
  }
};

module.exports = { submit };
