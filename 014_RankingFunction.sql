/*==============================================================
RANKING FUNCTIONS (Window Functions)

Ranking functions are used to assign a position or order to rows
within a result set.

There are two main categories:

1️⃣  Integer-Based Ranking (Top/Bottom N Analysis)
    ------------------------------------------------
    • ROW_NUMBER()   → Unique sequential number (no tie handling)
    • RANK()         → Same rank for ties, leaves gaps
    • DENSE_RANK()   → Same rank for ties, no gaps
    • NTILE(n)       → Divides rows into n approximately equal buckets

2️⃣  Percentage-Based Ranking (Distribution Analysis)
    ------------------------------------------------
    • CUME_DIST()    → Cumulative distribution (0–1)
    • PERCENT_RANK() → Relative rank (0–1 scale)

General Syntax:
    <function>() OVER (
        PARTITION BY column   -- optional (group-wise ranking)
        ORDER BY column       -- required (defines ranking order)
    )
==============================================================*/


/*==============================================================
ROW_NUMBER()

Assigns a unique sequential number to each row.
Does NOT handle ties — even identical values get different numbers.

Common Use Cases:
• Top N per category
• Bottom N analysis
• De-duplication
• Assigning temporary unique IDs
==============================================================*/

SELECT 
    OrderID,
    ProductID,
    Sales,
    ROW_NUMBER() OVER (ORDER BY Sales DESC) AS SalesRank
FROM Sales.Orders;

/*
OrderID | ProductID | Sales | SalesRank
8       | 101       | 90    | 1
4       | 105       | 60    | 2
10      | 102       | 60    | 3
6       | 104       | 50    | 4
7       | 102       | 30    | 5
5       | 104       | 25    | 6
9       | 101       | 20    | 7
3       | 101       | 20    | 8
2       | 102       | 15    | 9
1       | 101       | 10    | 10
*/


/*==============================================================
RANK()

Assigns the same rank to tied values.
Leaves gaps in ranking after ties.

Example:
If two rows tie for rank 2,
the next rank will be 4 (not 3).

Use Case:
• Competition-style ranking (Olympics, leaderboards)
==============================================================*/

SELECT 
    OrderID,
    ProductID,
    Sales,
    RANK() OVER (ORDER BY Sales DESC) AS SalesRank
FROM Sales.Orders;
/*
OrderID | ProductID | Sales | SalesRank
8       | 101       | 90    | 1
4       | 105       | 60    | 2
10      | 102       | 60    | 2
6       | 104       | 50    | 4
7       | 102       | 30    | 5
5       | 104       | 25    | 6
9       | 101       | 20    | 7
3       | 101       | 20    | 7
2       | 102       | 15    | 9
1       | 101       | 10    | 10
*/


/*==============================================================
DENSE_RANK()

Assigns same rank to ties.
Does NOT leave gaps in ranking.

Example:
If two rows tie for rank 2,
the next rank will be 3.

Use Case:
• Business ranking where gaps are not desired
• Performance tier classification
==============================================================*/

SELECT 
    OrderID,
    ProductID,
    Sales,
    DENSE_RANK() OVER (ORDER BY Sales DESC) AS SalesRank
FROM Sales.Orders;

/*
OrderID | ProductID | Sales | SalesRank
8       | 101       | 90    | 1
4       | 105       | 60    | 2
10      | 102       | 60    | 2
6       | 104       | 50    | 3
7       | 102       | 30    | 4
5       | 104       | 25    | 5
9       | 101       | 20    | 6
3       | 101       | 20    | 6
2       | 102       | 15    | 7
1       | 101       | 10    | 8
*/



--use case of the row_number()

--use case 1: TOP N Analysis

--Find top highest sales for each product
SELECT OrderID,ProductID,Sales,
ROW_NUMBER() OVER(PARTITION BY ProductID ORDER BY Sales DESC) RankByProduct
FROM Sales.Orders

/*
OrderID | ProductID | Sales | RankByProduct
8       | 101       | 90    | 1
9       | 101       | 20    | 2
3       | 101       | 20    | 3
1       | 101       | 10    | 4
10      | 102       | 60    | 1
7       | 102       | 30    | 2
2       | 102       | 15    | 3
6       | 104       | 50    | 1
5       | 104       | 25    | 2
4       | 105       | 60    | 1
*/


/*==============================================================
Goal:
Find the highest sale for each ProductID.

Logic:
1. Partition data by ProductID
2. Rank within each product group
3. Keep only rank = 1
==============================================================*/

SELECT *
FROM (
    SELECT 
        OrderID,
        ProductID,
        Sales,
        ROW_NUMBER() OVER (
            PARTITION BY ProductID 
            ORDER BY Sales DESC
        ) AS RankByProduct
    FROM Sales.Orders
) t
WHERE RankByProduct = 1;

/*
OrderID | ProductID | Sales | RankByProduct
8       | 101       | 90    | 1
10      | 102       | 60    | 1
6       | 104       | 50    | 1
4       | 105       | 60    | 1
*/

