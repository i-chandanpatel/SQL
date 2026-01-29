-- =========================================
-- Data Definition Language (DDL)
-- =========================================

-- Select the database where the operations will be performed
use MyDatabase;


-- =========================================
-- Create PERSONS table
-- =========================================
-- Creates a table named 'persons'
-- id          : Primary key, cannot be NULL
-- person_name : Stores the person's name, cannot be NULL
-- birth_date  : Stores date of birth, can be NULL
-- email       : Stores email address

create table persons (
    id int not null,
    person_name varchar(50) not null,
    birth_date date,
    email varchar(50),
    constraint pk_person primary key (id)
);

-- Result:
-- Table 'persons' created successfully


-- =========================================
-- Alter table: Add new column
-- =========================================
-- Adds a new column 'phone' to the persons table
-- phone stores phone numbers and cannot be NULL

alter table persons add phone varchar(15) not null;

-- Result:
-- Column 'phone' added successfully


-- =========================================
-- Alter table: Drop column
-- =========================================
-- Removes the 'email' column from the persons table

alter table persons drop column email;

-- Result:
-- Column 'email' dropped successfully


-- =========================================
-- Drop table (commented)
-- =========================================
-- Deletes the persons table permanently (structure + data)
-- drop table persons;
