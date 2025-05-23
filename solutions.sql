create database netflixproject;
use netflixproject;
select * from netflix;
select count(*) as total_content from netflix;

--1. Count the Number of Movies vs TV Shows
SELECT 
    type,
    COUNT(*) as total_content
FROM netflix
GROUP BY type;

--2. Find the Most Common Rating for Movies and TV Shows
WITH RatingCounts AS (
    SELECT 
        type,
        rating,
        COUNT(*) AS rating_count
    FROM netflix
    GROUP BY type, rating
),
RankedRatings AS (
    SELECT 
        type,
        rating,
        rating_count,
        RANK() OVER (PARTITION BY type ORDER BY rating_count DESC) AS rank
    FROM RatingCounts
)
SELECT 
    type,
    rating AS most_frequent_rating
FROM RankedRatings
WHERE rank = 1;

--3. List All Movies Released in a Specific Year (e.g., 2020)
SELECT * 
FROM netflix
WHERE type ='movie'
and
release_year = 2020;

--4. Find the Top 5 Countries with the Most Content on Netflix
SELECT TOP 5 
    value AS new_country,
    COUNT(show_id) AS total_content
FROM netflix
CROSS APPLY STRING_SPLIT(country, ',')
GROUP BY value
ORDER BY total_content DESC;

--5. Identify the Longest Movie
select * from netflix where type='movie'
and duration=(select max(duration) from netflix);

--6 Find Content Added in the Last 5 Years
SELECT *
FROM netflix
WHERE CAST(date_added AS DATE) >= DATEADD(YEAR, -5, GETDATE());

--7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'
SELECT *
FROM netflix where director like'%rajiv chilaka%';

--8. List All TV Shows with More Than 5 Seasons
SELECT *
FROM netflix
WHERE type = 'TV Show'
  AND CAST(LEFT(duration, CHARINDEX(' ', duration) - 1) AS INT) > 5;

--9. Count the Number of Content Items in Each Genre
SELECT 
    value AS genre,
    COUNT(show_id) AS total_content
FROM netflix
CROSS APPLY STRING_SPLIT(listed_in, ',')
GROUP BY value;

--10.Find each year and the average numbers of content release in India on netflix.
select extract(year from to_date(date_added,'month dd,yyyy')) as year,
count(*) as yearly_content,
round(
count(*)::numeric/select count(*) from netflix where country = 'india')::numeric *
100,2)as avg_content_per_year
from netflix
where country = 'india'
group by 1;
SELECT 
    YEAR(CONVERT(DATE, date_added, 103)) AS year,
    COUNT(*) AS yearly_content,
    ROUND(
        (COUNT(*) * 1.0 / (SELECT COUNT(*) FROM netflix WHERE country = 'india')) * 100, 2
    ) AS avg_content_per_year
FROM netflix
WHERE country = 'india'
GROUP BY YEAR(CONVERT(DATE, date_added, 103));
SELECT 
    YEAR(PARSE(date_added AS DATETIME USING 'en-US')) AS year,
    COUNT(*) AS yearly_content,
    ROUND(
        (COUNT(*) * 1.0 / (SELECT COUNT(*) FROM netflix WHERE country = 'india')) * 100, 2
    ) AS avg_content_per_year
FROM netflix
WHERE country = 'india'
GROUP BY YEAR(PARSE(date_added AS DATETIME USING 'en-US'));

--11. List All Movies that are Documentaries
SELECT * 
FROM netflix
WHERE listed_in LIKE '%Documentaries';

--12. Find All Content Without a Director
SELECT * 
FROM netflix
WHERE director IS NULL;

--13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
SELECT * 
FROM netflix
WHERE cast LIKE '%Salman Khan%'
  AND release_year >= YEAR(GETDATE()) - 10;

--14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
SELECT TOP 10
    value AS actor,
    COUNT(*) AS total_content
FROM netflix
CROSS APPLY STRING_SPLIT(cast, ',')
WHERE country LIKE '%India%'
GROUP BY value
ORDER BY total_content DESC;

--15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
SELECT 
    category,
    COUNT(*) AS content_count
FROM (
    SELECT 
        CASE 
            WHEN description LIKE '%kill%' OR description LIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY category;



