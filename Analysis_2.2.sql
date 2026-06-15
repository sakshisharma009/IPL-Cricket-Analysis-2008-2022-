/*Using LAG(), find which batsmen improved their total runs the most from one season to the
next — showing their runs in the previous season, runs in the current season, and the difference between them.*/


WITH season_runs AS(
	SELECT m.season_year, d.batter, SUM(d.batsman_run) AS total_runs
	FROM deliveries d
	INNER JOIN matches m ON d.id=m.id
	GROUP BY m.season_year, d.batter
	HAVING SUM(d.batsman_run) >=200
	
),
	previous_runs AS(
	SELECT  season_year, batter, total_runs, 
	LAG(total_runs) OVER(PARTITION BY batter ORDER BY season_year ASC) AS prev_season_run 
	FROM season_runs )

	SELECT  season_year, batter, total_runs, prev_season_run,
	         total_runs - prev_season_run  AS Improvement
	FROM previous_runs
	WHERE 
	 total_runs - prev_season_run   IS NOT NULL 
	 ORDER BY total_runs - prev_season_run ASC LIMIT 10;



--verification
	 SELECT season_year, batter, total_runs, prev_season_run,
       total_runs - prev_season_run AS improvement
FROM previous_runs
WHERE batter = 'V Kohli'
AND prev_season_run IS NOT NULL
ORDER BY improvement ASC;
	 