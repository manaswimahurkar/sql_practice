-- Practical No. 6: Subqueries

DROP DATABASE IF EXISTS StudentDB;
CREATE DATABASE StudentDB;
USE StudentDB;
SET SQL_SAFE_UPDATES = 0;

-- Create Tables
CREATE TABLE Student_Info (
    ROLL_NO      INT PRIMARY KEY,
    NAME         VARCHAR(50),
    LOCATION     VARCHAR(50),
    PHONE_NUMBER VARCHAR(15)
);

CREATE TABLE Student_Section (
    ROLL_NO INT,
    SECTION CHAR(1)
);

-- Insert Data
INSERT INTO Student_Info VALUES
(101, 'Amit',  'Delhi',  '1111111111'),
(102, 'Ravi',  'Mumbai', '2222222222'),
(103, 'Neha',  'London', '3333333333'),
(104, 'Sita',  'Berlin', '4444444444'),
(201, 'John',  'Tokyo',  '5555555555');

INSERT INTO Student_Section VALUES
(101, 'A'),
(102, 'B'),
(103, 'A'),
(104, 'C'),
(201, 'A');

SELECT * FROM Student_Info;
SELECT * FROM Student_Section;

-- Example 1: Subquery in WHERE clause (Multi-row subquery using IN)
-- Get details of students who are in section 'A'
-- Inner query: finds roll numbers in section A
-- Outer query: fetches their info from Student_Info
SELECT NAME, LOCATION, PHONE_NUMBER
FROM Student_Info
WHERE ROLL_NO IN (
    SELECT ROLL_NO
    FROM Student_Section
    WHERE SECTION = 'A'
);

-- Example 2: Subquery with DELETE
-- Delete students with roll number <= 101 or equal to 201
-- MySQL requires wrapping in a temp table when deleting from same table
DELETE FROM Student_Info
WHERE ROLL_NO IN (
    SELECT ROLL_NO FROM (
        SELECT ROLL_NO
        FROM Student_Info
        WHERE ROLL_NO <= 101 OR ROLL_NO = 201
    ) AS temp_table
);

SELECT * FROM Student_Info;

-- Example 3: Subquery with UPDATE
-- Set NAME = 'amit' for students from London or Berlin
UPDATE Student_Info
SET NAME = 'amit'
WHERE LOCATION IN (
    SELECT LOCATION FROM (
        SELECT LOCATION
        FROM Student_Info
        WHERE LOCATION IN ('London', 'Berlin')
    ) AS temp
);

SELECT * FROM Student_Info;

-- Example 4: Subquery in FROM clause
-- Use subquery as a temporary table to get students from locations starting with 'T'
SELECT NAME, PHONE_NUMBER
FROM (
    SELECT NAME, PHONE_NUMBER, LOCATION
    FROM Student_Info
    WHERE LOCATION LIKE 'T%'
) AS subquery_table;

-- Example 5: Subquery with JOIN
-- Get student name, location and section for all section 'A' students
SELECT s.NAME, s.LOCATION, ns.SECTION
FROM Student_Info s
INNER JOIN (
    SELECT ROLL_NO, SECTION
    FROM Student_Section
    WHERE SECTION = 'A'
) ns
ON s.ROLL_NO = ns.ROLL_NO;
