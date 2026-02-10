/* 
CASE expression:
Evaluates conditions in order and returns the result 
for the first condition that evaluates to TRUE.

Syntax:
CASE
    WHEN condition1 THEN result1
    WHEN condition2 THEN result2
    ...
    ELSE default_result
END AS ColumnName

Common use cases:
1. Categorising data (e.g., score bands, statuses)
2. Mapping values (e.g., NULL → 0, codes → labels)
*/

-- Return the first 30% of rows from the Customers table (SQL Server syntax)
SELECT TOP 30 PERCENT *
FROM Customers;

-- Return the first 3 rows from the Customers table (ANSI/Oracle/PostgreSQL syntax)
SELECT *
FROM Customers
FETCH FIRST 3 ROWS ONLY;

-- Replace NULL scores with 0 and calculate averages
SELECT
    CustomerID,
    LastName,
    Score,

    -- Cleaned score: replace NULL values with 0
    CASE
        WHEN Score IS NULL THEN 0
        ELSE Score
    END AS ScoreClean,

    -- Average of cleaned scores (NULL treated as 0) across all rows
    AVG(
        CASE
            WHEN Score IS NULL THEN 0
            ELSE Score
        END
    ) OVER () AS AvgOfClean,

    -- Average of original scores (NULL values ignored by AVG)
    AVG(Score) OVER () AS AvgOfCustomer

FROM Sales.Customers;

/*
Result explanation:

- ScoreClean replaces NULL scores with 0.
- AvgOfClean includes all customers (NULL scores counted as 0).
- AvgOfCustomer ignores NULL scores, resulting in a higher average.

Sample Output:
CustomerID | LastName  | Score | ScoreClean | AvgOfClean | AvgOfCustomer
1          | Goldberg  | 350   | 350        | 500        | 625
2          | Brown     | 900   | 900        | 500        | 625
3          | NULL      | 750   | 750        | 500        | 625
4          | Schwarz   | 500   | 500        | 500        | 625
5          | Adams     | NULL  | 0          | 500        | 625
*/
