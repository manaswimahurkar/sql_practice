-- Practical No. 8: Triggers (Audit Log System)

DROP DATABASE IF EXISTS TriggerDB;
CREATE DATABASE TriggerDB;
USE TriggerDB;

-- ─────────────────────────────────────────────
-- Step 1: Create Tables
-- ─────────────────────────────────────────────

-- Main employee table (the one being watched)
CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY,
    FirstName  VARCHAR(50),
    LastName   VARCHAR(50),
    HireDate   DATE
);

-- Audit/log table (auto-filled by triggers — never insert here manually)
CREATE TABLE EmpLog (
    LogID      INT AUTO_INCREMENT PRIMARY KEY,
    EmployeeID INT,
    FirstName  VARCHAR(50),
    LastName   VARCHAR(50),
    HireDate   DATE,
    Operation  VARCHAR(10),   -- 'INSERT', 'UPDATE', or 'DELETE'
    UpdatedOn  DATETIME,      -- exact time of change
    UpdatedBy  VARCHAR(100)   -- which MySQL user made the change
);

-- ─────────────────────────────────────────────
-- Step 2: Drop old triggers (for clean reruns)
-- ─────────────────────────────────────────────
DROP TRIGGER IF EXISTS trg_emp_insert;
DROP TRIGGER IF EXISTS trg_emp_update;
DROP TRIGGER IF EXISTS trg_emp_delete;

-- ─────────────────────────────────────────────
-- Step 3: INSERT Trigger
-- Fires AFTER a new row is added to Employee
-- NEW = the row that was just inserted
-- ─────────────────────────────────────────────
DELIMITER //
CREATE TRIGGER trg_emp_insert
AFTER INSERT ON Employee
FOR EACH ROW
BEGIN
    INSERT INTO EmpLog (EmployeeID, FirstName, LastName, HireDate, Operation, UpdatedOn, UpdatedBy)
    VALUES (NEW.EmployeeID, NEW.FirstName, NEW.LastName, NEW.HireDate, 'INSERT', NOW(), USER());
END//
DELIMITER ;

-- ─────────────────────────────────────────────
-- Step 4: UPDATE Trigger
-- Fires AFTER an existing row is changed
-- NEW = values after update
-- OLD = values before update (also available if needed)
-- ─────────────────────────────────────────────
DELIMITER //
CREATE TRIGGER trg_emp_update
AFTER UPDATE ON Employee
FOR EACH ROW
BEGIN
    INSERT INTO EmpLog (EmployeeID, FirstName, LastName, HireDate, Operation, UpdatedOn, UpdatedBy)
    VALUES (NEW.EmployeeID, NEW.FirstName, NEW.LastName, NEW.HireDate, 'UPDATE', NOW(), USER());
END//
DELIMITER ;

-- ─────────────────────────────────────────────
-- Step 5: DELETE Trigger
-- Fires AFTER a row is deleted from Employee
-- OLD = the row that was just deleted (NEW doesn't exist here)
-- ─────────────────────────────────────────────
DELIMITER //
CREATE TRIGGER trg_emp_delete
AFTER DELETE ON Employee
FOR EACH ROW
BEGIN
    INSERT INTO EmpLog (EmployeeID, FirstName, LastName, HireDate, Operation, UpdatedOn, UpdatedBy)
    VALUES (OLD.EmployeeID, OLD.FirstName, OLD.LastName, OLD.HireDate, 'DELETE', NOW(), USER());
END//
DELIMITER ;

-- ─────────────────────────────────────────────
-- Step 6: Test the triggers
-- ─────────────────────────────────────────────

-- INSERT: adds Amit → trigger fires → EmpLog gets 1 row (INSERT)
INSERT INTO Employee VALUES (1, 'Amit', 'Sharma', '2024-01-10');

SELECT * FROM Employee;
SELECT * FROM EmpLog;   -- should show 1 row: Operation = 'INSERT'

-- UPDATE: change last name → trigger fires → EmpLog gets another row (UPDATE)
UPDATE Employee
SET LastName = 'Kumar'
WHERE EmployeeID = 1;

SELECT * FROM Employee;
SELECT * FROM EmpLog;   -- should show 2 rows now: INSERT + UPDATE

-- DELETE: remove Amit → trigger fires → EmpLog gets another row (DELETE)
DELETE FROM Employee
WHERE EmployeeID = 1;

SELECT * FROM Employee; -- should be empty now
SELECT * FROM EmpLog;   -- should show 3 rows: INSERT + UPDATE + DELETE
