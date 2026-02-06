/* =========================================================
   NULL HANDLING FUNCTIONS
   ========================================================= */

/*
ISNULL(value, replacement)
- Replaces NULL with a specified value
- SQL Server–specific
*/

-- Example:
-- ISNULL(Score, 0)


/*
COALESCE(val1, val2, val3, ...)
- Returns the first NON-NULL value in the list
- ANSI SQL standard (works across databases)
*/

-- Examples:
-- COALESCE(ShippingAddress, BillingAddress)
-- COALESCE(ShippingAddress, BillingAddress, 'N/A')


/* =========================================================
   ISNULL vs COALESCE
   =========================================================

ISNULL                          COALESCE
-----------------------------   -----------------------------
Only 2 arguments                Unlimited arguments
SQL Server specific             ANSI SQL (portable)
Returns datatype of first arg   Follows data type precedence

SQL equivalents:
- SQL Server : ISNULL
- Oracle     : NVL
- MySQL      : IFNULL
*/


/* =========================================================
   USE CASE: IMPACT ON AGGREGATES
   ========================================================= */

SELECT
    CustomerID,
    Score,
    COALESCE(Score, 0)                AS ScoreWithDefault,
    AVG(Score) OVER ()                AS AvgScoreIgnoringNULLs,
    AVG(COALESCE(Score, 0)) OVER ()   AS AvgScoreTreatNULLAsZero
FROM Sales.Customers;


/*
OUTPUT

CustomerID  Score   ScoreWithDefault  AvgScoreIgnoringNULLs  AvgScoreTreatNULLAsZero
----------  ------  ----------------  ---------------------  ------------------------
1           350     350                625                    500
2           900     900                625                    500
3           750     750                625                    500
4           500     500                625                    500
5           NULL    0                  625                    500

Explanation:
- AVG(Score) ignores NULL values
- AVG(COALESCE(Score,0)) forces NULLs to participate as 0
*/


/* =========================================================
   NULL BEHAVIOR EXAMPLES
   ========================================================= */

-- Arithmetic with NULL
-- NULL + 5        = NULL

-- String concatenation
-- ''   + 'B'      = 'B'
-- NULL + 'B'      = NULL


/* =========================================================
   PRACTICAL STRING CONCATENATION EXAMPLE
   ========================================================= */

SELECT
    CustomerID,
    FirstName,
    LastName,
    FirstName + ' ' + COALESCE(LastName, '') AS FullName
FROM Sales.Customers;


/*
OUTPUT

CustomerID  FirstName  LastName    FullName
----------  ---------  ----------  ----------------
1           Jossef     Goldberg    Jossef Goldberg
2           Kevin      Brown       Kevin Brown
3           Mary       NULL        Mary
*/


/* =========================================================
   BEST PRACTICES
   =========================================================
- Use COALESCE for cross-database compatibility
- Use ISNULL when you need strict SQL Server behavior
- Be careful when replacing NULLs in aggregates — it
  changes business meaning, not just output
*/

--Handling NULL in JOINS

/* =========================================================
   SOURCE TABLES
   =========================================================

   Table1
   +------+------+
   | Year | Type | Orders |
   +------+------+
   | 2024 | a    | 30     |
   | 2024 | NULL | 40     |
   | 2025 | b    | 50     |
   | 2025 | NULL | 60     |
   +------+------+

   Table2
   +------+------+
   | Year | Type | Sales |
   +------+------+
   | 2024 | a    | 100   |
   | 2024 | NULL | 200   |
   | 2025 | b    | 300   |
   | 2025 | NULL | 200   |
   +------+------+
*/


/* =========================================================
   QUERY 1: REGULAR JOIN (NULLs DO NOT MATCH)
   ========================================================= */

SELECT
    a.year,
    a.type,
    a.orders,
    b.sales
FROM Table1 a
JOIN Table2 b
  ON a.year = b.year
 AND a.type = b.type;


/*
   OUTPUT OF QUERY 1

   +------+------+
   | Year | Type | Orders | Sales |
   +------+------+
   | 2024 | a    | 30     | 100   |
   | 2025 | b    | 50     | 300   |
   +------+------+

   Explanation:
   - Rows where Type IS NULL do NOT join
   - NULL = NULL is UNKNOWN, not TRUE
*/


/* =========================================================
   QUERY 2: NULL-SAFE JOIN USING ISNULL
   ========================================================= */

SELECT
    a.year,
    a.type,
    a.orders,
    b.sales
FROM Table1 a
JOIN Table2 b
  ON a.year = b.year
 AND ISNULL(a.type,'') = ISNULL(b.type,'');


/*
   OUTPUT OF QUERY 2

   +------+------+
   | Year | Type | Orders | Sales |
   +------+------+
   | 2024 | a    | 30     | 100   |
   | 2024 | NULL | 40     | 200   |
   | 2025 | b    | 50     | 300   |
   | 2025 | NULL | 60     | 200   |
   +------+------+

   Explanation:
   - NULLs are converted to empty strings ('')
   - NULL values now successfully match
*/


/* =========================================================
   NULLIF and NULL CHECKS
   ========================================================= */

/*
NULLIF(expression1, expression2)

- Compares two expressions
- Returns NULL if expression1 = expression2
- Returns expression1 if they are NOT equal
- Commonly used to prevent divide-by-zero errors
*/

-- Basic examples
-- NULLIF(5, 5)     -> NULL
-- NULLIF(5, 10)    -> 5
-- NULLIF('A','A')  -> NULL
-- NULLIF('A','B')  -> 'A'


/*
IS NULL / IS NOT NULL

- Used to test whether a value is NULL
- '=' or '<>' cannot be used to compare NULL values
- Always use IS NULL or IS NOT NULL
*/


/* =========================================================
   FIND ROWS WITH NULL VALUES
   ========================================================= */

SELECT *
FROM Sales.Customers
WHERE Score IS NULL;


/*
OUTPUT

CustomerID  FirstName  LastName  Country  Score
----------  ---------  --------  -------  ------
5           Anna       Adams     USA      NULL
*/


/* =========================================================
   PRACTICAL USE CASES
   ========================================================= */

-- 1. Prevent division by zero
SELECT
    CustomerID,
    Score,
    Score / NULLIF(Score, 0) AS SafeDivision
FROM Sales.Customers;

-- If Score = 0 → NULLIF(Score,0) returns NULL
-- Division by NULL returns NULL instead of an error


-- 2. Convert specific values to NULL
SELECT
    CustomerID,
    NULLIF(Country, 'N/A') AS CleanCountry
FROM Sales.Customers;

-- 'N/A' becomes NULL
-- Other values remain unchanged


-- 3. Combine NULLIF with COALESCE
SELECT
    CustomerID,
    COALESCE(NULLIF(LastName, ''), 'Unknown') AS LastNameCleaned
FROM Sales.Customers;

-- Empty strings -> NULL -> replaced with 'Unknown'


/* =========================================================
   KEY TAKEAWAYS
   =========================================================
- NULLIF helps normalize or eliminate unwanted values
- IS NULL / IS NOT NULL are the ONLY safe NULL checks
- NULLIF + COALESCE is a powerful cleanup pattern
*/
