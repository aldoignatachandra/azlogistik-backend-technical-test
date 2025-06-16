-- Soal 3 – Query Deteksi Overlapping Reservations

SELECT
    t.id AS table_id,
    t.name AS table_name,
    a.id AS reservation_id_1,
    a.start_time AS start_time_1,
    a.end_time AS end_time_1,
    b.id AS reservation_id_2,
    b.start_time AS start_time_2,
    b.end_time AS end_time_2
FROM public.reservations a
JOIN public.reservations b
    ON a.table_id = b.table_id
    AND a.id <> b.id
    AND a.start_time < b.start_time
    AND a.end_time > b.end_time
JOIN tables t ON t.id = a.table_id
WHERE a.id < b.id
ORDER BY table_id, start_time_1;
