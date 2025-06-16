require("dotenv/config");

const { Pool } = require("pg");

const pgConnection = {
  user: process.env.DB_USER || "127.0.0.1",
  host: process.env.DB_HOST || "localhost",
  database: process.env.DB_DATABASE || "db_restaurant",
  password: process.env.DB_PASSWORD || "Dragonking7",
  port: process.env.DB_PORT || 5432,
  ssl: {
    sslmode: "require",
    rejectUnauthorized: false,
  },
};

const pool = new Pool(pgConnection);

(module.exports = pool), { pgConnection };
