/*
==========================================================
NUMBER & DATE/TIME FUNCTIONS – Sales.Orders
==========================================================

Table Preview:

OrderID | OrderDate  | ShipDate   | CreationTime
----------------------------------------------------------
1       | 2025-01-01 | 2025-01-05 | 2025-01-01 12:34:56.0000000
2       | 2025-01-05 | 2025-01-10 | 2025-01-05 23:22:04.0000000
3       | 2025-01-10 | 2025-01-25 | 2025-01-10 18:24:08.0000000
4       | 2025-01-20 | 2025-01-25 | 2025-01-20 05:50:33.0000000
5       | 2025-02-01 | 2025-02-05 | 2025-02-01 14:02:41.0000000
6       | 2025-02-05 | 2025-02-10 | 2025-02-06 15:34:57.0000000
7       | 2025-02-15 | 2025-02-27 | 2025-02-16 06:22:01.0000000
8       | 2025-02-18 | 2025-02-27 | 2025-02-18 10:45:22.0000000
9       | 2025-03-10 | 2025-03-15 | 2025-03-10 12:59:04.0000000
10      | 2025-03-15 | 2025-03-20 | 2025-03-16 23:25:15.0000000
*/

/*========================================================
  CURRENT DATE & TIME
========================================================
GETDATE() – returns the current system date and time
========================================================*/
SELECT GETDATE() AS Today;

-- Example Output:
-- Today
-- 2026-02-02 14:45:12.1234567


/*========================================================
  EXTRACT PARTS OF DATETIME
========================================================
- YEAR(), MONTH(), DAY() → numeric parts of date
- DATEPART() → numeric, flexible (year/month/day/hour/quarter/week)
- DATENAME() → string version (returns month/day names)
========================================================*/
SELECT OrderID, CreationTime,
       YEAR(CreationTime) AS Year,
       MONTH(CreationTime) AS Month,
       DAY(CreationTime) AS Day
FROM Sales.Orders;

-- Example Output for OrderID = 1:
-- OrderID | CreationTime             | Year | Month | Day
-- 1       | 2025-01-01 12:34:56.000 | 2025 | 1     | 1

SELECT OrderID, CreationTime,
       DATEPART(year, CreationTime) AS Year
FROM Sales.Orders;

-- Output similar to YEAR()


/*========================================================
  DATE_TRUNC FUNCTION
========================================================
- Truncates datetime to the specified unit
- Syntax: DATETRUNC(unit, timestamp)
- Units: second, minute, hour, day, week, month, quarter, year, decade, century, millennium
========================================================*/
SELECT CreationTime,
       DATETRUNC(minute, CreationTime) AS truncated_minute
FROM Sales.Orders
WHERE OrderID = 1;

-- Output:
-- CreationTime             | truncated_minute
-- 2025-01-01 12:34:56.000 | 2025-01-01 12:34:00

-- Truncate to hour
SELECT CreationTime,
       DATETRUNC(hour, CreationTime) AS truncated_hour
FROM Sales.Orders
WHERE OrderID = 1;

-- Output:
-- 2025-01-01 12:34:56.000 | 2025-01-01 12:00:00

-- Truncate to day
SELECT CreationTime,
       DATETRUNC(day, CreationTime) AS truncated_day
FROM Sales.Orders
WHERE OrderID = 1;

-- Output:
-- 2025-01-01 12:34:56.000 | 2025-01-01 00:00:00

-- Truncate to month
SELECT CreationTime,
       DATETRUNC(month, CreationTime) AS truncated_month
FROM Sales.Orders
WHERE OrderID = 1;

-- Output:
-- 2025-01-01 12:34:56.000 | 2025-01-01 00:00:00

-- Truncate to year
SELECT CreationTime,
       DATETRUNC(year, CreationTime) AS truncated_year
FROM Sales.Orders
WHERE OrderID = 1;

-- Output:
-- 2025-01-01 12:34:56.000 | 2025-01-01 00:00:00


