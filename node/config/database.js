require("dotenv/config");

const { Pool } = require("pg");

// PostgreSQL connection configuration
const pgConnection = {
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: process.env.DB_DATABASE,
  password: process.env.DB_PASSWORD,
  port: process.env.DB_PORT,
  ssl: {
    sslmode: "require",
    rejectUnauthorized: false,
  },
};

// PostgreSQL connection pool
const pool = new Pool(pgConnection);

// Export both the pool and connection config
module.exports = {
  pool,
  pgConnection,
};
