const axios = require('axios');
const db = require('../db/sqlite');
const { API_BASE } = require('./apiBase');

const apiClient = axios.create({
  baseURL: API_BASE,
});

apiClient.interceptors.request.use(async (config) => {
  const token = await db.getSetting('authToken');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

module.exports = apiClient;