/*========================================================
  SUMMARY OF DATE_TRUNC UNITS
========================================================
| Unit        | Meaning                                         |
|-------------|------------------------------------------------|
| second      | Keep year-month-day hour:minute:second        |
| minute      | Keep year-month-day hour:minute               |
| hour        | Keep year-month-day hour                       |
| day         | Keep year-month-day                            |
| week        | Truncate to start of the week (Monday)        |
| month       | First day of month                             |
| quarter     | First day of quarter                           |
| year        | First day of year                              |
| decade      | First year of decade                           |
| century     | First year of century                          |
| millennium  | First year of millennium                       |
========================================================*/


-- eomonth – returns last day of the month
SELECT
    '2026-02-06'       AS StartDate,
    EOMONTH('2026-02-01') AS EndDateOfMonth;


USE SalesDB;


-- Orders count by year
SELECT
    YEAR(OrderDate) AS OrderYear,
    COUNT(*)        AS NrOfOrders
FROM Sales.Orders
GROUP BY YEAR(OrderDate);


-- Orders count by month name
SELECT
    DATENAME(MONTH, OrderDate) AS MonthName,
    COUNT(*)                   AS NrOfOrders
FROM Sales.Orders
GROUP BY DATENAME(MONTH, OrderDate);

/*
February   4
January    4
March      2
*/


-- Date formatting examples
SELECT
    OrderID AS ID,
    CreationTime,

    FORMAT(CreationTime, 'dd-MM-yyyy') AS EuropianFormate,
    FORMAT(CreationTime, 'MM-dd-yyyy') AS USAFormate,
    FORMAT(CreationTime, 'yyyy-MM-dd') AS InternationaFormate,

    FORMAT(CreationTime, 'dd')    AS dd,
    FORMAT(CreationTime, 'ddd')   AS ddd,
    FORMAT(CreationTime, 'dddd')  AS dddd,
    FORMAT(CreationTime, 'MM')    AS MM,
    FORMAT(CreationTime, 'MMM')   AS MMM,
    FORMAT(CreationTime, 'MMMM')  AS MMMM
FROM Sales.Orders;


/*
ID  CreationTime                 Europian    USA         ISO         dd  ddd dddd        MM  MMM MMMM
1   2025-01-01 12:34:56.0000000  01-01-2025  01-01-2025  2025-01-01  01  Wed Wednesday   01  Jan January
2   2025-01-05 23:22:04.0000000  05-01-2025  01-05-2025  2025-01-05  05  Sun Sunday      01  Jan January
3   2025-01-10 18:24:08.0000000  10-01-2025  01-10-2025  2025-01-10  10  Fri Friday      01  Jan January
4   2025-01-20 05:50:33.0000000  20-01-2025  01-20-2025  2025-01-20  20  Mon Monday      01  Jan January
5   2025-02-01 14:02:41.0000000  01-02-2025  02-01-2025  2025-02-01  01  Sat Saturday    02  Feb February
6   2025-02-06 15:34:57.0000000  06-02-2025  02-06-2025  2025-02-06  06  Thu Thursday    02  Feb February
7   2025-02-16 06:22:01.0000000  16-02-2025  02-16-2025  2025-02-16  16  Sun Sunday      02  Feb February
8   2025-02-18 10:45:22.0000000  18-02-2025  02-18-2025  2025-02-18  18  Tue Tuesday     02  Feb February
9   2025-03-10 12:59:04.0000000  10-03-2025  03-10-2025  2025-03-10  10  Mon Monday      03  Mar March
10  2025-03-16 23:25:15.0000000  16-03-2025  03-16-2025  2025-03-16  16  Sun Sunday      03  Mar March
*/


-- Custom date display
-- Format: Day Wed Jan Q1 2025 12:42:43 PM
SELECT
    OrderID AS ID,
    CreationTime,
    'Day ' + FORMAT(CreationTime, 'ddd MMM') +
    ' Q' + DATENAME(QUARTER, CreationTime) +
    ' '  + FORMAT(CreationTime, 'yyyy hh:mm:ss tt')
    AS CustomFormat
FROM Sales.Orders;


