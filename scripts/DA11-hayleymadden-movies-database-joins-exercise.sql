-- 1. Give the name, release year, and worldwide gross of the lowest grossing movie.

SELECT t1.film_title, t1.release_year, t2.worldwide_gross
FROM specs as t1
INNER JOIN revenue as t2
	ON t1.movie_id = t2.movie_id
ORDER BY t2.worldwide_gross ASC
LIMIT 1;

--Answer: Semi-Tough, released 1977, grossed $37,187,139

-- 2. What year has the highest average imdb rating?

SELECT t2.release_year, avg(t1.imdb_rating) as avg_rating
FROM rating as t1
INNER JOIN specs as t2
	ON t1.movie_id = t2.movie_id
GROUP BY release_year
ORDER BY avg_rating DESC;

--Answer: 1991 has the highest average IMDB rating.

-- 3. What is the highest grossing G-rated movie? Which company distributed it?

SELECT 
	t1.film_title as title, 
	t1.mpaa_rating as rating, 
	t2.worldwide_gross, 
	t3.company_name as distributor
FROM specs as t1
INNER JOIN revenue as t2
	ON t1.movie_id = t2.movie_id
LEFT JOIN distributors as t3
	ON t1.domestic_distributor_id = t3.distributor_id
WHERE t1.mpaa_rating IN ('G')
ORDER BY t2.worldwide_gross DESC
LIMIT 1;

--Answer: Toy Story 4 is the top grossing G Rated movie.  It was distributed by Walt Disney.

-- 4. Write a query that returns, for each distributor in the distributors table, the distributor name and the number of movies associated with that distributor in the movies table. Your result set should include all of the distributors, whether or not they have any movies in the movies table.

--Answer:

SELECT t1.company_name as distributor, COUNT(t2.*) as movies_released
FROM distributors as t1
LEFT JOIN specs as t2
	ON t1.distributor_id = t2.domestic_distributor_id
GROUP BY distributor
ORDER BY movies_released DESC;

-- 5. Write a query that returns the five distributors with the highest average movie budget.

SELECT 
	t1.company_name as distributor, 
	ROUND(AVG(t3.film_budget),2) as avg_budget
FROM distributors as t1
LEFT JOIN specs as t2
	ON t1.distributor_id = t2.domestic_distributor_id
INNER JOIN revenue as t3
	ON t2.movie_id = t3.movie_id
GROUP BY distributor
ORDER BY avg_budget DESC
LIMIT 5;

--Answer:
-- "Walt Disney "	148735526.32
-- "Sony Pictures"	139129032.26
-- "Lionsgate"	122600000.00
-- "DreamWorks"	121352941.18
-- "Warner Bros."	103430985.92

-- 6. How many movies in the dataset are distributed by a company which is not headquartered in California? Which of these movies has the highest imdb rating?

SELECT t1.headquarters, COUNT(t2.*) as num_movies_distributed, t2.film_title, t3.imdb_rating
FROM distributors as t1
INNER JOIN specs as t2
	ON t1.distributor_id = t2.domestic_distributor_id
INNER JOIN rating as t3
	ON t2.movie_id = t3.movie_id
WHERE t1.headquarters NOT ILIKE '% CA%'
GROUP BY t1.headquarters, t2.film_title, t3.imdb_rating
ORDER BY t3.imdb_rating DESC
LIMIT 1;

--Answer: Dirty Dancing, which was distributed by a company based in Chicago, has a 7.0 IMDB rating
	-- "Chicago, Illinois"	1	"Dirty Dancing"	7.0

-- 7. Which have a higher average rating, movies which are over two hours long or movies which are under two hours?

SELECT 
	CASE WHEN t1.length_in_min < 120 THEN 'run_time_sub_2hrs'
	WHEN t1.length_in_min > 120 THEN 'run_time_over_2hrs'
	ELSE 'run_time_2hrs' END AS run_time,
	AVG(t2.imdb_rating) as avg_rating
FROM specs AS t1
INNER JOIN rating as t2
	ON t1.movie_id = t2.movie_id
GROUP BY run_time
ORDER BY avg_rating DESC;

--Answer: Movies over two hours have the highest average rating.