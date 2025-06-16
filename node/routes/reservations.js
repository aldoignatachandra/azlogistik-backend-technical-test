const express = require("express");
const db = require("../config/database");
const { allocate } = require("../services/table-allocator");
const checker = require("../middleware/checker");
const router = express.Router();

// ( Soal 6 – Advanced Table Allocation System )
// Routes For Table Allocationm System
router.post("/allocate-table", async (req, res) => {
  const {
    user_id,
    party_size,
    requested_date,
    requested_time,
    duration_minutes,
  } = req.body;

  const start = `${requested_date} ${requested_time}`;
  const end = new Date(new Date(start).getTime() + duration_minutes * 60000).toISOString();

  // Find Available Table
  const table = await allocate({
    userId: user_id,
    size: party_size,
    start,
    end,
  });

  // Check Overlapping Reservation
  // const conflicts = await checker(table.id, start, end);
  // if (conflicts && conflicts.length) {
  //   return res.json({
  //     status: "conflict",
  //     conflicting_reservations: conflicts,
  //   });
  // }

  // Check If No Available Table
  if (!table) return res.status(409).json({ error: "No table" });

  // Create Reservation
  const { rows } = await db.query(
    `INSERT INTO reservations (id, user_id, table_id, start_time, end_time, status)
     VALUES (nextval('reservations_id_seq'), $1, $2, $3, $4, 'pending') RETURNING *`,
    [user_id, table.id, start, end]
  );

  res.json({ reservation: rows[0] });
});

// ( Soal 7 – Sistem Pengecekan Reservasi )
// Routes For Checker Reservation
router.post("/check", checker, (_req, res) =>
  res.json({ status: "available" })
);

module.exports = router;
