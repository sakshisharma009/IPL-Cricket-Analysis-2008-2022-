--Which venue has the highest win percentage for the team batting first 
--and which venue favours chasing the most

WITH match_batting AS( 
	SELECT 
	COALESCE(vm.standard_name, m.venue) AS venue, winning_team,
	CASE
		WHEN toss_decision='bat' THEN toss_winner
		WHEN toss_decision='field' AND toss_winner= team1 THEN team2
		WHEN toss_decision='field' AND toss_winner= team2 THEN team1
		ELSE NULL
		END AS team_batted_first 
FROM matches m
LEFT JOIN venue_mapping vm ON m.venue=vm.original_name
WHERE winning_team IS NOT NULL )


SELECT venue, COUNT(*) AS total_matches,
	ROUND(SUM(CASE WHEN team_batted_first = winning_team THEN 1 ELSE 0 END)*100.0/COUNT(*),1) AS bat_first_win
FROM match_batting
GROUP BY venue
HAVING COUNT(*)>=5
ORDER BY bat_first_win DESC;

-- See which venues still have no mapping (will show raw inconsistent names)
SELECT DISTINCT m.venue
FROM matches m
LEFT JOIN venue_mapping vm ON m.venue = vm.original_name
WHERE vm.original_name IS NULL;



-- Should return no rows
SELECT original_name, COUNT(*)
FROM venue_mapping
GROUP BY original_name
HAVING COUNT(*) > 1;









