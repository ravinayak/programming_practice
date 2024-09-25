-- String Functions

select UPPER('hello')

select LOWER('HELLO')

select CONCAT('HELLO' , ' ' ,'World')

select TRIM(' Hello')

select LENGTH('Hello World')

-- Date Functions

-- Current Date and Time with TimeZone
select NOW()

-- Only Current Date without Time/Timezone
select CURRENT_DATE

-- Extract month/Yeaar/Day from Date
select EXTRACT(MONTH from NOW())
select EXTRACT(YEAR from NOW())
select EXTRACT(DAY from Now())

-- Calculate difference between 2 dates
select AGE('2024-11-08', '2024-09-05')

-- Truncate date to get the part of date we want
-- DATE_TRUNC is a function used in many SQL dialects (e.g., PostgreSQL, Redshift, etc.)
-- to truncate a date or timestamp to a specified precision, such as year, month, day, or hour.
-- This is useful when you want to group or aggregate data at a particular time granularity.
-- Consider we want to aggregate all data from users access that happened in 2023 May, we can
-- Truncate date of access to month for all the access, in this way all the user access that
-- happened on different dates of May will now be truncated to May (same for other months),
-- we can extract the month part of date, and compare it with 5 (for May)
-- Step 1: date_trunc('month', user_access_date)
-- Step 2: Extract(MONTH from date_trunc('month', user_access_date)) = 5

select DATE_TRUNC('day', NOW())

-- Mathematical Functions

-- Rounds the number to integer or to the specified decimal precision
-- Rounds 123.4567 according to rules of comparison with .5 for decimal
-- 123.45678 => .45678 to 2 decimal places => .45678 > .45 => .46
select ROUND('123.45678', 2)
-- 123.44688 => .44688 > .44 => .45
select ROUND('123.44688', 2)
-- 123.45 < 123.5 => 123
select ROUND('123.45', 0)
-- 123.56 > 123.5 => 124
select ROUND('123.56')

-- ceil(number) => Smallest Integer greater than or equal to number, ceil => bring up
-- floor(number) => Largest Integer less than or equal to number, floor => bring down
-- '124' > '123.45' => 124 is the smallest integer greater than or equal to 123.45
-- Other integers 125, 126 are also greater than 123.45 but not the smallest
-- 123 is smaller than 123.45, so not considered
select CEIL('123.45')
select FLOOR('123.45')

select ABS(-5)

select MOD(11, 5)

-- AVerage Functions

Select AVG(total_amount) from orders

Select COUNT(order_id) from orders

Select SUM(total_amount) from orders

Select MAX(total_amount) from orders

Select MIN(total_amount) from orders

-- Conditional Operators

-- returns the 1st NOT null value from a list of values
Select COALESCE(null, null, 5, 6, 7)

-- returns null if 2 values are same, else 1st value
Select NULLIF(5, 5) -- null
Select NULLIF(6, 8) -- 6

-- Cast Functions
Select CAST('123' AS Integer)

-- Array Functions

-- It aggregates the values from multiple rows into an array for a specified column
-- There must be a table or table like structure with rows and columns
-- A list of integers supplied to this function will not work
-- Ex: Select Array_AGG(1,2,3) will not work
Select ARRAY_AGG(order_id) from orders
Select ARRAY_AGG(order_totals.order_amount) from (
Select order_id, SUM(quantity \* price) as order_amount
from order_items
group by order_id
) as order_totals

-- unpack elements from an array
Select Unnest(Array[1,2,3])

-- JSON Functions
-- TO_JSON: Converts the input to a JSON value without field names (when converting a row, it will use "f1", "f2", etc., as field names).
-- ROW_TO_JSON: Converts a row or record into JSON with proper field names based on column names.

Select TO_JSON(ROW('John', 'Doe', 30))

Select to_json(Array[1, 2, 3])

select to_json(42)

select to_json(order_id) from orders

-- Inner subquery selects specified columns from table, this selection of inner query results in a table structure which we alias as c
-- and we apply ROW_TO_JSON over this alias. It prepares JSON object from this table using column_names as keys and their values as values
Select ROW_TO_JSON(c) from (Select customer_id, customer_name, email from customers)as c

select ROW_TO_JSON(s) from (select supplier_id, product_id from supplies) as s

SELECT JSONB_EXTRACT_PATH_TEXT('{"name": "John"}'::jsonb, 'name');

-- SET OPERATIONS

-- UNION requires that the number of columns must be same for both tables
-- Data type for each column must be same and must in the same order for
-- both tables
-- Columns do not have to be same, as in the example below as long as they
-- satisfy the above conditions
-- product_id: integer, supplier_id: integer
select product_id from products
UNION
select supplier_id from supplies

-- product_id: integer, customer_id: integer
-- product_name: string, customer_name: string
-- product_id, product_name; customer_id, customer_name => This must be the order
-- product_id, product_name; customer_name, customer_id => Wrong Order
select product_id, product_name from products
UNION
select customer_id, customer_name from customers

