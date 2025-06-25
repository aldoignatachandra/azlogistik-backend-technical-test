// Load environment variables from .env file
require("dotenv").config();

// Import dependencies
const express = require("express");
const useragent = require("express-useragent");
const logger = require("./helpers/logger");
const { DEFAULT_PORT } = require("./helpers/constants");

// Import routes
const reservationRoutes = require("./routes/reservations");

// Initialize Express application
const app = express();

// Apply middleware
app.use(express.json({ limit: "50mb" }));
app.use(express.urlencoded({ limit: "50mb", extended: false }));
app.use(useragent.express());

// Register API routes
app.use("/api/reservation", reservationRoutes);

// Server configuration
const PORT = process.env.PORT || DEFAULT_PORT;
const CONTEXT = "app-listen";

// Start the server
app.listen(PORT, () => {
  logger.log(CONTEXT, `Server started, listening at port: ${PORT}`, "initiate application");
});
