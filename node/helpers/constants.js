/**
 * Application-wide constants
 */

// Default values
const DEFAULT_PORT = 3000;
const DEFAULT_RESERVATION_DURATION = 60; // minutes

// Reservation status constants
const RESERVATION_STATUS = {
  PENDING: "pending",
  CONFIRMED: "confirmed",
  CANCELLED: "cancelled",
  COMPLETED: "completed",
};

// API response status constants
const API_STATUS = {
  SUCCESS: "success",
  ERROR: "error",
  CONFLICT: "conflict",
};

// Error messages
const ERROR_MESSAGES = {
  PAST_TIME: "Cannot create reservation in the past",
  NO_TABLE: "No table available",
  INTERNAL: "An internal server error occurred",
};

module.exports = {
  RESERVATION_STATUS,
  API_STATUS,
  DEFAULT_PORT,
  DEFAULT_RESERVATION_DURATION,
  ERROR_MESSAGES,
};