/*
ID  CreationTime                   CustomFormat
1   2025-01-01 12:34:56.0000000    Day Wed Jan Q1 2025 12:34:56 PM
2   2025-01-05 23:22:04.0000000    Day Sun Jan Q1 2025 11:22:04 PM
3   2025-01-10 18:24:08.0000000    Day Fri Jan Q1 2025 06:24:08 PM
4   2025-01-20 05:50:33.0000000    Day Mon Jan Q1 2025 05:50:33 AM
5   2025-02-01 14:02:41.0000000    Day Sat Feb Q1 2025 02:02:41 PM
6   2025-02-06 15:34:57.0000000    Day Thu Feb Q1 2025 03:34:57 PM
7   2025-02-16 06:22:01.0000000    Day Sun Feb Q1 2025 06:22:01 AM
8   2025-02-18 10:45:22.0000000    Day Tue Feb Q1 2025 10:45:22 AM
9   2025-03-10 12:59:04.0000000    Day Mon Mar Q1 2025 12:59:04 PM
10  2025-03-16 23:25:15.0000000    Day Sun Mar Q1 2025 11:25:15 PM
*/


/*
FORMAT reference
----------------------------------------------------
D     Full day name
d     Day of the month
dd    Day of the month (two-digit)
ddd   Abbreviated day name
dddd  Full day name
M     Month number
MM    Month number (two-digit)
MMM   Abbreviated month name
MMMM  Full month name
yy    Year (two-digit)
yyyy  Year (four-digit)
hh    Hour (12-hour format)
HH    Hour (24-hour format)
m     Minutes
mm    Minutes (two-digit)
s     Seconds
ss    Seconds (two-digit)
f     Fractional seconds (1 digit)
ff    Fractional seconds (2 digits)
fff   Fractional seconds (3 digits)
tt    AM/PM designator
*/


-- CONVERT examples
SELECT
    CONVERT(INT,  '123')        AS [String to Int],
    CONVERT(DATE, '2025-08-21') AS [String to Date];


SELECT
    CreationTime,
    CONVERT(VARCHAR, CreationTime, 32) AS [USA std],
    CONVERT(VARCHAR, CreationTime, 34) AS [Eu std]
FROM Sales.Orders;


-- CAST examples
SELECT
    CAST('123' AS INT)           AS [String to Int],
    CAST('2026-01-20' AS DATE)   AS [String to Date],
    CAST('2026-01-20' AS DATETIME2) AS [String to DateTime];

/*
cast    – any type to any type, no formatting
convert – any type to any type, formats only date & time
format  – any type to string only, formats date/time and numbers
*/

--DATEADD(): Adds or subs a specific time interval to/from a date
SELECT TOP(5) OrderID, OrderDate,
DATEADD(MONTH,3, OrderDate) AS ThreeMonthsLater,
DATEADD(YEAR,2, OrderDate) AS TwoYearsLater
FROM Sales.Orders

-- OrderID | OrderDate   | ThreeMonthsLater | TwoYearsLater
-- -------------------------------------------------------
-- 1       | 2025-01-01  | 2025-04-01       | 2027-01-01
-- 2       | 2025-01-05  | 2025-04-05       | 2027-01-05
-- 3       | 2025-01-10  | 2025-04-10       | 2027-01-10
-- 4       | 2025-01-20  | 2025-04-20       | 2027-01-20
-- 5       | 2025-02-01  | 2025-05-01       | 2027-02-01
--Can do same for DAY and if have to go back than -ve value will be written

--DATEDIFF(part,start_date,end_date):   part can be year,month,day
SELECT EmployeeID, BirthDate, DATEDIFF(YEAR,BirthDate,GETDATE()) Age FROM Sales.Employees

-- EmployeeID | BirthDate   | Age
-- --------------------------------
-- 1          | 1988-12-05  | 38
-- 2          | 1972-11-25  | 54
-- 3          | 1986-01-05  | 40
-- 4          | 1977-02-10  | 49
-- 5          | 1982-02-11  | 44

--LAG se padhna h
--LAG(): Use to access value from the previous row
SELECT
    OrderID,
    OrderDate,
    LAG(OrderDate) OVER (ORDER BY OrderDate) AS PreviousOrderDate
FROM Sales.Orders;


