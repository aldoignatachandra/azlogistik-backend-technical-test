const express = require("express");
const { allocate } = require("../services/table-allocator");
const { validateAndCreateReservation } = require("../services/reservation-service");
const { checker } = require("../middleware/checker");
const { addMinutesAndFormat } = require("../helpers/times");
const { API_STATUS, ERROR_MESSAGES } = require("../helpers/constants");

const router = express.Router();

// ( Soal 6 – Advanced Table Allocation System )
// Routes For Table Allocation System
router.post("/allocate-table", async (req, res) => {
  try {
    const { user_id, party_size, requested_date, requested_time, duration_minutes } = req.body;

    // Format for database and table allocation (local format)
    const start = `${requested_date} ${requested_time}:00`;
    const end = addMinutesAndFormat(start, duration_minutes);

    // Find Available Table
    const table = await allocate({
      userId: user_id,
      size: party_size,
      start,
      end,
    });

    // Check If No Available Table
    if (!table) return res.status(409).json({ error: ERROR_MESSAGES.NO_TABLE });

    // Validate and create reservation
    const result = await validateAndCreateReservation({
      userId: user_id,
      tableId: table.id,
      startTime: start,
      endTime: end,
    });

    if (result.status === API_STATUS.CONFLICT) {
      return res.status(409).json({
        status: API_STATUS.CONFLICT,
        conflicting_reservations: result.conflicting_reservations,
      });
    } else if (result.status === API_STATUS.ERROR) {
      return res.status(400).json({ error: result.error });
    }

    res.json({ reservation: result.reservation });
  } catch (error) {
    console.error("Error processing reservation:", error);
    res.status(500).json({ error: ERROR_MESSAGES.INTERNAL });
  }
});

// ( Soal 7 – Sistem Pengecekan Reservasi )
// Routes For Checker Reservation
router.post("/check", checker, (_req, res) => res.json({ status: API_STATUS.SUCCESS }));

module.exports = router;
