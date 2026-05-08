-- Practical No. 7: Stored Procedures with Cursors

DROP DATABASE IF EXISTS StoreDB;
CREATE DATABASE StoreDB;
USE StoreDB;

-- Create Tables
CREATE TABLE Products (
    ProductID   INT AUTO_INCREMENT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category    VARCHAR(50),
    Price       DECIMAL(10,2)
);

CREATE TABLE Employees (
    EmpID      INT AUTO_INCREMENT PRIMARY KEY,
    EmpName    VARCHAR(100),
    Department VARCHAR(50),
    Salary     DECIMAL(10,2)
);

-- Insert Data
INSERT INTO Products (ProductName, Category, Price) VALUES
('Laptop', 'Electronics', 50000),
('Mobile', 'Electronics', 20000),
('Table',  'Furniture',    8000),
('Chair',  'Furniture',    3000);

INSERT INTO Employees (EmpName, Department, Salary) VALUES
('Amit', 'IT', 40000),
('Ravi', 'HR', 30000),
('Sita', 'IT', 50000);

SELECT * FROM Products;
SELECT * FROM Employees;

-- Drop old procedures before recreating
DROP PROCEDURE IF EXISTS UpdateElectronicsPrices;
DROP PROCEDURE IF EXISTS IncreaseITSalary;

-- Change delimiter so MySQL doesn't confuse the ; inside procedures
DELIMITER $$

-- Procedure 1: Update price of all Electronics products by a given percentage
-- Cursor walks each Electronics row one by one and updates its price
CREATE PROCEDURE UpdateElectronicsPrices(IN increasePercent DECIMAL(5,2))
BEGIN
    DECLARE done      INT DEFAULT 0;
    DECLARE vProdID   INT;
    DECLARE vProdName VARCHAR(100);
    DECLARE vPrice    DECIMAL(10,2);

    DECLARE product_cursor CURSOR FOR
        SELECT ProductID, ProductName, Price
        FROM Products
        WHERE Category = 'Electronics';

    -- When cursor runs out of rows, set done = 1 to exit loop
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN product_cursor;

    read_loop: LOOP
        FETCH product_cursor INTO vProdID, vProdName, vPrice;
        IF done THEN
            LEAVE read_loop;
        END IF;

        UPDATE Products
        SET Price = Price + (Price * increasePercent / 100)
        WHERE ProductID = vProdID;

        SELECT CONCAT('Updated: ', vProdName,
                      ' | New Price: ',
                      vPrice + (vPrice * increasePercent / 100)) AS Message;
    END LOOP;

    CLOSE product_cursor;
END$$

-- Procedure 2: Increase salary of all IT department employees by 15%
CREATE PROCEDURE IncreaseITSalary()
BEGIN
    DECLARE done    INT DEFAULT 0;
    DECLARE vID     INT;
    DECLARE vSalary DECIMAL(10,2);

    DECLARE emp_cursor CURSOR FOR
        SELECT EmpID, Salary
        FROM Employees
        WHERE Department = 'IT';

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN emp_cursor;

    read_loop: LOOP
        FETCH emp_cursor INTO vID, vSalary;
        IF done THEN
            LEAVE read_loop;
        END IF;

        UPDATE Employees
        SET Salary = Salary + (Salary * 0.15)
        WHERE EmpID = vID;
    END LOOP;

    CLOSE emp_cursor;
END$$

-- Reset delimiter back to normal
DELIMITER ;

-- Call the procedures
CALL UpdateElectronicsPrices(10);
CALL IncreaseITSalary();

-- View final results
SELECT * FROM Products;
SELECT * FROM Employees;
