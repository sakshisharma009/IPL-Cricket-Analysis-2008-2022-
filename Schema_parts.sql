CREATE TABLE deliveries (
    id                  INTEGER,
    innings             SMALLINT,
    overs               SMALLINT,
    ball_number         SMALLINT,
    batter              VARCHAR(100),
    bowler              VARCHAR(100),
    non_striker         VARCHAR(100),
    extra_type          VARCHAR(50),
    batsman_run         SMALLINT,
    extras_run          SMALLINT,
    total_run           SMALLINT,
    non_boundary        SMALLINT,
    is_wicket_delivery  SMALLINT,
    player_out          VARCHAR(100),
    kind                VARCHAR(50),
    fielders_involved   VARCHAR(200),
    batting_team        VARCHAR(100),
    FOREIGN KEY (id) REFERENCES matches(id)
);


SELECT COUNT(*) FROM deliveries;

-- Check one full match ball by ball
SELECT * FROM deliveries 
WHERE id = 1
ORDER BY innings, overs, ball_number;

-- Make sure the foreign key is working
SELECT COUNT(*) FROM deliveries d
LEFT JOIN matches m ON d.id = m.id
WHERE m.id IS NULL;  -- should return 0



















