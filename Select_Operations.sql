/* =========================================================
   SQL SELECT OPERATIONS – COMPLETE PRACTICE FILE
   Focus: SELECT queries
   Table: customers
   ========================================================= */


/* =========================================================
   TABLE STRUCTURE (Reference)
   =========================================================
   id | first_name | country | score

   1  | Maria      | Germany | 350
   2  | John       | USA     | 900
   3  | Georg      | UK      | 750
   4  | Martin     | Germany | 500
   5  | Peter      | USA     | 0
   ========================================================= */


/* =========================================================
   IMPORTANT NOTE ON QUOTES
   ---------------------------------------------------------
   'single quotes' → used for STRING literals (standard SQL)
   "double quotes" → used for identifiers (column/table names)

   Some databases allow double quotes for strings, but
   standard SQL recommends single quotes only.
   ========================================================= */


/* =========================================================
   1. WHERE with comparison
   Question:
   Retrieve all customers whose score is greater than
   or equal to 500
   ========================================================= */

-- In '' we can put string(chars) and numbers
-- But in "" only String (NOT standard SQL, avoid using "")

SELECT *
FROM customers
WHERE score >= '500';

-- Output:
-- id | first_name | country | score
-- ---------------------------------
-- 2  | John       | USA     | 900
-- 3  | Georg      | UK      | 750
-- 4  | Martin     | Germany | 500



/* =========================================================
   2. WHERE with string comparison
   Question:
   Display first name and country of customers from Germany
   ========================================================= */

SELECT first_name, country
FROM customers
WHERE country = 'Germany';

-- Output:
-- first_name | country
-- --------------------
-- Maria      | Germany
-- Martin     | Germany



/* =========================================================
   3. ORDER BY (default ASC)
   Question:
   Sort customers by score in ascending order
   ========================================================= */

-- Sorting: By default Ascending (ASC)

SELECT first_name
FROM customers
ORDER BY score;

-- Output:
-- first_name
-- ----------
-- Peter
-- Maria
-- Martin
-- Georg
-- John



/* =========================================================
   4. ORDER BY ASC (explicit)
   Question:
   Sort customers by score in ascending order explicitly
   ========================================================= */

SELECT first_name
FROM customers
ORDER BY score ASC;

-- Output:
-- first_name
-- ----------
-- Peter
-- Maria
-- Martin
-- Georg
-- John



/* =========================================================
   5. ORDER BY DESC
   Question:
   Sort customers by score in descending order
   ========================================================= */

SELECT first_name
FROM customers
ORDER BY score DESC;

-- Output:
-- first_name
-- ----------
-- John
-- Georg
-- Martin
-- Maria
-- Peter



/* =========================================================
   6. ORDER BY multiple columns
   Question:
   Sort first by country (ASC) and then by score (DESC)
   ========================================================= */

-- Sorts firstly based on country and then score

SELECT *
FROM customers
ORDER BY country ASC, score DESC;

-- Output:
-- id | first_name | country | score
-- ---------------------------------
-- 4  | Martin     | Germany | 500
-- 1  | Maria      | Germany | 350
-- 3  | Georg      | UK      | 750
-- 2  | John       | USA     | 900
-- 5  | Peter      | USA     | 0



/* =========================================================
   7. ORDER BY priority change
   Question:
   Sort first by score (DESC) and then by country (ASC)
   ========================================================= */

SELECT *
FROM customers
ORDER BY score DESC, country ASC;

-- Output:
-- id | first_name | country | score
-- ---------------------------------
-- 2  | John       | USA     | 900
-- 3  | Georg      | UK      | 750
-- 4  | Martin     | Germany | 500
-- 1  | Maria      | Germany | 350
-- 5  | Peter      | USA     | 0



/* =========================================================
   8. GROUP BY with SUM
   Question:
   Find total score for each country
   ========================================================= */

-- Group by: Combines rows with same values
-- SUM is an aggregate function

SELECT country, SUM(score)
FROM customers
GROUP BY country;

-- Output:
-- country | sum
-- ----------------
-- Germany | 850
-- USA     | 900
-- UK      | 750



/* =========================================================
   9. GROUP BY with alias
   Question:
   Find total score for each country with alias
   ========================================================= */

SELECT country, SUM(score) AS Total_Score
FROM customers
GROUP BY country;

-- Output:
-- country | Total_Score
-- --------------------
-- Germany | 850
-- USA     | 900
-- UK      | 750



/* =========================================================
   10. GROUP BY rule demonstration
   ========================================================= */

-- Group by rule:
-- All columns in SELECT must be either aggregated
-- or included in GROUP BY

-- ❌ This will NOT work:
-- SELECT country, first_name, SUM(score)
-- FROM customers
-- GROUP BY country;

-- ✅ Correct version:

SELECT country, first_name, SUM(score) AS Total_Score
FROM customers
GROUP BY country, first_name;

-- Output:
-- country | first_name | Total_Score
-- ----------------------------------
-- Germany | Maria      | 350
-- Germany | Martin     | 500
-- USA     | John       | 900
-- USA     | Peter      | 0
-- UK      | Georg      | 750



/* =========================================================
   11. COUNT with GROUP BY
   Question:
   Count total number of customers per country
   ========================================================= */

SELECT country, COUNT(id) AS Total_Customers
FROM customers
GROUP BY country;

-- Output:
-- country | Total_Customers
-- ------------------------
-- Germany | 2
-- USA     | 2
-- UK      | 1



/* =========================================================
   12. HAVING clause
   Question:
   Filter countries having total score greater than 800
   ========================================================= */

-- HAVING filters AFTER aggregation

SELECT country, SUM(score) AS Total_Score
FROM customers
GROUP BY country
HAVING SUM(score) > 800;

-- Output:
-- country | Total_Score
-- --------------------
-- Germany | 850
-- USA     | 900



/* =========================================================
   13. WHERE + HAVING
   Question:
   Consider customers with score > 400 and then filter
   countries with total score > 800
   ========================================================= */

-- WHERE filters BEFORE aggregation

SELECT country, SUM(score) AS Total_Score
FROM customers
WHERE score > 400
GROUP BY country
HAVING SUM(score) > 800;

-- Output:
-- country | Total_Score
-- --------------------
-- USA     | 900



/* =========================================================
   14. AVG with conditions
   Question:
   Exclude score = 0 and return countries whose
   average score is greater than 430
   ========================================================= */

SELECT country, AVG(score) AS Avg_Score
FROM customers
WHERE score != 0
GROUP BY country
HAVING AVG(score) > 430;

-- Output:
-- country | Avg_Score
-- ------------------
-- USA     | 900
-- UK      | 750



/* =========================================================
   15. DISTINCT
   Question:
   Retrieve unique list of countries
   ========================================================= */

-- DISTINCT removes duplicate values

SELECT DISTINCT country
FROM customers;

-- Output:
-- country
-- -------
-- Germany
-- USA
-- UK



/* =========================================================
   16. TOP / LIMIT
   Question:
   Restrict number of rows returned
   ========================================================= */

-- ⚠ SQL SERVER ONLY
SELECT TOP 3 *
FROM customers;

-- Output:
-- id | first_name | country | score
-- ---------------------------------
-- 1  | Maria      | Germany | 350
-- 2  | John       | USA     | 900
-- 3  | Georg      | UK      | 750

-- MySQL / PostgreSQL equivalent:
-- SELECT * FROM customers LIMIT 3;
