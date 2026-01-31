-- =========================================
-- Using MyDatabase
-- =========================================
USE MyDatabase;

-- View all customers
SELECT * FROM customers;

-- Output:
-- id | first_name | country | score
-- 1  | Maria      | Germany | 350
-- 2  | John       | USA     | 900
-- 3  | Georg      | UK      | 750
-- 4  | Martin     | Germany | 500
-- 5  | Peter      | USA     | 0

-- =========================================
-- 1. Simple WHERE clause
-- =========================================

-- Select customers where country = 'Germany'
SELECT * FROM customers WHERE country = 'Germany';

-- Output:
-- id | first_name | country | score
-- 1  | Maria      | Germany | 350
-- 4  | Martin     | Germany | 500

-- =========================================
-- 2. Not equal operators: <> and !=
-- =========================================

-- Select customers where country is NOT Germany
SELECT * FROM customers WHERE country <> 'Germany';
SELECT * FROM customers WHERE country != 'Germany';

-- Output for both:
-- id | first_name | country | score
-- 2  | John       | USA     | 900
-- 3  | Georg      | UK      | 750
-- 5  | Peter      | USA     | 0

-- ✅ Use case:
-- Use <> or != when you want rows that do NOT match a certain value.

-- =========================================
-- 3. Logical operators: AND, OR, NOT
-- =========================================

-- AND: selects rows that satisfy BOTH conditions
SELECT * FROM customers 
WHERE score > 500 AND country = 'USA';

-- Output:
-- id | first_name | country | score
-- 2  | John       | USA     | 900

-- OR: selects rows that satisfy ANY condition
SELECT * FROM customers 
WHERE country = 'Germany' OR country = 'USA';

-- Output:
-- id | first_name | country | score
-- 1  | Maria      | Germany | 350
-- 2  | John       | USA     | 900
-- 4  | Martin     | Germany | 500
-- 5  | Peter      | USA     | 0

-- NOT: negates a condition
SELECT * FROM customers 
WHERE NOT country = 'USA';

-- Output:
-- id | first_name | country | score
-- 1  | Maria      | Germany | 350
-- 3  | Georg      | UK      | 750
-- 4  | Martin     | Germany | 500

-- =========================================
-- 4. BETWEEN operator (range check)
-- =========================================

-- Select customers with score >100 and <=500
SELECT * FROM customers 
WHERE score BETWEEN 101 AND 500;

-- Output:
-- id | first_name | country | score
-- 1  | Maria      | Germany | 350
-- 4  | Martin     | Germany | 500

-- ✅ Use case:
-- BETWEEN is shorthand for "x >= lower AND x <= upper"

-- =========================================
-- 5. Membership operators: IN, NOT IN
-- =========================================

-- OR equivalent using IN
SELECT * FROM customers 
WHERE country IN ('Germany', 'USA');

-- Output:
-- id | first_name | country | score
-- 1  | Maria      | Germany | 350
-- 2  | John       | USA     | 900
-- 4  | Martin     | Germany | 500
-- 5  | Peter      | USA     | 0

-- NOT IN example
SELECT * FROM customers 
WHERE country NOT IN ('Germany', 'USA');

-- Output:
-- id | first_name | country | score
-- 3  | Georg      | UK      | 750

-- ✅ Use case:
-- IN is useful to compare a column against a list of values
-- NOT IN selects rows NOT in the list

-- =========================================
-- 6. LIKE operator (pattern matching)
-- =========================================

-- % : matches zero or more characters
-- _ : matches exactly one character

-- Example 1: Names starting with 'M'
SELECT * FROM customers 
WHERE first_name LIKE 'M%';

-- Output:
-- id | first_name | country | score
-- 4  | Martin     | Germany | 500
-- ✅ Use case: search names starting with 'M'

-- Example 2: Names ending with 'a'
SELECT * FROM customers 
WHERE first_name LIKE '%a';

-- Output:
-- id | first_name | country | score
-- 1  | Maria      | Germany | 350

-- Example 3: Names with second letter 'a' (underscore _)
SELECT * FROM customers 
WHERE first_name LIKE '_a%';

-- Output:
-- id | first_name | country | score
-- 1  | Maria      | Germany | 350
-- 4  | Martin     | Germany | 500
-- ✅ Use case: search for patterns in strings (flexible searches)
