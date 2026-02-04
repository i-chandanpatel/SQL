-- Step 1: Create table
CREATE TABLE SalesDemo (
    OrderID INT,
    OrderDate DATE,
    Amount INT
);

-- Step 2: Insert random data (OrderIDs NOT ordered)
INSERT INTO SalesDemo VALUES
(3, '2025-01-10', 150),
(1, '2025-01-01', 100),
(4, '2025-01-20', 300),
(2, '2025-01-05', 200);

-- Step 3: LAG and LEAD using ORDER BY OrderID
-- This treats "previous" and "next" according to OrderID
SELECT
    OrderID,
    OrderDate,
    Amount,
    LAG(Amount) OVER (ORDER BY OrderID) AS PrevAmount_ByID,
    LEAD(Amount) OVER (ORDER BY OrderID) AS NextAmount_ByID
FROM SalesDemo;

-- STEP 3 Explanation:
-- The rows are logically ordered by OrderID: 1 → 2 → 3 → 4
-- LAG/LEAD will use this order, not the original table order

-- Expected result:

-- OrderID | OrderDate   | Amount | PrevAmount_ByID | NextAmount_ByID
-- 1       | 2025-01-01 | 100    | NULL            | 200
-- 2       | 2025-01-05 | 200    | 100             | 150
-- 3       | 2025-01-10 | 150    | 200             | 300
-- 4       | 2025-01-20 | 300    | 150             | NULL

---------------------------------------------------

-- Step 4: LAG and LEAD using ORDER BY OrderDate
-- This treats "previous" and "next" according to OrderDate
SELECT
    OrderID,
    OrderDate,
    Amount,
    LAG(Amount) OVER (ORDER BY OrderDate) AS PrevAmount_ByDate,
    LEAD(Amount) OVER (ORDER BY OrderDate) AS NextAmount_ByDate
FROM SalesDemo;

-- STEP 4 Explanation:
-- The rows are logically ordered by date: Jan 1 → Jan 5 → Jan 10 → Jan 20
-- LAG/LEAD now refers to previous/next order in time

-- Expected result:

-- OrderID | OrderDate   | Amount | PrevAmount_ByDate | NextAmount_ByDate
-- 1       | 2025-01-01 | 100    | NULL             | 200
-- 2       | 2025-01-05 | 200    | 100              | 150
-- 3       | 2025-01-10 | 150    | 200              | 300
-- 4       | 2025-01-20 | 300    | 150              | NULL

---------------------------------------------------

-- Step 5: Key observation
-- 1️⃣ ORDER BY inside OVER() defines how LAG/LEAD sees "previous" and "next"
-- 2️⃣ The table storage order (how we inserted rows) does NOT matter
-- 3️⃣ Changing ORDER BY from OrderID → OrderDate changes the output

--ISDATE(): Checks if a value can be converted to a valid date.

SELECT 
ISDATE('2025-02-15') AS IsValid1,  -- 1 = yes
ISDATE('abcd') AS IsValid2;        -- 0 = no
