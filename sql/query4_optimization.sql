-- Soal 4 – Query Optimization

SET enable_seqscan = off;
EXPLAIN ANALYZE
SELECT * FROM reservations WHERE status = 'ordered' AND start_time >= NOW() - INTERVAL '30 days';

-- Creating Index For Optimization ( Indexing )
CREATE INDEX IF NOT EXISTS idx_reservations_status_start_time ON reservations(status, start_time);

EXPLAIN ANALYZE
SELECT * FROM reservations WHERE status = 'ordered' AND start_time >= NOW() - INTERVAL '30 days';
