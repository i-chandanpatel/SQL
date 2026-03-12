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



--USE CASE of the row_number()

--USE CASE 1: TOP N Analysis

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


-- Bottom N Analysis (Raw Ranking)
SELECT 
    CustomerID,
    SUM(Sales) AS TotalSales,
    ROW_NUMBER() OVER (ORDER BY SUM(Sales)) AS RankCustomers
FROM Sales.Orders
GROUP BY CustomerID;

/*
CustomerID | TotalSales | RankCustomers
2          | 55         | 1
4          | 90         | 2
1          | 110        | 3
3          | 125        | 4
*/



/*==============================================================
Goal:
Identify customers with lowest total sales.

Logic:
1. Aggregate total sales per customer
2. Rank customers ascending
3. Select bottom N
==============================================================*/

SELECT *
FROM (
    SELECT 
        CustomerID,
        SUM(Sales) AS TotalSales,
        ROW_NUMBER() OVER (
            ORDER BY SUM(Sales) ASC
        ) AS RankCustomers
    FROM Sales.Orders
    GROUP BY CustomerID
) t
WHERE RankCustomers <= 2;

/*
CustomerID | TotalSales | RankCustomers
2          | 55         | 1
4          | 90         | 2
*/



--USE CASE 3: Assign Unique IDs
/*==============================================================
Goal:
Generate sequential unique IDs dynamically.

Useful when:
• Table lacks a primary key
• Creating export files
• Data migration processes
==============================================================*/

SELECT
    ROW_NUMBER() OVER (
        ORDER BY OrderID, OrderDate
    ) AS UniqueID,
    *
FROM Sales.OrdersArchive;

/*
UniqueID | OrderID | CustomerID | ProductID | Quantity | OrderDate   | ShipDate    | OrderStatus
1        | 1       | 101        | 2         | 3        | 2024-04-01  | 2024-04-05  | Shipped
2        | 2       | 102        | 3         | 3        | 2024-04-05  | 2024-04-10  | Shipped
3        | 3       | 101        | 1         | 4        | 2024-04-10  | 2024-04-25  | Shipped
4        | 4       | 105        | 1         | 3        | 2024-04-20  | 2024-04-25  | Shipped
5        | 4       | 105        | 1         | 3        | 2024-04-20  | 2024-04-25  | Delivered
6        | 5       | 104        | 2         | 5        | 2024-05-01  | 2024-05-05  | Shipped
7        | 6       | 104        | 3         | 5        | 2024-05-05  | 2024-05-10  | Delivered
8        | 6       | 104        | 3         | 5        | 2024-05-05  | 2024-05-10  | Delivered
9        | 6       | 101        | 3         | 5        | 2024-05-05  | 2024-05-10  | Delivered
10       | 7       | 102        | 3         | 5        | 2024-06-15  | 2024-06-20  | Shipped
*/



--Use Case 4 : identify duplicates

SELECT
    ROW_NUMBER() OVER(
        PARTITION BY OrderID
        ORDER BY CreationTime DESC) rn,
    OrderID, CustomerID, OrderDate, ShipDate, OrderStatus
FROM Sales.OrdersArchive

/*
rn | OrderID | CustomerID |  OrderDate   | ShipDate   |OrderStatus|
1    	1	        2	    2024-04-01	   2024-04-05	Shipped
1	    2	        3	    2024-04-05	   2024-04-10	Shipped
1	    3	        1	    2024-04-10	   2024-04-25	Shipped
1	    4	        1	    2024-04-20	   2024-04-25	Delivered
2	    4	        1       2024-04-20	   2024-04-25	Shipped
1	    5	        2	    2024-05-01	   2024-05-05	Shipped
1	    6	        3	    2024-05-05	   2024-05-10	Delivered
2	    6	        3	    2024-05-05     2024-05-10	Delivered
3	    6	        3	    2024-05-05     2024-05-10	Delivered
1	    7	        3	    2024-06-15	   2024-06-20	Shipped
*/

/*==============================================================
Goal:
Identify duplicate OrderIDs.
Keep only the most recent record based on CreationTime.

Logic:
1. Partition by OrderID
2. Order by CreationTime DESC (latest first)
3. Keep only row_number = 1
==============================================================*/

