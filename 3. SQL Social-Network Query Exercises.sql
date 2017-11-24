
--- Q1 Find the names of all students who are friends with someone named Gabriel.
SELECT name
FROM Highschooler
WHERE ID IN (SELECT ID2
             FROM Friend f
             JOIN Highschooler h ON h.ID = f.ID1
             WHERE h.name = 'Gabriel');
 
--- Q2 For every student who likes someone 2 or more grades younger than themselves, return that student’s name and grade and the name and grade of the student they like.
SELECT
   admirer.name, admirer.grade
   , crush.name, crush.grade
FROM Likes l
JOIN Highschooler admirer ON admirer.ID = l.ID1
JOIN Highschooler crush ON crush.ID = l.ID2
WHERE admirer.grade >= crush.grade + 2;
 
--- Q3 For every pair of students who both like each other, return the name and grade of both students. Include each pair only once, with the two names in alphabetical order.
SELECT DISTINCT
   h1.name, h1.grade
   , h2.name, h2.grade
FROM Likes l1
JOIN Likes l2 ON l1.ID2 = l2.ID1 AND l1.ID1 = l2.ID2
JOIN Highschooler h1 ON h1.ID = l1.ID1
JOIN Highschooler h2 ON h2.ID = l2.ID1
WHERE h1.name < h2.name;
 
--- Q4 Find all students who do not appear in the Likes table (as a student who likes or is liked) and return their names and grades. Sort by grade, then by name within each grade.
SELECT
   name
   , grade
FROM Highschooler
WHERE ID NOT IN (SELECT ID1
                 FROM Likes
                 UNION
                 SELECT ID2
                 FROM Likes)
ORDER BY
   grade
   , name;
 
--- Q5 For every situation where student A likes student B, but we have no information about whom B likes (that is, B does not appear as an ID1 in the Likes table), return A and B’s names and grades.
SELECT
   admirer.name, admirer.grade
   , crush.name, crush.grade
FROM Likes l
JOIN Highschooler admirer ON admirer.ID = l.ID1
JOIN Highschooler crush ON crush.ID = l.ID2
WHERE crush.ID NOT IN (SELECT ID1 FROM Likes);
 
--- Q6 Find names and grades of students who only have friends in the same grade. Return the result sorted by grade, then by name within each grade.
SELECT
   name
   , grade
FROM Highschooler
WHERE ID NOT IN (SELECT f.ID1
                 FROM Friend f
                 JOIN Highschooler h1 ON h1.ID = f.ID1
                 JOIN Highschooler h2 ON h2.ID = f.ID2
                 WHERE h1.grade != h2.grade)
ORDER BY
   grade
   , name;
 
--- Q7 For each student A who likes a student B where the two are not friends, find if they have a friend C in common (who can introduce them!). For all such trios, return the name and grade of A, B, and C.
SELECT
   admirer.name, admirer.grade
   , crush.name, crush.grade
   , mediator.name, mediator.grade
FROM Likes l
JOIN Highschooler admirer ON admirer.ID = l.ID1
JOIN Highschooler crush ON crush.ID = l.ID2
JOIN Friend admirer_friends ON admirer_friends.ID1 = admirer.ID
JOIN Friend crush_friends ON crush_friends.ID1 = crush.ID
JOIN Highschooler mediator ON mediator.ID = admirer_friends.ID2 AND mediator.ID = crush_friends.ID2
WHERE crush.ID NOT IN (SELECT ID2 FROM Friend WHERE ID1 = admirer.ID);
 
--- Q8 Find the difference between the number of students in the school and the number of different first names.
SELECT (COUNT(*) - COUNT(DISTINCT name))
FROM Highschooler;
 
--- Q9 Find the name and grade of all students who are liked by more than one other student.
SELECT
   name
   , grade
FROM Highschooler
WHERE ID IN (SELECT ID2
             FROM Likes
             GROUP BY ID2
             HAVING COUNT(*) > 1);
