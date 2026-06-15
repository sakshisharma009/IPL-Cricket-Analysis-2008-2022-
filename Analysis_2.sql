--Question — Top 3 batsmen by total runs for each season

WITH season_runs AS(
	SELECT m.season_year, d.batter, SUM(d.batsman_run) AS total_runs
	FROM deliveries d
	INNER JOIN matches m ON d.id=m.id
	GROUP BY m.season_year, d.batter
	
),
	ranked AS(
	SELECT  season_year, batter, total_runs, 
	DENSE_RANK() OVER(PARTITION BY season_year ORDER BY total_runs DESC) AS rank 
	FROM season_runs )

	SELECT  season_year, batter, total_runs, rank 
	FROM ranked
	WHERE rank <=3;


--verifying
	SELECT season_year, COUNT(*) AS players_in_top3
	FROM ranked
	WHERE rank <= 3
	GROUP BY season_year
	ORDER BY season_year;