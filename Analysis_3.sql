/*Best powerplay bowler and death over bowler in IPL*/
SELECT * FROM deliveries;


WITH bowler_phases AS (
    SELECT
        bowler,
        -- powerplay runs (include all runs)
        SUM(CASE WHEN overs BETWEEN 0 AND 5 THEN total_run ELSE 0 END) AS pp_runs,
        -- powerplay legal deliveries (exclude wides)
        COUNT(CASE WHEN overs BETWEEN 0 AND 5 AND extra_type = 'NA' THEN 1 END) AS pp_balls,
        -- death over runs
        SUM(CASE WHEN overs BETWEEN 16 AND 19 THEN total_run ELSE 0 END) AS death_runs,
        -- death over legal deliveries
        COUNT(CASE WHEN overs BETWEEN 16 AND 19 AND extra_type = 'NA' THEN 1 END) AS death_balls,
        -- wickets (exclude run outs)
        SUM(CASE WHEN overs BETWEEN 0 AND 5 AND is_wicket_delivery = 1 
            AND kind NOT IN ('run out') THEN 1 ELSE 0 END) AS pp_wickets,
        SUM(CASE WHEN overs BETWEEN 16 AND 19 AND is_wicket_delivery = 1 
            AND kind NOT IN ('run out') THEN 1 ELSE 0 END) AS death_wickets
    FROM deliveries
    GROUP BY bowler
),
	bowler_stats AS (
         SELECT
             bowler,
             ROUND(pp_runs * 6.0 / NULLIF(pp_balls, 0), 2) AS pp_economy,
             pp_wickets,
             ROUND(death_runs * 6.0 / NULLIF(death_balls, 0), 2) AS death_economy,
             death_wickets
         FROM bowler_phases
         WHERE pp_balls / 6.0 >= 70 )

SELECT
    bowler,
    pp_economy,
    pp_wickets,
    death_economy,
    death_wickets,
    ROUND((pp_economy + death_economy) / 2.0, 2) AS overall_economy,
    pp_wickets + death_wickets AS total_wickets,
    ROUND(ABS(pp_economy - death_economy), 2) AS phase_gap
FROM bowler_stats
ORDER BY overall_economy ASC;



	





	