-- Union removes duplicates, lists them only once
-- It is illogical most of the times to use different columns in tables when we
-- are doing a union but technically they can be used if they have the same type
-- MOST LOGICAL UNION
select customer_id from customers
UNION
select customer_id from orders

-- Lists all entries from both tables by taking a UNION of the columns from both
-- tables, will repeat duplicates
select customer_id from customers
UNION ALL
select customer_id from orders

-- customer_id common to both tables will be in the result
select customer_id from customers
INTERSECT
select customer_id from orders

-- customer_id in customers table NOT PRESENT in orders table will be in result
select customer_id from customers
EXCEPT
select customer_id from orders

-- Window Functions:
**OVER**: Iterates over the result obtained through window function, and computes
the relevant value (rank, row_number etc). Think of it as SubQuery which is executed
independent of the outer query, all results are computed and then the join is performed
with Outer Select clause on matching values of columns used in Partition By clause to
determine rank, row_number, lead etc to assign to the outer Select Clause
Window functions are powerful as they help us to write queries which can process another
set of data in columns based on a different order without using subqueries
-- SubQuery no longer needed
-- Complex Joins of Outer Query with SubQuery is avoided

**ROW_NUMBER**
-- We can multiple columns in the PARTITION BY clause in SQL window functions.
-- When you specify multiple columns in the PARTITION BY clause, the result set is
-- divided into partitions based on the combination of values in those columns.
-- order_id, customer_id fields will be selected from orders table in no specific order
-- The entire set of rows in table orders will be partitioned into different partitions
-- based on customer_id, and in each partition the rows will be ordered by total_amount
-- in descending order, such that customer_id, order_id which has highest total_amount
-- will be listed 1st in the partition. For this partition, once rows have been ordered
-- correctly, row number will be assigned sequentially starting from 1 to each row within
-- partition.
-- For Next partition (next customer_id), again an order will be placed amongst rows
-- by total_amount and row number will be assigned sequentially starting from 1
-- Row Number resets to 1 for each partition
SELECT order_id, customer_id,
ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY total_amount DESC) AS row_num
FROM orders;

-- Rank function assigns a rank based on the order given by OVER clause, unlike ROW_NUMBER
-- it does not assign a different sequential number to rows which have the same value (ties)
-- instead it assigns the same rank to ties, and for the ranks which are allocated as same
-- those number of ranks are skipped
-- If 3 columns have rank 2, the next rank will be 5 (because after rank 2, rank 3, rank 4
-- have been consumed as rank 2 for ties, so the next available rank is rank 5)
Select order_id, customer_id,
RANK() OVER (PARTITION BY customer_id ORDER BY total_amount DESC) as rank
from orders

-- LAG(column_name, offset, default_value) OVER (PARTITION BY column_name ORDER BY column_name)
• Purpose: Accesses data from the previous row in the result set, based on the ordering defined in the OVER clause.
• Use Case: When you want to compare the value of the current row with the previous row in a result set.
-- Options
• column_name: The column whose value you want to access in the previous row.
• offset: The number of rows back to look (default is 1).
• default_value: The value returned if there is no row at the given offset (optional).

-- LEAD(column_name, offset, default_value) OVER (PARTITION BY column_name ORDER BY column_name)
• Purpose: Accesses data from the next row in the result set, based on the ordering defined in the OVER clause.
• Use Case: When you want to compare the value of the current row with the next row in a result set.
-- Options
• column_name: The column whose value you want to access in the next row.
• offset: The number of rows forward to look (default is 1).
• default_value: The value returned if there is no row at the given offset (optional).

select order*id, product_id, (quantity*price) as total*order_amount,
row_number() OVER (PARTITION by order_id, product_id ORDER BY(quantity * price) DESC) as row*number,
rank() over (PARTITION by order_id, product_id ORDER BY(quantity * price) DESC) as rank,
lead(order*id, 1) OVER(PARTITION by order_id, product_id ORDER BY(quantity * price) DESC) as next_order_id,
lag(order_id, 1) OVER(PARTITION by order_id, product_id ORDER BY(quantity \* price) DESC) as previous_order_id
from order_items

-- Order of results returned by this query seems to be grouped by order_id, product_id and sorted by total_amount
-- but this is coincidence, because no Explicit ORDER BY Clause is specified for Select Clause, no guarantees
-- exist for the ordering of results

-- lead(order_id, 1) OVER(PARTITION by order_id, product_id ORDER BY(quantity \* price) DESC) as next_order_id
-- This will partition the table rows by order_id, product_id combination and will order the results for every
-- unique combination of order_id, product_id based on (quantity \* price) value in descending order. If there
-- are > 1 rows for a particular combination of order_id and product_id, next order_id will fetch the value of
-- order_id from the next row, or from the previous row depending upon lead/lag used
-- If there is only 1 row, null will be returned
-- We can choose to skip rows as we like by using a value other than 1 in the lead/lag function
