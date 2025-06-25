const { DateTime } = require("luxon");

/**
 * Format a date to YYYY-MM-DD HH:MM:SS in Jakarta timezone
 * @param {Date|string} date - Date object or date string to format
 * @returns {string} Formatted date string in YYYY-MM-DD HH:MM:SS format
 */
const formatLocalTimezone = (date) => {
  return DateTime.fromJSDate(new Date(date))
    .setZone("Asia/Jakarta")
    .toFormat("yyyy-MM-dd HH:mm:ss");
};

/**
 * Add minutes to a date and return formatted string in Jakarta timezone
 * @param {Date|string} date - Starting date
 * @param {number} minutes - Minutes to add
 * @returns {string} Formatted date string in YYYY-MM-DD HH:MM:SS format
 */
const addMinutesAndFormat = (date, minutes) => {
  return DateTime.fromJSDate(new Date(date))
    .setZone("Asia/Jakarta")
    .plus({ minutes })
    .toFormat("yyyy-MM-dd HH:mm:ss");
};

module.exports = {
  formatLocalTimezone,
  addMinutesAndFormat,
};
