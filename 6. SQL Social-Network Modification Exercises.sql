--- Q1 It’s time for the seniors to graduate. Remove all 12th graders from Highschooler.
DELETE FROM Highschooler
WHERE grade = 12;
 
--- Q2 If two students A and B are friends, and A likes B but not vice-versa, remove the Likes tuple.
DELETE FROM Likes
WHERE
   ID1 IN (SELECT l1.ID1
           FROM Likes l1
           JOIN Friend f ON f.ID1 = l1.ID1 AND f.ID2 = l1.ID2
           WHERE l1.ID2 NOT IN (SELECT ID1 FROM Likes WHERE ID2 = l1.ID1))
   AND ID2 IN (SELECT l1.ID2
               FROM Likes l1
               JOIN Friend f ON f.ID1 = l1.ID1 AND f.ID2 = l1.ID2
               WHERE l1.ID2 NOT IN (SELECT ID1 FROM Likes WHERE ID2 = l1.ID1));
 
--- Q3 For all cases where A is friends with B, and B is friends with C, add a new friendship for the pair A and C. Do not add duplicate friendships, friendships that already exist, or friendships with oneself. (This one is a bit challenging; congratulations if you get it right.)
INSERT INTO Friend
SELECT DISTINCT
   f1.ID1 AS A
   , f2.ID2 AS C
FROM Friend f1
JOIN Friend f2 ON f2.ID1 = f1.ID2 AND f1.ID1 != f2.ID2
WHERE f2.ID2 NOT IN (SELECT ID2 FROM Friend WHERE ID1 = f1.ID1);
