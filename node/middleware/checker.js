const db = require("../config/database");

module.exports = async (req, res, next) => {
  try {
    const { table_id, start_time, end_time } = req.body;
    if (new Date(start_time) < new Date()) {
      return res.status(400).json({ error: "Past time" });
    }

    const { rows } = await db.query(
      `
        SELECT id, start_time, end_time
        FROM reservations
        WHERE table_id = $1 AND start_time < $3 AND end_time > $2
      `,
      [table_id, start_time, end_time]
    );

    if (rows.length) {
      return res.json({ status: "conflict", conflicting_reservations: rows });
    }

    next();
  } catch (e) {
    res.status(500).json({ error: "Internal" });
  }
};
