'use strict';
require('dotenv').config();
const express = require('express');
const app = require('./app');

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`[BFF] Server running on port ${PORT}`);
});
