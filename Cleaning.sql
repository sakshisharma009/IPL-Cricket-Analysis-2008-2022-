CREATE TABLE venue_mapping(
	original_name varchar(150),
	standard_name varchar(150)
);
SELECT  venue, count(venue) FROM matches
group by venue
order by venue;


INSERT INTO venue_mapping(original_name, standard_name)
VALUES 
	('M Chinnaswamy Stadium',               'M.Chinnaswamy Stadium'),
('Arun Jaitley Stadium, Delhi',         'Feroz Shah Kotla'),
('Arun Jaitley Stadium',               'Feroz Shah Kotla'),
('Brabourne Stadium, Mumbai', 'Brabourne Stadium'),
('Dr DY Patil Sports Academy, Mumbai', 'Dr DY Patil Sports Academy'),
('Eden Gardens, Kolkata',  'Eden Gardens'),
('MA Chidambaram Stadium, Chepauk',  'MA Chidambaram Stadium'),
('MA Chidambaram Stadium, Chepauk, Chennai', 'MA Chidambaram Stadium'),
('Maharashtra Cricket Association Stadium, Pune', 'Maharashtra Cricket Association Stadium' ),
('Punjab Cricket Association IS Bindra Stadium, Mohali', 'Punjab Cricket Association IS Bindra Stadium'),
('Punjab Cricket Association Stadium, Mohali', 'Punjab Cricket Association IS Bindra Stadium'),
('Rajiv Gandhi International Stadium, Uppal',  'Rajiv Gandhi International Stadium');

SELECT * FROM venue_mapping;	

SELECT 
    COALESCE(vm.standard_name, m.venue) AS venue,
    COUNT(*) AS matches_played
FROM matches m
LEFT JOIN venue_mapping vm ON m.venue = vm.original_name
GROUP BY COALESCE(vm.standard_name, m.venue)
ORDER BY matches_played DESC;


-- Are team names consistent?
SELECT DISTINCT team1 FROM matches ORDER BY team1;

-- Are player names consistent?
SELECT DISTINCT batter FROM deliveries ORDER BY batter;

-- What values exist in extra_type?
SELECT DISTINCT extra_type FROM deliveries;

-- What values exist in kind (dismissal types)?
SELECT DISTINCT kind FROM deliveries;

-- Any nulls in critical columns?
SELECT 
    COUNT(*) AS total,
    COUNT(winning_team) AS has_winner,
    COUNT(player_of_match) AS has_potm,
    COUNT(city) AS has_city
FROM matches;

--for analysis

CREATE TABLE team_mapping (
    original_name    VARCHAR(100),
    standard_name    VARCHAR(100),
    change_type      VARCHAR(20),
    from_season      SMALLINT
);

INSERT INTO team_mapping VALUES
	('Delhi Daredevils',         'Delhi Capitals',          'rebrand',      2019 ),
	('Kings XI Punjab',          'Punjab Kings',            'rebrand',      2021),
	('Deccan Chargers',          'Sunrisers Hyderabad',     'replacement',  2013),
	('Rising Pune Supergiant',   'Rising Pune Supergiants', 'spelling_fix', NULL);


SELECT * FROM team_mapping;
