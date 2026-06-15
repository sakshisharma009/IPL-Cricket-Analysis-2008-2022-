--verifying the venue wins query

SELECT venue, Count(winning_team)
FROM matches
WHERE winning_team ='NA'
GROUP BY venue;


SELECT 
    COALESCE(vm.standard_name, m.venue) AS venue, 
    COUNT(*) AS actual_count
FROM matches m
LEFT JOIN venue_mapping vm ON m.venue = vm.original_name
WHERE winning_team IS NOT NULL
GROUP BY COALESCE(vm.standard_name, m.venue)
ORDER BY actual_count DESC
LIMIT 5;

