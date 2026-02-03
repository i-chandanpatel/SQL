/* =========================================================
   DATABASE REFERENCE TABLES
   ---------------------------------------------------------
   The following tables represent the core entities used
   in the SalesDB database. These are provided as reference
   data to understand joins, relationships, and query outputs.
   ========================================================= */


/* =========================================================
   CUSTOMER TABLE
   ---------------------------------------------------------
   Stores customer personal and location details.

   Columns:
   - CustomerID : Unique identifier for each customer
   - FirstName  : Customer's first name
   - LastName   : Customer's last name (can be NULL)
   - Country    : Customer's country
   - Credit     : Customer credit balance (can be NULL)
   ========================================================= */

-- Customer table data
-- ---------------------------------------------------------
-- CustomerID | FirstName | LastName  | Country | Credit
-- ---------------------------------------------------------
-- 1          | Jossef    | Goldberg  | Germany | 350
-- 2          | Kevin     | Brown     | USA     | 900
-- 3          | Mary      | NULL      | USA     | 750
-- 4          | Mark      | Schwarz   | Germany | 500
-- 5          | Anna      | Adams     | USA     | NULL


/* =========================================================
   EMPLOYEE TABLE
   ---------------------------------------------------------
   Stores employee (salesperson/manager) details.

   Columns:
   - EmployeeID : Unique employee identifier
   - FirstName  : Employee first name
   - LastName   : Employee last name (can be NULL)
   - Department : Department name
   - BirthDate  : Date of birth
   - Gender     : Gender (M/F)
   - Salary     : Employee salary
   - ManagerID  : EmployeeID of the manager (self-reference)
   ========================================================= */

-- Employee table data
-- ---------------------------------------------------------
-- EmployeeID | FirstName | LastName | Department | BirthDate  | Gender | Salary | ManagerID
-- ---------------------------------------------------------
-- 1          | Frank     | Lee      | Marketing  | 1988-12-05 | M      | 55000  | NULL
-- 2          | Kevin     | Brown    | Marketing  | 1972-11-25 | M      | 65000  | 1
-- 3          | Mary      | NULL     | Sales      | 1986-01-05 | F      | 75000  | 1
-- 4          | Michael  | Ray      | Sales      | 1977-02-10 | M      | 90000  | 2


/* =========================================================
   PRODUCTS TABLE
   ---------------------------------------------------------
   Stores product catalog information.

   Columns:
   - ProductID   : Unique product identifier
   - ProductName : Name of the product
   - Category    : Product category
   - Price       : Unit price of the product
   ========================================================= */

-- Products table data
-- ---------------------------------------------------------
-- ProductID | ProductName | Category     | Price
-- ---------------------------------------------------------
-- 101       | Bottle      | Accessories  | 10
-- 102       | Tire        | Accessories  | 15
-- 103       | Socks       | Clothing     | 20
-- 104       | Caps        | Clothing     | 25
-- 105       | Gloves      | Clothing     | 30


/* =========================================================
   ORDERS TABLE
   ---------------------------------------------------------
   Stores order transactions and shipment details.

   Columns:
   - OrderID          : Unique order identifier
   - ProductID        : References Products.ProductID
   - CustomerID       : References Customer.CustomerID
   - EmployeeID       : References Employee.EmployeeID
   - OrderDate        : Date order was placed
   - DeliveryDate     : Expected / actual delivery date
   - Status           : Order status (Delivered / Shipped)
   - ShippingAddress  : Shipping address (can be NULL)
   - BillingAddress   : Billing address (can be NULL or empty)
   - StoreID          : Store or branch identifier
   - Sales            : Quantity or sales amount
   - CreatedAt        : Order creation timestamp
   ========================================================= */

-- Orders table data
-- ---------------------------------------------------------
-- OrderID | ProductID | CustomerID | EmployeeID | OrderDate  | DeliveryDate | Status    | ShippingAddress         | BillingAddress        | StoreID | Sales | CreatedAt
-- ---------------------------------------------------------
-- 1       | 101       | 2          | 3          | 2025-01-01 | 2025-01-05   | Delivered | 9833 Mt. Dias Blv.      | 1226 Shoe St.         | 1       | 10    | 2025-01-01 12:34:56
-- 2       | 102       | 3          | 3          | 2025-01-05 | 2025-01-10   | Shipped   | 250 Race Court          | NULL                  | 1       | 15    | 2025-01-05 23:22:04
-- 3       | 101       | 1          | 5          | 2025-01-10 | 2025-01-25   | Delivered | 8157 W. Book            | 8157 W. Book          | 2       | 20    | 2025-01-10 18:24:08
-- 4       | 105       | 1          | 3          | 2025-01-20 | 2025-01-25   | Shipped   | 5724 Victory Lane       |                        | 2       | 60    | 2025-01-20 05:50:33
-- 5       | 104       | 2          | 5          | 2025-02-01 | 2025-02-05   | Delivered | NULL                    | NULL                  | 1       | 25    | 2025-02-01 14:02:41
-- 6       | 104       | 3          | 5          | 2025-02-05 | 2025-02-10   | Delivered | 1792 Belmont Rd.        | NULL                  | 2       | 50    | 2025-02-06 15:34:57
-- 7       | 102       | 1          | 1          | 2025-02-15 | 2025-02-27   | Delivered | 136 Balboa Court        |                        | 2       | 30    | 2025-02-16 06:22:01
-- 8       | 101       | 4          | 3          | 2025-02-18 | 2025-02-27   | Shipped   | 2947 Vine Lane          | 4311 Clay Rd          | 3       | 90    | 2025-02-18 10:45:22
-- 9       | 101       | 2          | 3          | 2025-03-10 | 2025-03-15   | Shipped   | 3768 Door Way           |                        | 2       | 20    | 2025-03-10 12:59:04
-- 10      | 102       | 3          | 5          | 2025-03-15 | 2025-03-20   | Shipped   | NULL                    | NULL                  | 0       | 60    | 2025-03-16 23:25:15


