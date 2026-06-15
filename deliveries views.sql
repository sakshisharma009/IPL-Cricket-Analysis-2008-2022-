CREATE VIEW deliveries_clean AS
SELECT
    d.id,
    d.innings,
    d.overs,
    d.ball_number,
    d.batter,
    d.bowler,
    d.non_striker,
    d.extra_type,
    d.batsman_run,
    d.total_run,
    d.is_wicket_delivery,
    d.player_out,
    d.kind,
    d.fielders_involved,
    d.batting_team,
    mc.season_year,
    mc.venue,
    mc.winning_team,
    mc.team_batted_first,
    CASE 
        WHEN d.batting_team = mc.team1 THEN mc.team2
        ELSE mc.team1
    END AS bowling_team
FROM deliveries d
JOIN matches_clean mc ON d.id = mc.id;