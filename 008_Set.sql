use SalesDB
/*
========================================================
 SET OPERATOR RULES
========================================================
1. SET operators can be used in:
   WHERE | JOIN | GROUP BY | HAVING
   ORDER BY is allowed only once at the end

2. Number of columns in each query must be the same

3. Data types of columns must be compatible

4. Column order must be the same in all queries

5. Column names in the result are taken from the first query

6. Incorrect column selection may lead to incorrect results
========================================================*/


/*========================================================
 BASIC SELECTS
========================================================*/
SELECT FirstName, LastName 
FROM Sales.Employees;

-- Output:
-- Frank     Lee
-- Kevin     Brown
-- Mary      NULL
-- Michael   Ray
-- Carol     Baker


SELECT FirstName, LastName 
FROM Sales.Customers;

-- Output:
-- Jossef    Goldberg
-- Kevin     Brown
-- Mary      NULL
-- Mark      Schwarz
-- Anna      Adams


/*========================================================
 UNION
 Returns all DISTINCT rows from both queries
 Removes duplicates
========================================================*/
SELECT FirstName, LastName 
FROM Sales.Customers
UNION
SELECT FirstName, LastName 
FROM Sales.Employees;

-- Output:
-- Anna      Adams
-- Carol     Baker
-- Frank     Lee
-- Jossef    Goldberg
-- Kevin     Brown
-- Mark      Schwarz
-- Mary      NULL
-- Michael   Ray


/*========================================================
 UNION ALL
 Returns ALL rows including duplicates
========================================================*/
SELECT FirstName, LastName 
FROM Sales.Customers
UNION ALL
SELECT FirstName, LastName 
FROM Sales.Employees;

-- Output:
-- Jossef    Goldberg
-- Kevin     Brown
-- Mary      NULL
-- Mark      Schwarz
-- Anna      Adams
-- Frank     Lee
-- Kevin     Brown
-- Mary      NULL
-- Michael   Ray
-- Carol     Baker


/*========================================================
 EXCEPT (MINUS)
 Returns rows from FIRST query that do NOT exist in second
 Find customers who are NOT employees
========================================================*/
SELECT FirstName, LastName 
FROM Sales.Customers
EXCEPT
SELECT FirstName, LastName 
FROM Sales.Employees;

-- Output:
-- Jossef    Goldberg
-- Mark      Schwarz
-- Anna      Adams


/*========================================================
 INTERSECT
 Returns COMMON rows between both queries
 Find employees who are also customers
========================================================*/
SELECT FirstName, LastName 
FROM Sales.Employees
INTERSECT
SELECT FirstName, LastName 
FROM Sales.Customers;

-- Output:
-- Kevin     Brown
-- Mary      NULL
