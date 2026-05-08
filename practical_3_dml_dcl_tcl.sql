-- Practical No. 3: DML, DCL, and TCL Commands
-- Company Employee Management System

-- STEP 1: Create Database & Table
DROP DATABASE IF EXISTS company_db;
DROP USER IF EXISTS 'user1'@'localhost';
CREATE DATABASE company_db;
USE company_db;
SET SQL_SAFE_UPDATES = 0;

CREATE TABLE employees (
    emp_id     INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name  VARCHAR(50),
    department VARCHAR(30),
    salary     INT
);

-- STEP 2: INSERT (DML)
INSERT INTO employees VALUES
(1, 'Alice',   'Johnson', 'HR',      50000),
(2, 'Bob',     'Smith',   'IT',      60000),
(3, 'Charlie', 'Brown',   'Finance', 55000),
(4, 'David',   'Lee',     'IT',      70000),
(5, 'Eva',     'Green',   'HR',      48000);

SELECT * FROM employees;

-- STEP 3: UPDATE with Arithmetic + Logical Operator (DML)
-- Give all HR employees a 5000 raise
UPDATE employees
SET salary = salary + 5000
WHERE department = 'HR';

SELECT emp_id, first_name, department, salary FROM employees;

-- STEP 4: DELETE (DML)
-- Remove employee with emp_id = 5
DELETE FROM employees
WHERE emp_id = 5;

SELECT * FROM employees;

-- STEP 7: Pattern Matching (LIKE)
-- Find employees whose first name starts with 'A'
SELECT * FROM employees
WHERE first_name LIKE 'A%';

-- STEP 8: String Functions
SELECT
    UPPER(first_name)                    AS upper_name,
    CONCAT(first_name, ' ', last_name)   AS full_name,
    LENGTH(first_name)                   AS name_length
FROM employees;

-- STEP 9: Set Operators (UNION)
CREATE TABLE managers (
    emp_id     INT,
    first_name VARCHAR(50)
);

INSERT INTO managers VALUES
(2, 'Bob'),
(6, 'Frank');

-- Combine names from both tables, duplicates removed
SELECT first_name FROM employees
UNION
SELECT first_name FROM managers;

-- STEP 10: DCL (Access Control)
CREATE USER 'user1'@'localhost' IDENTIFIED BY '1234';

-- Give user1 permission to read and insert into employees
GRANT SELECT, INSERT ON company_db.employees TO 'user1'@'localhost';

-- Take away insert permission
REVOKE INSERT ON company_db.employees FROM 'user1'@'localhost';

-- STEP 11: TCL (Transaction Control)

-- COMMIT Example: raise Alice's salary, save it permanently
START TRANSACTION;
UPDATE employees SET salary = salary + 2000 WHERE emp_id = 1;
COMMIT;

SELECT emp_id, first_name, salary FROM employees WHERE emp_id = 1;

-- ROLLBACK Example: try to delete Charlie, then undo it
START TRANSACTION;
DELETE FROM employees WHERE emp_id = 3;
ROLLBACK;

SELECT * FROM employees WHERE emp_id = 3;  -- Charlie should still be here

-- SAVEPOINT Example:
-- Give Bob a raise (keep it), delete David (undo it)
START TRANSACTION;
UPDATE employees SET salary = 80000 WHERE emp_id = 2;
SAVEPOINT before_delete;
DELETE FROM employees WHERE emp_id = 4;
ROLLBACK TO before_delete;
COMMIT;

SELECT emp_id, first_name, salary FROM employees;
