-- Practical No. 2: DDL Commands and Integrity Constraints
-- Product Sales Management System

-- 1. Create and use database
CREATE DATABASE SalesDB;
USE SalesDB;

-- 2. Create Tables with Constraints

CREATE TABLE Customer (
    CustomerID   INT PRIMARY KEY,
    CustomerName VARCHAR(50) NOT NULL,
    Email        VARCHAR(100) NOT NULL UNIQUE,
    Phone        VARCHAR(10) UNIQUE,
    City         VARCHAR(50) NOT NULL,
    CONSTRAINT CHK_Phone CHECK (Phone REGEXP '^[0-9]{10}$')
);

CREATE TABLE Orders (
    OrderID       INT PRIMARY KEY,
    OrderDate     DATE NOT NULL,
    TotalAmount   DECIMAL(10,2) CHECK (TotalAmount > 0),
    PaymentStatus VARCHAR(20),
    CustomerID    INT,
    CONSTRAINT CHK_Status CHECK (PaymentStatus IN ('Paid', 'Pending', 'Failed')),
    CONSTRAINT FK_Customer_Order FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

-- 3. Insert Records

INSERT INTO Customer (CustomerID, CustomerName, Email, Phone, City)
VALUES
(1, 'Rahul',  'rahul@gmail.com',  '9876543210', 'Mumbai'),
(2, 'Anita',  'anita@gmail.com',  '9876501234', 'Delhi'),
(3, 'Karan',  'karan@gmail.com',  '9123456789', 'Pune'),
(4, 'Sneha',  'sneha@gmail.com',  '9988776655', 'Chennai'),
(5, 'Amit',   'amit@gmail.com',   '9090909090', 'Ahmedabad');

INSERT INTO Orders (OrderID, OrderDate, TotalAmount, PaymentStatus, CustomerID)
VALUES
(101, '2025-01-10', 5000.00, 'Paid',    1),
(102, '2025-01-12', 2500.00, 'Pending', 2),
(103, '2025-01-15', 3200.00, 'Paid',    1),
(104, '2025-01-18', 1500.00, 'Failed',  3),
(105, '2025-01-20', 4200.00, 'Paid',    4);

SELECT * FROM Customer;
SELECT * FROM Orders;

-- 4. ALTER TABLE Operations

-- Add PaymentMode column
ALTER TABLE Orders
ADD PaymentMode VARCHAR(20);

-- Add CHECK constraint on PaymentMode
ALTER TABLE Orders
ADD CONSTRAINT CHK_PaymentMode CHECK (PaymentMode IN ('Cash', 'Card', 'UPI'));

-- Modify size of CustomerName column
ALTER TABLE Customer
MODIFY CustomerName VARCHAR(100);

-- 5. Rename Orders table
RENAME TABLE Orders TO CustomerOrders;

-- 6. Truncate the renamed table
TRUNCATE TABLE CustomerOrders;

-- 7. Drop both tables (CustomerOrders first due to foreign key)
DROP TABLE CustomerOrders;
DROP TABLE Customer;
