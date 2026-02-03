/* =========================================================
   SAMPLE DATA (for reference)
   =========================================================

   customers
   ---------------------------------------------------------
   id | name   | country | credit
   ---------------------------------------------------------
   1  | Maria  | Germany | 350
   2  | John   | USA     | 900
   3  | Georg  | UK      | 750
   4  | Martin | Germany | 500
   5  | Peter  | USA     | 0

   orders
   ---------------------------------------------------------
   order_id | customer_id | order_date | quantity
   ---------------------------------------------------------
   1001     | 1           | 2021-01-11 | 35
   1002     | 2           | 2021-04-05 | 15
   1003     | 3           | 2021-06-18 | 20
   1004     | 6           | 2021-08-31 | 10
*/


/* =========================================================
   LEFT ANTI JOIN
   Get all customers who haven't placed any order
   ---------------------------------------------------------
   Logic:
   - LEFT JOIN keeps all rows from customers
   - Matching rows from orders are joined
   - Customers with NO matching order will have NULLs
     in orders columns
   - WHERE o.customer_id IS NULL filters only those customers
     without orders
   ========================================================= */

SELECT *
FROM customers AS c
LEFT JOIN orders AS o
  ON c.id = o.customer_id
WHERE o.customer_id IS NULL;

/*
   Output:
   ---------------------------------------------------------
   id | name   | country | credit | order_id | customer_id | order_date | quantity
   ---------------------------------------------------------
   4  | Martin | Germany | 500    | NULL     | NULL        | NULL       | NULL
   5  | Peter  | USA     | 0      | NULL     | NULL        | NULL       | NULL
*/


/* =========================================================
   RIGHT ANTI JOIN
   Get all orders without matching customers
   ---------------------------------------------------------
   Logic:
   - RIGHT JOIN keeps all rows from orders
   - Matching rows from customers are joined
   - Orders with NO matching customer will have NULLs
     in customer columns
   - WHERE c.id IS NULL filters only unmatched orders
   ========================================================= */

SELECT *
FROM customers AS c
RIGHT JOIN orders AS o
  ON c.id = o.customer_id
WHERE c.id IS NULL;

/*
   Output:
   ---------------------------------------------------------
   id | name | country | credit | order_id | customer_id | order_date | quantity
   ---------------------------------------------------------
   NULL | NULL | NULL   | NULL   | 1004     | 6           | 2021-08-31 | 10
*/


/* =========================================================
   RIGHT ANTI JOIN (USING LEFT JOIN INSTEAD)
   ---------------------------------------------------------
   Logic:
   - Same result as above
   - LEFT JOIN orders to customers
   - Filter where customer is NULL
   ========================================================= */

SELECT *
FROM orders AS o
LEFT JOIN customers AS c
  ON c.id = o.customer_id
WHERE c.id IS NULL;

/*
   Output:
   ---------------------------------------------------------
   order_id | customer_id | order_date | quantity | id | name | country | credit
   ---------------------------------------------------------
   1004     | 6           | 2021-08-31 | 10       | NULL | NULL | NULL | NULL
*/


/* =========================================================
   FULL ANTI JOIN
   Get all non-matching rows from BOTH tables
   ---------------------------------------------------------
   Logic:
   - FULL JOIN returns all rows from both tables
   - Matching rows are joined
   - Non-matching rows have NULLs on the other side
   - WHERE filters:
       * customers without orders
       * orders without customers
   ========================================================= */

SELECT *
FROM customers AS c
FULL JOIN orders AS o
  ON c.id = o.customer_id
WHERE c.id IS NULL
   OR o.customer_id IS NULL;

/*
   Output:
   ---------------------------------------------------------
   id | name   | country | credit | order_id | customer_id | order_date | quantity
   ---------------------------------------------------------
   4  | Martin | Germany | 500    | NULL     | NULL        | NULL       | NULL
   5  | Peter  | USA     | 0      | NULL     | NULL        | NULL       | NULL
   NULL | NULL | NULL   | NULL   | 1004     | 6           | 2021-08-31 | 10
*/


/* =========================================================
   LEFT JOIN WITH FILTER (INNER JOIN BEHAVIOR)
   Get all customers along with their orders,
   but only customers who HAVE placed an order
   ---------------------------------------------------------
   Logic:
   - LEFT JOIN keeps all customers
   - WHERE o.customer_id IS NOT NULL removes customers
     without orders
   - Result is effectively the same as an INNER JOIN
   ========================================================= */

SELECT *
FROM customers AS c
LEFT JOIN orders AS o
  ON c.id = o.customer_id
WHERE o.customer_id IS NOT NULL;

/*
   Output:
   ---------------------------------------------------------
   id | name  | country | credit | order_id | customer_id | order_date | quantity
   ---------------------------------------------------------
   1  | Maria | Germany | 350    | 1001     | 1           | 2021-01-11 | 35
   2  | John  | USA     | 900    | 1002     | 2           | 2021-04-05 | 15
   3  | Georg | UK      | 750    | 1003     | 3           | 2021-06-18 | 20
*/


/* =========================================================
   CROSS JOIN
   Combines every row from customers with every row from orders
   ---------------------------------------------------------
   Logic:
   - No join condition
   - Produces a Cartesian product
   - Total rows = customers * orders = 5 * 4 = 20 rows
   ========================================================= */

SELECT *
FROM customers
CROSS JOIN orders;

/*
   Output (snippet):
   ---------------------------------------------------------
   id | name  | country | credit | order_id | customer_id | order_date | quantity
   ---------------------------------------------------------
   1  | Maria | Germany | 350    | 1001     | 1           | 2021-01-11 | 35
   1  | Maria | Germany | 350    | 1002     | 2           | 2021-04-05 | 15
   1  | Maria | Germany | 350    | 1003     | 3           | 2021-06-18 | 20
   ...
   5  | Peter | USA     | 0      | 1004     | 6           | 2021-08-31 | 10
*/
