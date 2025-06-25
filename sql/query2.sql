-- Soal 2 – Query Peak Time Slot Analysis
WITH hourly_reservations AS (
    SELECT DATE(start_time) AS date, TO_CHAR(start_time, 'HH24:00') AS hour_slot, COUNT(*) AS reservation_count
    FROM reservations
    WHERE start_time >= CURRENT_DATE - INTERVAL '14 days'
    GROUP BY DATE(start_time), TO_CHAR(start_time, 'HH24:00')
),
peak_hours AS (
    SELECT date, hour_slot, reservation_count,
        ROW_NUMBER() OVER (
            PARTITION BY date
            ORDER BY reservation_count DESC
        ) AS rank
    FROM hourly_reservations
)
SELECT date, hour_slot, reservation_count
FROM peak_hours
WHERE rank = 1
ORDER BY date DESC, reservation_count DESC;
