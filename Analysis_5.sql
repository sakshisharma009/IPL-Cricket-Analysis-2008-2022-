--finding all rounders of IPL

WITH batting_stats AS(
	SELECT  batter, SUM(batsman_run) AS total_runs,
	COUNT(CASE WHEN extra_type ='NA' THEN 1 END) AS balls_faced,
	ROUND(SUM(batsman_run) * 100.0 / COUNT(CASE WHEN extra_type ='NA' THEN 1 END), 2) AS strike_rate
	FROM deliveries
	GROUP BY batter
	HAVING SUM(batsman_run) >=1500 AND COUNT(CASE WHEN extra_type ='NA' THEN 1 END) >= 1000
),
	bowling_stats AS(
	SELECT bowler, SUM(CASE WHEN is_wicket_delivery = 1 
    
	AND kind NOT IN ('run out', 'retired hurt', 'obstructing the field') 
    
	THEN 1 ELSE 0 END) AS total_wickets,
	
	COUNT(CASE WHEN extra_type ='NA' THEN 1 END) AS balls_bowled,
	
	ROUND(SUM(total_run)  * 6.0/ NULLIF(COUNT(CASE WHEN extra_type ='NA' THEN 1 END),0), 2) AS economy_rate
	
	FROM deliveries
	GROUP BY bowler
	HAVING COUNT(CASE WHEN extra_type ='NA' THEN 1 END) >= 600 AND SUM(CASE WHEN is_wicket_delivery = 1 
    
	AND kind NOT IN ('run out', 'retired hurt', 'obstructing the field') 
    
	THEN 1 ELSE 0 END) >= 50
	),

	allrounder_combined AS(
	SELECT bt.batter AS player,
	bt.total_runs,
    bt.strike_rate,
    bt.balls_faced,
    bs.total_wickets,
    bs.economy_rate,
    bs.balls_bowled
	FROM batting_stats bt
	INNER JOIN bowling_stats bs ON bt.batter=bs.bowler
),
	ranked AS(
	SELECT
        player,
        total_runs,
        strike_rate,
        total_wickets,
        economy_rate,
        -- three rankings here
        DENSE_RANK() OVER(ORDER BY strike_rate DESC  ) AS batting_rank,
        DENSE_RANK() OVER(ORDER BY economy_rate ASC ) AS bowling_rank,
        DENSE_RANK() OVER(ORDER BY total_runs + total_wickets * 20 DESC ) AS impact_rank
    FROM allrounder_combined  
)

SELECT
    player,
    total_runs,
    strike_rate,
    total_wickets,
    economy_rate,
    batting_rank,
    bowling_rank,
    impact_rank,
    batting_rank + bowling_rank + impact_rank AS allrounder_score
FROM ranked
ORDER BY allrounder_score ASC
LIMIT 10;
	





	
	 