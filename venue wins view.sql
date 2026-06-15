
CREATE VIEW venue_batting_stats AS
WITH match_result AS (
    SELECT
        COALESCE(vm.standard_name, m.venue) AS venue,
        m.winning_team,
        CASE
            WHEN m.toss_decision = 'bat' THEN m.toss_winner
            WHEN m.toss_decision = 'field' AND m.toss_winner = m.team1 THEN m.team2
            WHEN m.toss_decision = 'field' AND m.toss_winner = m.team2 THEN m.team1
        END AS team_batted_first,
        CASE
            WHEN m.toss_decision = 'field' THEN m.toss_winner
            WHEN m.toss_decision = 'bat' AND m.toss_winner = m.team1 THEN m.team2
            WHEN m.toss_decision = 'bat' AND m.toss_winner = m.team2 THEN m.team1
        END AS team_batted_second
    FROM matches m
    LEFT JOIN venue_mapping vm ON m.venue = vm.original_name
    WHERE m.winning_team IS NOT NULL
)
SELECT
    venue,
    COUNT(*) AS total_matches,
    ROUND(SUM(CASE WHEN team_batted_first = winning_team THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS bat_first_win_pct,
    ROUND(SUM(CASE WHEN team_batted_second = winning_team THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS chase_win_pct
FROM match_result
GROUP BY venue
HAVING COUNT(*) >= 20
ORDER BY total_matches DESC;



SELECT * FROM venue_batting_stats ORDER BY total_matches DESC;
