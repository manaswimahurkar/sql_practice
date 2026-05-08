-- Practical No. 4: Aggregate Functions, GROUP BY and HAVING
-- Employee Salary Analysis

-- Setup
DROP DATABASE IF EXISTS emp_db;
CREATE DATABASE emp_db;
USE emp_db;

-- Create Table
CREATE TABLE employee (
    empno    VARCHAR(5) PRIMARY KEY,
    emp_name VARCHAR(50),
    dept     VARCHAR(50),
    salary   DECIMAL(10,2),
    doj      DATE,
    branch   VARCHAR(50)
);

-- Insert Records
INSERT INTO employee VALUES
('E101', 'Amit',   'Production', 45000,  '2000-03-12', 'Bangalore'),
('E102', 'Amit',   'HR',         70000,  '2002-07-03', 'Bangalore'),
('E103', 'Sunita', 'Management', 120000, '2001-01-11', 'Mysore'),
('E104', 'Sunita', 'IT',         67000,  '2001-08-01', 'Mysore'),
('E105', 'Mahesh', 'Civil',      145000, '2003-09-20', 'Mumbai'),
('E106', 'Ravi',   'Production', 55000,  '2004-02-15', 'Bangalore'),
('E107', 'Priya',  'HR',         75000,  '2002-06-12', 'Mysore'),
('E108', 'Kiran',  'IT',         68000,  '2003-03-22', 'Bangalore'),
('E109', 'Neha',   'Management', 125000, '2001-05-05', 'Mumbai'),
('E110', 'Mahesh', 'Civil',      155000, '2004-10-10', 'Bangalore');

-- 1. Display all fields
SELECT * FROM employee;

-- 2. Retrieve EMPNO and SALARY of all employees
SELECT empno, salary FROM employee;

-- 3. Total number of employees
SELECT COUNT(*) AS total_employees FROM employee;

-- 4. Total salary of all employees
SELECT SUM(salary) AS total_salary FROM employee;

-- 5. Average salary of all employees
SELECT AVG(salary) AS avg_salary FROM employee;

-- 6. Highest salary
SELECT MAX(salary) AS max_salary FROM employee;

-- 7. Lowest salary
SELECT MIN(salary) AS min_salary FROM employee;

-- 8. Total salary per employee name
SELECT emp_name, SUM(salary) AS total_salary
FROM employee
GROUP BY emp_name;

-- 9. Average salary per employee name
SELECT emp_name, AVG(salary) AS avg_salary
FROM employee
GROUP BY emp_name;

-- 10. Maximum salary per employee name
SELECT emp_name, MAX(salary) AS max_salary
FROM employee
GROUP BY emp_name;

-- 11. Minimum salary per employee name
SELECT emp_name, MIN(salary) AS min_salary
FROM employee
GROUP BY emp_name;

-- 12. Employee names whose average salary > 60,000 (HAVING)
SELECT emp_name, AVG(salary) AS avg_salary
FROM employee
GROUP BY emp_name
HAVING AVG(salary) > 60000;

-- 13. Departments whose total salary > 150,000 (HAVING)
SELECT dept, SUM(salary) AS total_salary
FROM employee
GROUP BY dept
HAVING SUM(salary) > 150000;

-- 14. Branches whose average salary > 70,000 (HAVING)
SELECT branch, AVG(salary) AS avg_salary
FROM employee
GROUP BY branch
HAVING AVG(salary) > 70000;
