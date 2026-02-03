/*========================================================
 DATABASE & TABLE PREVIEW
==========================================================

Database   : MyDatabase
Table Name : customers

----------------------------------------------------------
customer_id | first_name | country  | amount
----------------------------------------------------------
1           | Maria      | Germany  | 350
2           | John       | USA      | 900
3           | Georg      | UK       | 750
4           | Martin     | Germany  | 500
5           | Peter      | USA      | 0

========================================================*/


/* String Functions: 
	Manipulation-concat,upper,lower,trim, replace
	Calculation- len
	String ectraction- left,right,substring
*/
USE MyDatabase;


/*========================================================
 CONCAT FUNCTION
========================================================
- CONCAT() is a STRING FUNCTION
- Used to join two or more strings
- Here it joins first_name and country using '-'
========================================================*/
SELECT first_name,
       country,
       CONCAT(first_name, '-', country)
FROM customers;

-- Output:
-- Maria   | Germany | Maria-Germany
-- John    | USA     | John-USA
-- Georg   | UK      | Georg-UK
-- Martin  | Germany | Martin-Germany
-- Peter   | USA     | Peter-USA


/*========================================================
 UPPER / LOWER / TRIM / LEN FUNCTIONS
========================================================
- LEN()        : Returns number of characters in a string
- TRIM()       : Removes leading and trailing spaces
- LEN(TRIM())  : Gives actual length after removing spaces
========================================================*/
SELECT first_name,
       LEN(first_name) AS len_name,
       LEN(TRIM(first_name)) AS len_trim_name
FROM customers;

-- Output:
-- Maria   | 5 | 5
-- John    | 4 | 4
-- Georg   | 5 | 5
-- Martin  | 6 | 6
-- Peter   | 5 | 5


/*========================================================
 REPLACE FUNCTION
========================================================
- REPLACE() is a STRING FUNCTION
- Syntax: REPLACE(value, old_char, new_char)
- Replaces all occurrences of old_char with new_char
========================================================*/
SELECT '20-07-2003',
       REPLACE('20-07-2003', '-', '/') AS cleaned_number;

-- Output:
-- 20-07-2003 | 20/07/2003


/*========================================================
 LEFT & RIGHT FUNCTIONS
========================================================
- LEFT()  : Extracts characters from the start of a string
- RIGHT() : Extracts characters from the end of a string
========================================================*/
SELECT '20-07-2003' AS DOB,
       LEFT('20-07-2003', 2) AS date,
       RIGHT('20-07-2003', 4) AS _year;

-- Output:
-- 20-07-2003 | 20 | 2003


/*========================================================
 SUBSTRING FUNCTION
========================================================
- SUBSTRING() extracts part of a string
- Syntax: SUBSTRING(value, start_position, length)
- Below example extracts 5 characters starting from position 2
========================================================*/
SELECT 'Developer',
       SUBSTRING('Developer', 2, 5);

-- Output:
-- Developer | evelop
