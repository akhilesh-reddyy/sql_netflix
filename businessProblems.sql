-- ===========================================
-- Netflix Data Analysis using SQL
-- 15 Business Problems & Solutions
-- ===========================================

-- 1. Count the number of Movies vs TV Shows
-- Objective: Understand the distribution of content types
SELECT 
    type,
    COUNT(*) AS total_content,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM netflix), 2) AS percentage
FROM netflix
GROUP BY type
ORDER BY total_content DESC;


-- 2. Most common rating for Movies and TV Shows
-- Objective: Identify popular ratings for content type
WITH rating_counts AS (
    SELECT type, rating, COUNT(*) AS count
    FROM netflix
    GROUP BY type, rating
),
ranked_ratings AS (
    SELECT *, RANK() OVER (PARTITION BY type ORDER BY count DESC) AS rank
    FROM rating_counts
)
SELECT type, rating AS most_common_rating, count
FROM ranked_ratings
WHERE rank = 1;


-- 3. List all movies released in a specific year (e.g., 2020)
SELECT *
FROM netflix
WHERE release_year = 2020
ORDER BY title;


-- 4. Top 5 countries with the most content
WITH country_expanded AS (
    SELECT UNNEST(STRING_TO_ARRAY(country, ',')) AS country
    FROM netflix
)
SELECT country, COUNT(*) AS total_content
FROM country_expanded
WHERE country IS NOT NULL
GROUP BY country
ORDER BY total_content DESC
LIMIT 5;


-- 5. Longest movie by duration
SELECT *
FROM netflix
WHERE type = 'Movie'
ORDER BY CAST(SPLIT_PART(duration, ' ', 1) AS INT) DESC
LIMIT 1;


-- 6. Content added in the last 5 years
SELECT *
FROM netflix
WHERE date_added >= CURRENT_DATE - INTERVAL '5 years'
ORDER BY date_added DESC;


-- 7. All movies/TV shows by director 'Rajiv Chilaka'
WITH director_expanded AS (
    SELECT *, UNNEST(STRING_TO_ARRAY(director, ',')) AS director_name
    FROM netflix
)
SELECT *
FROM director_expanded
WHERE director_name = 'Rajiv Chilaka';


-- 8. TV Shows with more than 5 seasons
SELECT *
FROM netflix
WHERE type = 'TV Show'
  AND CAST(SPLIT_PART(duration, ' ', 1) AS INT) > 5
ORDER BY duration DESC;


-- 9. Number of content items per genre
WITH genre_expanded AS (
    SELECT UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre
    FROM netflix
)
SELECT genre, COUNT(*) AS total_content
FROM genre_expanded
GROUP BY genre
ORDER BY total_content DESC;


-- 10. Top 5 years with highest average content release in India
WITH india_content AS (
    SELECT *
    FROM netflix
    WHERE country LIKE '%India%'
)
SELECT release_year,
       COUNT(show_id) AS total_release,
       ROUND(COUNT(show_id)::NUMERIC / 
             (SELECT COUNT(*) FROM india_content) * 100, 2) AS avg_release_percentage
FROM india_content
GROUP BY release_year
ORDER BY avg_release_percentage DESC
LIMIT 5;


-- 11. List all movies that are Documentaries
SELECT *
FROM netflix
WHERE listed_in ILIKE '%Documentaries%';


-- 12. Find all content without a director
SELECT *
FROM netflix
WHERE director IS NULL;


-- 13. Movies featuring 'Salman Khan' in last 10 years
SELECT *
FROM netflix
WHERE casts ILIKE '%Salman Khan%'
  AND release_year >= EXTRACT(YEAR FROM CURRENT_DATE) - 10;


-- 14. Top 10 actors with most appearances in Indian movies
WITH actors_expanded AS (
    SELECT UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor, country
    FROM netflix
)
SELECT actor, COUNT(*) AS appearances
FROM actors_expanded
WHERE country LIKE '%India%'
GROUP BY actor
ORDER BY appearances DESC
LIMIT 10;


-- 15. Categorize content as 'Bad' or 'Good' based on keywords
WITH categorized_content AS (
    SELECT type,
           CASE 
               WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
               ELSE 'Good'
           END AS category
    FROM netflix
)
SELECT type, category, COUNT(*) AS total_content
FROM categorized_content
GROUP BY type, category
ORDER BY type, category;
