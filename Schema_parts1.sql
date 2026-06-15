CREATE INDEX idx_del_batter  ON deliveries(batter);
CREATE INDEX idx_del_bowler  ON deliveries(bowler);
CREATE INDEX idx_del_match   ON deliveries(id);
CREATE INDEX idx_del_team    ON deliveries(batting_team);


-- Before adding index, you'd see "Seq Scan" (sequential = full scan)
-- After adding index, you'll see "Index Scan"
EXPLAIN ANALYZE
SELECT SUM(batsman_run) 
FROM deliveries 
WHERE batter = 'V Kohli';