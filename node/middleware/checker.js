const { checkOverlappingReservations } = require("../services/reservation-service");
const { API_STATUS, ERROR_MESSAGES } = require("../helpers/constants");

/**
 * Middleware to check for overlapping reservations
 */
const checkerMiddleware = async (req, res, next) => {
  try {
    const { table_id, start_time, end_time } = req.body;
    if (new Date(start_time) < new Date()) {
      return res.status(400).json({ error: ERROR_MESSAGES.PAST_TIME });
    }

    const rows = await checkOverlappingReservations(table_id, start_time, end_time);
    if (rows.length) {
      return res.json({
        status: API_STATUS.CONFLICT,
        conflicting_reservations: rows,
      });
    }

    next();
  } catch (e) {
    res.status(500).json({ error: ERROR_MESSAGES.INTERNAL });
  }
};

module.exports = {
  checker: checkerMiddleware,
};
