--- Q1 For every situation where student A likes student B, but student B likes a different student C, return the names and grades of A, B, and C.
SELECT
   admirer.name, admirer.grade
   , a_and_c.name, a_and_c.grade
   , crush.name, crush.grade
FROM Likes l1
JOIN Likes l2 ON l2.ID1 = l1.ID2
JOIN Highschooler admirer ON admirer.ID = l1.ID1
JOIN Highschooler a_and_c ON a_and_c.ID = l1.ID2
JOIN Highschooler crush ON crush.ID = l2.ID2
WHERE admirer.ID != crush.ID;
 
--- Q2 Find those students for whom all of their friends are in different grades from themselves. Return the students’ names and grades.
SELECT
   name
   , grade
FROM Highschooler
WHERE ID NOT IN (SELECT f.ID1
                 FROM Friend f
                 JOIN Highschooler h1 ON h1.ID = f.ID1
                 JOIN Highschooler h2 ON H2.ID = f.ID2
                 WHERE h1.grade = h2.grade);
 
--- Q3 What is the average number of friends per student? (Your result should be just one number.)
SELECT AVG(num_friends)
FROM (SELECT COUNT(ID2) AS num_friends
      FROM Highschooler h
      LEFT JOIN Friend f ON h.ID = f.ID1         --Accounts for students with no friends (doesn’t matter in this case)
      GROUP BY ID1);
 
--- Q4 Find the number of students who are either friends with Cassandra or are friends of friends of Cassandra. Do not count Cassandra, even though technically she is a friend of a friend.
SELECT COUNT(ID2)        --Technically counts Cassandra, but she replaces the her immediate friends who are not counted, so the number is the same.
FROM Friend
WHERE ID1 IN (SELECT ID2
              FROM Friend
              WHERE ID1 IN (SELECT ID
                            FROM Highschooler
                            WHERE name = 'Cassandra'));
 
--- Q5 Find the name and grade of the student(s) with the greatest number of friends.
SELECT
   h.name
   , h.grade
FROM Highschooler h
JOIN Friend f ON f.ID1 = h.ID
GROUP BY h.ID
HAVING COUNT(f.ID2) = (SELECT COUNT(ID2) AS num_friends
                       FROM Friend
                       GROUP BY ID1
                       ORDER BY num_friends DESC
                       LIMIT 1);
