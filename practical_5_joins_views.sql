-- Practical No. 5: JOIN Operations and Views

-- ============================================================
-- PART 1: JOIN Operations (Online Shopping System)
-- ============================================================

DROP DATABASE IF EXISTS online_shop_db;
CREATE DATABASE online_shop_db;
USE online_shop_db;

CREATE TABLE customers (
    customer_id   INT PRIMARY KEY,
    customer_name VARCHAR(50)
);

CREATE TABLE orders (
    order_id    INT PRIMARY KEY,
    customer_id INT,
    order_date  DATE
);

CREATE TABLE order_items (
    item_id      INT PRIMARY KEY,
    order_id     INT,
    product_name VARCHAR(50),
    price        DECIMAL(10,2)
);

-- Insert Data
INSERT INTO customers VALUES
(1, 'Rahul'),
(2, 'Sneha'),
(3, 'Arjun'),
(4, 'Meena');

-- Note: Arjun and Meena have no orders (to demonstrate LEFT JOIN)
INSERT INTO orders VALUES
(101, 1, '2025-01-10'),
(102, 2, '2025-02-15'),
(103, 1, '2025-03-01');

INSERT INTO order_items VALUES
(1, 101, 'Laptop',     50000),
(2, 101, 'Mouse',        500),
(3, 102, 'Phone',      20000),
(4, 103, 'Tablet',     15000),
(5, 103, 'Headphones',  2000);

-- INNER JOIN: only customers who have orders
SELECT c.customer_name, o.order_id
FROM customers c
INNER JOIN orders o
ON c.customer_id = o.customer_id;

-- LEFT JOIN: all customers, NULL if no order
SELECT c.customer_name, o.order_id
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id;

-- RIGHT JOIN: all orders, with matching customer
SELECT c.customer_name, o.order_id
FROM customers c
RIGHT JOIN orders o
ON c.customer_id = o.customer_id;

-- FULL OUTER JOIN (simulated in MySQL using UNION)
SELECT c.customer_name, o.order_id
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
UNION
SELECT c.customer_name, o.order_id
FROM customers c
RIGHT JOIN orders o ON c.customer_id = o.customer_id;


-- ============================================================
-- PART 2: Views (Company Database)
-- ============================================================

DROP DATABASE IF EXISTS company_db;
CREATE DATABASE company_db;
USE company_db;

CREATE TABLE departments (
    dept_id   INT PRIMARY KEY,
    dept_name VARCHAR(50)
);

CREATE TABLE employees (
    emp_id   INT PRIMARY KEY,
    emp_name VARCHAR(50),
    salary   INT,
    dept_id  INT,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

INSERT INTO departments VALUES
(1, 'IT'),
(2, 'HR');

INSERT INTO employees VALUES
(1, 'Amit', 50000, 1),
(2, 'Neha', 60000, 1),
(3, 'Raj',  40000, 2),
(4, 'Sita', 70000, 1);

-- SIMPLE VIEW: employees with salary > 50000
CREATE VIEW high_salary AS
SELECT emp_name, salary
FROM employees
WHERE salary > 50000;

SELECT * FROM high_salary;

-- UPDATE SIMPLE VIEW: raise threshold to > 60000
CREATE OR REPLACE VIEW high_salary AS
SELECT emp_name, salary
FROM employees
WHERE salary > 60000;

SELECT * FROM high_salary;

-- DROP SIMPLE VIEW
DROP VIEW high_salary;

-- COMPLEX VIEW: department summary using JOIN + GROUP BY
CREATE VIEW dept_summary AS
SELECT d.dept_name,
       COUNT(e.emp_id)  AS total_employees,
       SUM(e.salary)    AS total_salary
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
GROUP BY d.dept_name;

SELECT * FROM dept_summary;

-- UPDATE COMPLEX VIEW: add average salary
CREATE OR REPLACE VIEW dept_summary AS
SELECT d.dept_name,
       COUNT(e.emp_id)  AS total_employees,
       SUM(e.salary)    AS total_salary,
       AVG(e.salary)    AS avg_salary
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
GROUP BY d.dept_name;

SELECT * FROM dept_summary;

-- DROP COMPLEX VIEW
DROP VIEW dept_summary;

-- MATERIALIZED VIEW (simulated with a real table in MySQL)
CREATE TABLE emp_summary AS
SELECT dept_id,
       COUNT(emp_id) AS total_employees,
       SUM(salary)   AS total_salary
FROM employees
GROUP BY dept_id;

SELECT * FROM emp_summary;

-- Refresh Materialized View (manually)
TRUNCATE TABLE emp_summary;
INSERT INTO emp_summary
SELECT dept_id, COUNT(emp_id), SUM(salary)
FROM employees
GROUP BY dept_id;

SELECT * FROM emp_summary;

-- DROP Materialized View
DROP TABLE emp_summary;
