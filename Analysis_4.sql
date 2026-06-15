--head to head comparisons between franchise
WITH standardised AS (
    SELECT
        COALESCE(tm1.standard_name, m.team1) AS team1_clean,
        COALESCE(tm2.standard_name, m.team2) AS team2_clean,
        COALESCE(tm_w.standard_name, m.winning_team) AS winner_clean
    FROM matches m
    LEFT JOIN team_mapping tm1 ON tm1.original_name = m.team1
    LEFT JOIN team_mapping tm2 ON tm2.original_name = m.team2
    LEFT JOIN team_mapping tm_w ON tm_w.original_name = m.winning_team
    WHERE m.winning_team IS NOT NULL
), 
	
	head_to_head AS( 
	SELECT
    LEAST(team1_clean, team2_clean) AS team_a,
    GREATEST(team1_clean, team2_clean) AS team_b,
    COUNT(*) AS total_matches,
    SUM(CASE WHEN winner_clean = LEAST(team1_clean, team2_clean) THEN 1 ELSE 0 END) AS team_a_wins,
    SUM(CASE WHEN winner_clean = GREATEST(team1_clean, team2_clean) THEN 1 ELSE 0 END) AS team_b_wins,
    ROUND(SUM(CASE WHEN winner_clean = LEAST(team1_clean, team2_clean) THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1)
	AS team_a_win_pct
	FROM standardised
	GROUP BY LEAST(team1_clean, team2_clean), GREATEST(team1_clean, team2_clean)
	HAVING COUNT(*) >= 20)

SELECT head_to_head.*,
	CASE 
    WHEN team_a_wins > team_b_wins THEN team_a
    ELSE team_b
	END AS dominant_team,
	GREATEST(team_a_win_pct, 100 - team_a_win_pct) AS dominance_pct
	FROM head_to_head
	ORDER BY dominance_pct ASC;

	