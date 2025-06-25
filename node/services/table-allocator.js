const { pool: db } = require("../config/database");

const isVip = async (userId) => {
  const { rows } = await db.query(
    `
    SELECT SUM(o.quantity * m.price) AS spend
    FROM reservations r
    JOIN orders o ON o.reservation_id = r.id
    JOIN menus  m ON m.id = o.menu_id
    WHERE r.user_id = $1 AND r.start_time >= CURRENT_DATE - INTERVAL '90 days'
  `,
    [userId]
  );
  return (rows[0].spend || 0) > 10_000_000;
};

const overlapClause = (start, end) => {
  return `
    NOT EXISTS (
      SELECT 1 FROM reservations
      WHERE table_id = t.id
        AND start_time < $2
        AND end_time   > $1
    )
  `;
};

const allocate = async ({ userId, size, start, end }) => {
  const vip = await isVip(userId);
  const baseSql = `
    SELECT t.*
    FROM tables t
    WHERE t.capacity >= $3 AND ${overlapClause(start, end)}
    ORDER BY
      ${vip ? `CASE WHEN t.id IN (1,3,5) THEN 0 ELSE 1 END,` : ""}
      t.capacity ASC,
      t.id % 2,         
      t.id
    LIMIT 1
  `;
  const { rows } = await db.query(baseSql, [start, end, size]);
  return rows[0] || null;
};

module.exports = { allocate };
