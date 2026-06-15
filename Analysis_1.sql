--Which franchise has the highest win percentage across all IPL seasons,
--among teams that have played at least 100 matches? Use your team_mapping table to standardise names.

SELECT 
    COALESCE(tm_winner.standard_name, m.winning_team) AS franchise,
    COUNT(*) AS total_wins
FROM matches m
LEFT JOIN team_mapping tm_winner ON m.winning_team = tm_winner.original_name
WHERE winning_team != 'NA'
GROUP BY COALESCE(tm_winner.standard_name, m.winning_team)
ORDER BY total_wins DESC;

SELECT 