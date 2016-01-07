-- Q1 Find the titles of all movies directed by Steven Spielberg.
SELECT
  title
FROM
  Movie
WHERE
  director = 'Steven Spielberg';

-- Q2 Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order.
SELECT DISTINCT
  year
FROM
  Movie
JOIN
  Rating ON Rating.mID = Movie.mID
WHERE
  stars >= 4
ORDER BY
  year;
  
-- Q3 Find the titles of all movies that have no ratings.
SELECT
  title
FROM
  Movie
WHERE 
  mID IN (SELECT mID WHERE mID NOT IN
    (SELECT mID FROM Rating));
  
-- Q4 Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date.
SELECT
  name
FROM
  Reviewer
JOIN
  Rating ON Rating.rID = Reviewer.rID
WHERE
  ratingDate IS NULL;
  
-- Q5 Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars. 
SELECT
  name
  , title
  , stars
  , ratingDate
FROM
  Rating
JOIN
  Movie ON Movie.mID = Rating.mID
  , Reviewer ON Reviewer.rID = Rating.rID
ORDER BY
  name ASC
  , title ASC
  , stars ASC;
  
-- Q6 For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie.
SELECT 
  name
  , title
FROM
  Reviewer
JOIN
  Rating r1 ON r1.rID = Reviewer.rID
  , Rating r2 ON r2.rID = Reviewer.rID
  , Movie ON Movie.mID = r1.mID
WHERE
  r1.ratingDate < r2.ratingDate
  AND r1.stars < r2.stars
  AND r1.mID = r2.mID;
  
-- Q7 For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. Sort by movie title.
SELECT
  title
  , MAX(stars)
FROM
  Movie
JOIN
  Rating ON Rating.mID = Movie.mID
GROUP BY
  Movie.mID
ORDER BY
  title ASC;
  
-- Q8 For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. Sort by rating spread from highest to lowest, then by movie title.
SELECT
  title
  , MAX(stars) - MIN(stars) AS spread
FROM
  Movie
JOIN
  Rating ON Rating.mID = Movie.mID
GROUP BY
  Movie.mID
ORDER BY
  spread DESC
  , title ASC;
  
-- Q9 Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. (Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. Don't just calculate the overall average rating before and after 1980.)
SELECT
  AVG(before.avg) - AVG(after.avg)
FROM
  (SELECT
    AVG(stars) AS avg
  FROM
    Movie
  JOIN
    Rating ON Rating.mID = Movie.mID
  GROUP BY 
    Movie.mID
  HAVING
    year < 1980) AS before
  , (SELECT
    AVG(stars) AS avg
  FROM
    Movie
  JOIN
    Rating ON Rating.mID = Movie.mID
  GROUP BY 
    Movie.mID
  HAVING
    year > 1980) AS after;
