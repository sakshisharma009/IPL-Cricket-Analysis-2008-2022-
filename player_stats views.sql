CREATE VIEW player_batting_stats AS
SELECT
    batter AS player,
    COUNT(DISTINCT mc.id) AS matches_played,
    SUM(d.batsman_run) AS total_runs,
    COUNT(CASE WHEN d.extra_type = 'NA' THEN 1 END) AS balls_faced,
    ROUND(SUM(d.batsman_run) * 100.0 / NULLIF(COUNT(CASE WHEN d.extra_type = 'NA' THEN 1 END), 0), 1) AS strike_rate,
    SUM(CASE WHEN d.batsman_run = 4 THEN 1 ELSE 0 END) AS fours,
    SUM(CASE WHEN d.batsman_run = 6 THEN 1 ELSE 0 END) AS sixes,
    ROUND(SUM(d.batsman_run)::DECIMAL / NULLIF(COUNT(DISTINCT mc.id), 0), 1) AS batting_average
FROM deliveries d
JOIN matches_clean mc ON d.id = mc.id
GROUP BY batter;

CREATE VIEW player_bowling_stats AS
SELECT
    bowler AS player,
    COUNT(DISTINCT mc.id) AS matches_played,
    SUM(CASE WHEN is_wicket_delivery = 1 
        AND kind NOT IN ('run out', 'retired hurt', 'obstructing the field') 
        THEN 1 ELSE 0 END) AS total_wickets,
    COUNT(CASE WHEN extra_type = 'NA' THEN 1 END) AS balls_bowled,
    ROUND(SUM(total_run) * 6.0 / NULLIF(COUNT(CASE WHEN extra_type = 'NA' THEN 1 END), 0), 2) AS economy_rate,
    ROUND(COUNT(CASE WHEN extra_type = 'NA' THEN 1 END)::DECIMAL / 
        NULLIF(SUM(CASE WHEN is_wicket_delivery = 1 
        AND kind NOT IN ('run out', 'retired hurt', 'obstructing the field') 
        THEN 1 ELSE 0 END), 0), 1) AS bowling_strike_rate
FROM deliveries d
JOIN matches_clean mc ON d.id = mc.id
GROUP BY bowler;