/* =========================================================
   RELATIONSHIP SUMMARY
   ---------------------------------------------------------
   - Customers ↔ Orders  : One customer can place many orders
   - Products  ↔ Orders  : One product can appear in many orders
   - Employees ↔ Orders  : One employee can handle many orders
   - Employees ↔ Employees : Self-referencing manager hierarchy
   ========================================================= */


USE SalesDB;

/* =========================================================
   TASK
   ---------------------------------------------------------
   Retrieve a list of all orders along with the related
   customer, product, and employee (salesperson) details.

   For each order, display:
   - Order ID
   - Sales
   - Customer's First Name
   - Customer's Last Name
   - Product Name
   - Product Price
   - Salesperson's First Name
   - Salesperson's Last Name
   ========================================================= */


/* =========================================================
   QUERY EXPLANATION
   ---------------------------------------------------------
   1. Sales.Orders (o)
      - This is the base table
      - Every order must appear in the result

   2. LEFT JOIN Sales.Customers (c)
      - Joins customers to orders using CustomerID
      - LEFT JOIN ensures that orders are still shown
        even if customer details are missing
      - Missing customer data appears as NULL

   3. LEFT JOIN Sales.Products (p)
      - Joins product details to orders using ProductID
      - Ensures all orders appear even if product info
        is missing

   4. LEFT JOIN Sales.Employees (e)
      - Joins salesperson details using SalesPersonID
      - Orders without an assigned salesperson still appear
        with NULL employee values

   5. SELECT clause
      - Picks only the required columns
      - Aliases are used for clarity and readability
   ========================================================= */

SELECT
    o.OrderID,                 -- Unique identifier for the order
    o.Sales,                   -- Sales quantity/value
    c.FirstName,               -- Customer first name
    c.LastName,                -- Customer last name
    p.Product AS ProductName,  -- Product name
    p.Price,                   -- Product price
    e.FirstName AS EmpFirstName, -- Salesperson first name
    e.LastName  AS EmpLastName  -- Salesperson last name
FROM Sales.Orders AS o
LEFT JOIN Sales.Customers AS c
    ON o.CustomerID = c.CustomerID
LEFT JOIN Sales.Products AS p
    ON o.ProductID = p.ProductID
LEFT JOIN Sales.Employees AS e
    ON o.SalesPersonID = e.EmployeeID;


/* =========================================================
   OUTPUT (RESULT SET)
   ---------------------------------------------------------
   OrderID | Sales | FirstName | LastName  | ProductName | Price | EmpFirstName | EmpLastName
   ---------------------------------------------------------
   1       | 10    | Kevin     | Brown     | Bottle      | 10    | Mary         | NULL
   2       | 15    | Mary      | NULL      | Tire        | 15    | Mary         | NULL
   3       | 20    | Jossef    | Goldberg  | Bottle      | 10    | Carol        | Baker
   4       | 60    | Jossef    | Goldberg  | Gloves      | 30    | Mary         | NULL
   5       | 25    | Kevin     | Brown     | Caps        | 25    | Carol        | Baker
   6       | 50    | Mary      | NULL      | Caps        | 25    | Carol        | Baker
   7       | 30    | Jossef    | Goldberg  | Tire        | 15    | Frank        | Lee
   8       | 90    | Mark      | Schwarz   | Bottle      | 10    | Mary         | NULL
   9       | 20    | Kevin     | Brown     | Bottle      | 10    | Mary         | NULL
   10      | 60    | Mary      | NULL      | Tire        | 15    | Carol        | Baker
   ---------------------------------------------------------

   Notes:
   - NULL values indicate missing related records
     (e.g., customer without last name, salesperson without last name)
   - LEFT JOIN guarantees that all orders are included
   ========================================================= */

