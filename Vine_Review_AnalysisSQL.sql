SELECT * FROM vine_table;

SELECT * FROM vine_table
WHERE total_votes >= 20;
-- --------------2-------------------
SELECT * FROM
(SELECT * FROM vine_table
WHERE total_votes >= 20) as V
WHERE CAST(V.helpful_votes AS FLOAT)/CAST(V.total_votes AS FLOAT) >= 0.5;

-- --------------3-------------------
SELECT *
INTO vine_table_Y
FROM vine_table
WHERE vine = 'Y'
AND total_votes >= 20
AND CAST(helpful_votes AS FLOAT)/CAST(total_votes AS FLOAT) >= 0.5;

DROP TABLE vine_table_Y;

SELECT *
INTO vine_table_N
FROM vine_table
WHERE vine = 'N'
AND total_votes >= 20
AND CAST(helpful_votes AS FLOAT)/CAST(total_votes AS FLOAT) >= 0.5;

DROP TABLE vine_table_N;
-- ---------------------------------
SELECT * FROM vine_table_Y;

SELECT * FROM vine_table_N;
-- --------------4-------------------

SELECT COUNT(review_id) FROM vine_table_Y;

SELECT COUNT(review_id)
FROM vine_table_Y
WHERE star_rating = 5;

SELECT COUNT(review_id) All_Reviews, COUNT(case when star_rating = 5 then 1 end) as Five_Star,
CAST(COUNT(case when star_rating = 5 then 0 end) AS FLOAT)/CAST(COUNT(review_id) AS FLOAT) as Perc
	FROM vine_table_Y;


SELECT COUNT(review_id) as All_Reviews, COUNT(case when star_rating = 5 then 1 end) as Five_Star,
CAST(COUNT(case when star_rating = 5 then 1 end) AS FLOAT)/CAST(COUNT(review_id) AS FLOAT) AS Perc
	 FROM vine_table_N;