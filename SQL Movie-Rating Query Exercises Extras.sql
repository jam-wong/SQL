
--- Q1 Find the names of all reviewers who rated Gone with the Wind.
SELECT DISTINCT re.name
FROM Rating r
JOIN Reviewer re ON re.rID = r.rID
JOIN Movie m ON m.mID = r.mID
WHERE m.title = 'Gone with the Wind';
 
--- Q2 For any rating where the reviewer is the same as the director of the movie, return the reviewer name, movie title, and number of stars.
SELECT
   re.name
   , m.title
   , r.stars
FROM Rating r
JOIN Reviewer re ON re.rID = r.rID
JOIN Movie m ON m.mID = r.mID
WHERE re.name = m.director;
 
--- Q3 Return all reviewer names and movie names together in a single list, alphabetized. (Sorting by the first name of the reviewer and first word in the title is fine; no need for special processing on last names or removing “The”.)
SELECT name
FROM Reviewer
UNION
SELECT title AS name
FROM Movie
ORDER BY name ASC;
 
--- Q4 Find the titles of all movies not reviewed by Chris Jackson.
SELECT title
FROM Movie
WHERE mID NOT IN (SELECT r.mID
                  FROM Rating r
                  JOIN Reviewer re ON re.rID = r.rID
                  WHERE re.name = 'Chris Jackson');
 
--- Q5 For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers. Eliminate duplicates, don’t pair reviewers with themselves, and include each pair only once. For each pair, return the names in the pair in alphabetical order.
SELECT DISTINCT
   re1.name
   , re2.name
FROM Rating r1
JOIN Rating r2 ON r1.mID = r2.mID AND r1.rID != r2.rID
JOIN Reviewer re1 ON re1.rID = r1.rID
JOIN Reviewer re2 ON re2.rID = r2.rID
WHERE re1.name < re2.name;
 
--- Q6 For each rating that is the lowest (fewest stars) currently in the database, return the reviewer name, movie title, and number of stars.
SELECT
   re.name
   , m.title
   , r.stars
FROM Rating r
JOIN Reviewer re ON re.rID = r.rID
JOIN Movie m ON m.mID = r.mID
WHERE r.stars = (SELECT MIN(stars)
                 FROM Rating);
 
--- Q7 List movie titles and average ratings, from highest-rated to lowest-rated. If two or more movies have the same average rating, list them in alphabetical order.
SELECT
   m.title
   , AVG(r.stars) AS avg_rating
FROM Rating r
JOIN Movie m ON m.mID = r.mID
GROUP BY m.mID
ORDER BY
   avg_rating DESC
   , m.title;
 
--- Q8 Find the names of all reviewers who have contributed three or more ratings. (As an extra challenge, try writing the query without HAVING or without COUNT.)
SELECT DISTINCT name
FROM Reviewer
WHERE rID IN (SELECT rID
              FROM Rating
              GROUP BY rID
              HAVING COUNT(*) >= 3);
 
--- Q9 Some directors directed more than one movie. For all such directors, return the titles of all movies directed by them, along with the director name. Sort by director name, then movie title. (As an extra challenge, try writing the query both with and without COUNT.)
SELECT
   title
   , director
FROM Movie
WHERE director IN(SELECT director
                  FROM Movie
                  GROUP BY director
                  HAVING COUNT(*) > 1)
ORDER BY
   director
   , title;
 
--- Q10 Find the movie(s) with the highest average rating. Return the movie title(s) and average rating. (Hint: This query is more difficult to write in SQLite than other systems; you might think of it as finding the highest average rating and then choosing the movie(s) with that average rating.)
SELECT
   m.title
   , AVG(r.stars) AS avg_rating
FROM Rating r
JOIN Movie m ON m.mID = r.mID
GROUP BY m.mID
HAVING avg_rating = (SELECT AVG(stars) AS avg
                     FROM Rating
                     GROUP BY mID
                     ORDER BY avg DESC
                     LIMIT 1);
 
--- Q11 Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating. (Hint: This query may be more difficult to write in SQLite than other systems; you might think of it as finding the lowest average rating and then choosing the movie(s) with that average rating.)
SELECT
   m.title
   , AVG(r.stars) AS avg_rating
FROM Rating r
JOIN Movie m ON m.mID = r.mID
GROUP BY m.mID
HAVING avg_rating = (SELECT AVG(stars) AS avg
                     FROM Rating
                     GROUP BY mID
                     ORDER BY avg ASC
                     LIMIT 1);
 
--- Q12 For each director, return the director’s name together with the title(s) of the movie(s) they directed and received the highest rating among all of their movies, and the value of that rating. Ignore movies whose director is NULL.
SELECT
   m.director
   , m.title
   , MAX(r.stars) AS highest_rating
FROM Rating r
JOIN Movie m ON m.mID = r.mID
WHERE m.director IS NOT NULL
GROUP BY m.director
HAVING MAX(r.stars);
