-- Soal 4 – Query Optimization

SELECT * FROM reservations WHERE status = 'ordered' AND start_time >= NOW() - INTERVAL '30 days';
