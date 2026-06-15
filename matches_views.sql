CREATE VIEW matches_clean AS
SELECT 
    m.id,
    m.season_year,
    COALESCE(vm.standard_name, m.venue) AS venue,
    COALESCE(tm1.standard_name, m.team1) AS team1,
    COALESCE(tm2.standard_name, m.team2) AS team2,
    COALESCE(tm_w.standard_name, m.winning_team) AS winning_team,
    m.toss_winner,
    m.toss_decision,
    m.player_of_match,
    m.won_by,
    m.margin,
    m.match_date,
    m.city,
    CASE
        WHEN m.toss_decision = 'bat' THEN m.toss_winner
        WHEN m.toss_decision = 'field' AND m.toss_winner = m.team1 THEN m.team2
        WHEN m.toss_decision = 'field' AND m.toss_winner = m.team2 THEN m.team1
    END AS team_batted_first
FROM matches m
LEFT JOIN venue_mapping vm ON m.venue = vm.original_name
LEFT JOIN team_mapping tm1 ON m.team1 = tm1.original_name
LEFT JOIN team_mapping tm2 ON m.team2 = tm2.original_name
LEFT JOIN team_mapping tm_w ON m.winning_team = tm_w.original_name;