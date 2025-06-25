const { pool: db } = require("../config/database");
const { RESERVATION_STATUS, API_STATUS, ERROR_MESSAGES } = require("../helpers/constants");

/**
 * Check for overlapping reservations for a specific table
 *
 * @param {number} tableId - The ID of the table to check
 * @param {string} startTime - Reservation start time
 * @param {string} endTime - Reservation end time
 * @returns {Promise<Array>} - Array of conflicting reservations or empty array if none
 */
const checkOverlappingReservations = async (tableId, startTime, endTime) => {
  try {
    const { rows } = await db.query(
      `
        SELECT id, user_id, table_id, start_time, end_time, status
        FROM reservations
        WHERE table_id = $1 AND start_time < $3 AND end_time > $2
      `,
      [tableId, startTime, endTime]
    );

    return rows;
  } catch (error) {
    console.error("Error checking reservation conflicts:", error);
    throw new Error("Failed to check reservation conflicts");
  }
};

/**
 * Creates a new reservation in the database
 *
 * @param {Object} params - Reservation parameters
 * @param {number} params.userId - User ID making the reservation
 * @param {number} params.tableId - ID of the allocated table
 * @param {string} params.startTime - Start time of the reservation (YYYY-MM-DD HH:MM:SS format)
 * @param {string} params.endTime - End time of the reservation (YYYY-MM-DD HH:MM:SS format)
 * @returns {Promise<Object>} - The created reservation record
 */
const createReservation = async ({ userId, tableId, startTime, endTime }) => {
  const { rows } = await db.query(
    `INSERT INTO reservations (id, user_id, table_id, start_time, end_time, status)
     VALUES (nextval('reservations_id_seq'), $1, $2, $3, $4, $5) 
     RETURNING *`,
    [userId, tableId, startTime, endTime, RESERVATION_STATUS.PENDING]
  );

  return rows[0];
};

/**
 * Validates a reservation request and creates it if valid
 *
 * @param {Object} params - Reservation validation parameters
 * @param {number} params.userId - User ID making the reservation
 * @param {number} params.tableId - ID of the allocated table
 * @param {string} params.startTime - Start time of the reservation
 * @param {string} params.endTime - End time of the reservation
 * @returns {Promise<Object>} - Result object with status, reservation or conflicts
 */
const validateAndCreateReservation = async ({ userId, tableId, startTime, endTime }) => {
  // Check for past reservations
  if (new Date(startTime) < new Date()) {
    return {
      status: API_STATUS.ERROR,
      error: ERROR_MESSAGES.PAST_TIME,
    };
  }

  // Check for conflicts
  const conflicts = await checkOverlappingReservations(tableId, startTime, endTime);
  if (conflicts && conflicts.length > 0) {
    return {
      status: API_STATUS.CONFLICT,
      conflicting_reservations: conflicts,
    };
  }

  // Create reservation if no conflicts
  const reservation = await createReservation({ userId, tableId, startTime, endTime });
  return {
    status: API_STATUS.SUCCESS,
    reservation,
  };
};

module.exports = {
  createReservation,
  checkOverlappingReservations,
  validateAndCreateReservation,
};
