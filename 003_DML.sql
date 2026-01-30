-- =========================================
-- Data Manipulation Language (DML)
-- =========================================

-- Initial customers table
select * from customers;

-- Output:
-- id | first_name | country | score
-- 1  | Maria     | Germany | 350
-- 2  | John      | USA     | 900
-- 3  | Georg     | UK      | 750
-- 4  | Martin    | Germany | 500
-- 5  | Peter     | USA     | 0


-- =========================================
-- Insert Operations
-- =========================================

-- Insert Anna and Sam
insert into customers (id, first_name, country, score) values
    (6, 'Anna', 'USA', NULL),
    (7, 'Sam', NULL, 100);

select * from customers;

-- Output:
-- 1  | Maria | Germany | 350
-- 2  | John  | USA     | 900
-- 3  | Georg | UK      | 750
-- 4  | Martin| Germany | 500
-- 5  | Peter | USA     | 0
-- 6  | Anna  | USA     | NULL
-- 7  | Sam   | NULL    | 100


-- Insert Rohit
insert into customers (first_name, id, country, score) values
    ('Rohit', 8, 'India', 250);

select * from customers;

-- Output:
-- 1  | Maria | Germany | 350
-- 2  | John  | USA     | 900
-- 3  | Georg | UK      | 750
-- 4  | Martin| Germany | 500
-- 5  | Peter | USA     | 0
-- 6  | Anna  | USA     | NULL
-- 7  | Sam   | NULL    | 100
-- 8  | Rohit | India   | 250


-- Insert Andreas
insert into customers values
    (9, 'Andreas', 'Germany', NULL);

select * from customers;

-- Output:
-- 1  | Maria   | Germany | 350
-- 2  | John    | USA     | 900
-- 3  | Georg   | UK      | 750
-- 4  | Martin  | Germany | 500
-- 5  | Peter   | USA     | 0
-- 6  | Anna    | USA     | NULL
-- 7  | Sam     | NULL    | 100
-- 8  | Rohit   | India   | 250
-- 9  | Andreas | Germany | NULL


-- =========================================
-- Insert into PERSONS table
-- =========================================

insert into persons (id, person_name, birth_date, phone)
select id, first_name, NULL, 'Unknown'
from customers;

select * from persons;

-- Output:
-- id | person_name | birth_date | phone
-- 1  | Maria       | NULL       | Unknown
-- 2  | John        | NULL       | Unknown
-- 3  | Georg       | NULL       | Unknown
-- 4  | Martin      | NULL       | Unknown
-- 5  | Peter       | NULL       | Unknown
-- 6  | Anna        | NULL       | Unknown
-- 7  | Sam         | NULL       | Unknown
-- 8  | Rohit       | NULL       | Unknown
-- 9  | Andreas     | NULL       | Unknown


-- =========================================
-- Update Operations
-- =========================================

-- Update Anna's score
update customers
set score = 0
where id = 6;

select * from customers;

-- Output:
-- 6 | Anna | USA | 0


-- Update rows where score is NULL
update customers
set score = 0
where score is null;

select * from customers;

-- Output:
-- 1 | Maria   | Germany | 350
-- 2 | John    | USA     | 900
-- 3 | Georg   | UK      | 750
-- 4 | Martin  | Germany | 500
-- 5 | Peter   | USA     | 0
-- 6 | Anna    | USA     | 0
-- 7 | Sam     | NULL    | 100
-- 8 | Rohit   | India   | 250
-- 9 | Andreas | Germany | 0


-- =========================================
-- Delete & Truncate examples (NOT executed)
-- =========================================

-- delete from customers where id = 9;
-- truncate table persons;

-- =========================================
-- DELETE vs TRUNCATE (Side-by-Side Comparison)
-- =========================================

-- Feature                     | DELETE                        | TRUNCATE
-- ----------------------------|-------------------------------|-----------------------------
-- Rows deleted                 | Specific rows or all rows     | All rows only
-- WHERE clause                 | ✅ Yes                        | ❌ No
-- Triggers fired               | ✅ Yes                        | ❌ No
-- Rollback                     | ✅ Yes (inside transaction)   | ✅ Depends on DB
-- Auto-increment reset          | ❌ No                         | ✅ Yes, resets counter
-- Speed                        | Slower (row-by-row logging)  | Faster (minimal logging)
-- Use case                     | Fine-grained deletion         | Quickly empty a table


-- =========================================
-- FINAL STATE OF CUSTOMERS TABLE
-- =========================================

-- id | first_name | country  | score
-- 1  | Maria     | Germany  | 350
-- 2  | John      | USA      | 900
-- 3  | Georg     | UK       | 750
-- 4  | Martin    | Germany | 500
-- 5  | Peter     | USA     | 0
-- 6  | Anna      | USA     | 0
-- 7  | Sam       | NULL    | 100
-- 8  | Rohit     | India   | 250
-- 9  | Andreas  | Germany | NULL