
--- Q1 Find the titles of all movies directed by Steven Spielberg.
SELECT title
FROM Movie
WHERE director = 'Steven Spielberg';
 
--- Q2 Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order.
SELECT DISTINCT m.year
FROM Movie m
JOIN Rating r ON r.mID = m.mID
WHERE stars >= 4;
 
--- Q3 Find the titles of all movies that have no rating.
SELECT title
FROM Movie
WHERE mID NOT IN (
                SELECT mID
                FROM Rating);
 
--- Q4 Some reviewers didn’t provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date.
SELECT re.name
FROM Reviewer re
JOIN Rating r ON re.rID = r.rID
WHERE r.ratingDate IS NULL;
 
--- Q5 Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars.
SELECT
                re.name
                , m.title
                , r.stars
                , r.ratingDate
FROM Rating r
JOIN Reviewer re ON re.rID = r.rID
JOIN Movie m ON m.mID = r.mID
ORDER BY
                re.name
                , m.title
                , r.stars;
 
--- Q6 For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer’s name and the title of the movie.
SELECT
                re.name
                , m.title
FROM Rating earlier_rating
JOIN Rating later_rating ON later_rating.rID = earlier_rating.rID AND later_rating.mID = earlier_rating.mID
JOIN Reviewer re ON re.rID = earlier_rating.rID
JOIN Movie m ON m.mID = earlier_rating.mID
WHERE
later_rating.stars > earlier_rating.stars
                AND later_rating.ratingDate > earlier_rating.ratingDate;
 
--- Q7 For each movie that has at least one rating, find the highest number of stars that movie received. Returned the movie title and the number of stars. Sort by movie title.
SELECT
                m.title
                , MAX(r.stars) AS highest_rating
FROM Movie m
JOIN Rating r ON r.mID = m.mID
GROUP BY m.mID
ORDER BY m.title;
 
--- Q8 For each movie, return the title and the ‘rating spread’, that is, the difference between highest and lowest rating given to that movie. Sort by rating spread from highest to lowest, then by movie title.
SELECT
                m.title
                , (MAX(r.stars) - MIN(r.stars)) AS spread
FROM Movie m
JOIN Rating r ON r.mID = m.mID
GROUP BY m.mID
ORDER BY
                spread DESC
                , m.title;
 
--- Q9 Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. (Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. Don’t just calculate the overall average rating before and after 1980.)
SELECT
    (AVG(before.avg) - AVG(after.avg)) AS diff
FROM
    (SELECT AVG(r.stars) AS avg
    FROM Rating r
    JOIN Movie m ON m.mID = r.mID
    WHERE m.year < 1980
    GROUP BY m.mID) AS before
    ,
    (SELECT AVG(r.stars) AS avg
    FROM Rating r
    JOIN Movie m ON m.mID = r.mID
    WHERE m.year > 1980
    GROUP BY m.mID) AS after;
