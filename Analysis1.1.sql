--venue where batting first and chase first wins happened as a single query

 
WITH match_result AS (
    SELECT
        COALESCE(vm.standard_name, m.venue) AS venue,
        winning_team,
        CASE
            WHEN toss_decision = 'bat' THEN toss_winner
            WHEN toss_decision = 'field' AND toss_winner = team1 THEN team2
            WHEN toss_decision = 'field' AND toss_winner = team2 THEN team1
        END AS team_batted_first,
        CASE
            WHEN toss_decision = 'field' THEN toss_winner
            WHEN toss_decision = 'bat' AND toss_winner = team1 THEN team2
            WHEN toss_decision = 'bat' AND toss_winner = team2 THEN team1
        END AS team_batted_second
    FROM matches m
    LEFT JOIN venue_mapping vm ON m.venue = vm.original_name
    WHERE winning_team IS NOT NULL
)
	
	SELECT 
	    venue,
	    COUNT(*) AS total_matches,
	    ROUND(SUM(CASE WHEN team_batted_first = winning_team THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS bat_first_win,
	    ROUND(SUM(CASE WHEN team_batted_second = winning_team THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS bat_second_win
	    
	FROM match_result
	GROUP BY venue
	HAVING COUNT(*) >=20
	ORDER BY total_matches DESC;