SELECT *
FROM (
    SELECT
        ROW_NUMBER() OVER (
            PARTITION BY OrderID 
            ORDER BY CreationTime DESC
        ) AS rn,
        *
    FROM Sales.OrdersArchive
) t
WHERE rn = 1;


/*
rn | OrderID | CustomerID | ProductID | Quantity | OrderDate   | ShipDate    | OrderStatus | ShippingAddress     | BillingAddress    | Priority | Sales | CreationTime
1  | 1       | 101        | 2         | 3        | 2024-04-01  | 2024-04-05  | Shipped     | 123 Main St        | 456 Billing St   | 1        | 10    | 2024-04-01 12:34:56.0000000
1  | 2       | 102        | 3         | 3        | 2024-04-05  | 2024-04-10  | Shipped     | 456 Elm St         | 789 Billing St   | 1        | 15    | 2024-04-05 23:22:04.0000000
1  | 3       | 101        | 1         | 4        | 2024-04-10  | 2024-04-25  | Shipped     | 789 Maple St       | 789 Maple St     | 2        | 20    | 2024-04-10 18:24:08.0000000
1  | 4       | 105        | 1         | 3        | 2024-04-20  | 2024-04-25  | Delivered   | 987 Victory Lane   |                  | 2        | 60    | 2024-04-20 14:50:33.0000000
1  | 5       | 104        | 2         | 5        | 2024-05-01  | 2024-05-05  | Shipped     | 345 Oak St         | 678 Pine St      | 1        | 25    | 2024-05-01 14:02:41.0000000
1  | 6       | 101        | 3         | 5        | 2024-05-05  | 2024-05-10  | Delivered   | 543 Belmont Rd.    | 3768 Door Way    | 2        | 50    | 2024-05-12 20:36:55.0000000
1  | 7       | 102        | 3         | 5        | 2024-06-15  | 2024-06-20  | Shipped     | 111 Main St        | 222 Billing St   | 0        | 60    | 2024-06-16 23:25:15.0000000
*/


/*==============================================================
NTILE(n)

Divides rows into n approximately equal buckets.

Important:
• Buckets are distributed as evenly as possible.
• Earlier buckets may contain one extra row if uneven.

Use Cases:
• Customer segmentation (Top 25%, Top 50%)
• Quartile/Decile analysis
• Load balancing in distributed systems
==============================================================*/

SELECT 
    OrderID,
    Sales,
    NTILE(2) OVER (ORDER BY Sales DESC) AS TwoBucket,
    NTILE(3) OVER (ORDER BY Sales DESC) AS ThreeBucket
FROM Sales.Orders;

/*
OrderID | Sales | TwoBucket | ThreeBucket
8       | 90    | 1         | 1
4       | 60    | 1         | 1
10      | 60    | 1         | 1
6       | 50    | 1         | 1
7       | 30    | 1         | 2
5       | 25    | 2         | 2
9       | 20    | 2         | 2
3       | 20    | 2         | 3
2       | 15    | 2         | 3
1       | 10    | 2         | 3
*/


/*==============================================================
NTILE(n) – PRACTICAL USE CASES

NTILE(n) divides a result set into n approximately equal groups
(buckets) based on the ORDER BY clause.

Important:
• Rows are distributed as evenly as possible.
• If rows cannot be divided evenly, earlier buckets receive extra rows.
• ORDER BY determines how rows are grouped.

Common Use Cases:
1. Data segmentation (Data Analyst)
2. Load balancing / batch processing (Data Engineer)
==============================================================*/


/*==============================================================
Goal:
Divide orders into 2 groups for export processing.

Scenario:
When exporting large datasets, we may want to:
• Split data into equal batches
• Send to different systems
• Process in parallel jobs

Logic:
1. Order rows deterministically (OrderID).
2. Divide into 2 equal buckets.
==============================================================*/

SELECT 
    NTILE(2) OVER (ORDER BY OrderID) AS Bucket,
    ProductID,
    OrderStatus
FROM Sales.Orders;

/*
Bucket | ProductID | OrderStatus
1      | 101       | Delivered
1      | 102       | Shipped
1      | 101       | Delivered
1      | 105       | Shipped
1      | 104       | Delivered
2      | 104       | Delivered
2      | 102       | Delivered
2      | 101       | Shipped
2      | 101       | Shipped
2      | 102       | Shipped
*/


