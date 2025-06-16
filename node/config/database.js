require("dotenv/config");

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

module.exports = { pgConnection };
