ALTER TABLE matches
ADD COLUMN season_year smallint;


UPDATE matches SET season_year= CASE season
WHEN '2007/08' THEN 2008
WHEN '2009/10' THEN 2010
WHEN '2020/21' THEN 2020
ELSE CAST( season as smallint)
END;

SELECT season_year, COUNT(*) 
FROM matches 
GROUP BY season, season_year 
ORDER BY season_year;







