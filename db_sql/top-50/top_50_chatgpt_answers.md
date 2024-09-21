select \* from customers order by customer_id limit 10;

select \* from orders order by order_date DESC limit 10;

select \* from products order by product_id OFFSET 1 ROWS FETCH NEXT 5 ROWS only;

select \* from products order by product_id LIMIT 5 OFFSET 1

select \* from products order by price DESC limit 5;

select \* from products order by price DESC OFFSET 2 ROWS FETCH NEXT 5 ROWS ONLY;

-- Avoid grouping on columns which are not PRIMARY KEY just to select more information about an Entity
select c.customer_id, c.customer_name, c.email, c.created_at, SUM(o.total_amount) as total_amount_spent
from customers c
INNER JOIN orders o
on c.customer_id = o.customer_id
group by c.customer_id, c.customer_name, c.email, c.created_at
ORDER by total_amount_spent DESC
limit 1;

-- Complex Query, avoid
select c.customer_id, c.customer_name, c.email, c.created_at, subquery.total_spent
from customers c
INNER JOIN (
select c.customer_id, SUM(o.total_amount) as total_spent
from customers c
INNER JOIN orders o
on c.customer_id = o.customer_id
group by c.customer_id
order by total_spent DESC
LIMIT 1
) as subquery
on c.customer_id = subquery.customer_id

-- Simple Query to retrieve more information using subquery, use ORDER BY AND LIMIT in subquery to avoid larger joins between tables
select c.customer_id, c.customer_name, c.email, c.created_at, subquery.total_spent
from customers c
INNER JOIN (
select o.customer_id, SUM(total_amount) as total_spent
from orders o
group by o.customer_id
order by total_spent DESC
LIMIT 1
) subquery
on subquery.customer_id = c.customer_id

-- Avoid using NOT IN, performs set comparison for 2 sets of elements, and behaves unexpectedly / fails on NULL values
select c.customer_id, c.customer_name, c.email, c.created_at
from customers c
where c.customer_id NOT IN (select distinct customer_id from orders)

-- Alternate Query using NOT EXISTS
select c.customer_id, c.customer_name, c.email, c.created_at
from customers c
where NOT EXISTS (
select 1
from orders o
where o.order_id = c.customer_id
)

select c.customer_id, c.customer_name, c.email, c.created_at, subquery.amount_spent
from customers c
INNER JOIN (
select o.customer_id, SUM(total_amount) as amount_spent
from orders o
group by o.customer_id
ORDER BY amount_spent DESC
LIMIT 1
) subquery
on subquery.customer_id = c.customer_id;

select c.customer_id
from customers c
where NOT EXISTS (
Select 1
from orders o
where o.customer_id = c.customer_id
)

select o.order_id, SUM(oi.quantity) as total_quantity, SUM(oi.price) as total_price
from orders o
INNER JOIN
order_items oi
on o.order_id = oi.order_id
group by o.order_id

select p.product_id
from products p
where p.price > (
select AVG(price) from products
)

select o.customer_id
from orders o
where o.order_date > CURRENT_DATE - INTERVAL '30 days'

select s.product_id, COUNT(s.supplier_id) as sum_suppliers
from supplies s
group by s.product_id
HAVING COUNT(s.supplier_id > 1
order by s.product_id

select s.product_id, COUNT(DISTINCT s.supplier_id)
from supplies s
group by s.product_id
HAVING COUNT(DISTINCT s.supplier_id) > 1
order by s.product_id

-- Instead of using COUNT(\*), use COUNT(s.product_id) because many supplies rows can contain null values for product_id
-- In such cases, supplier has not supplied any product, although there is an entry in the table for supplier_id
select s.supplier_id, COUNT(s.product_id) as total_products_supplied, SUM(s.quantity_supplied) as total_supplied_quantity
from supplies s
group by s.supplier_id

select s.supplier_id, SUM(s.quantity_supplied) as total_supplied_quantity
from supplies s
where s.product_id IS NOT NULL
group by s.supplier_id
HAVING SUM(s.quantity_supplied) > 100

select o.customer_id, EXTRACT(YEAR from order_date), EXTRACT(MONTH from order_date), SUM(o.order_id)
from orders o
group by o.customer_id, EXTRACT(YEAR from order_date), EXTRACT(MONTH from order_date)
HAVING SUM(o.order_id) > 2

select s.supplier_id, COUNT(s.product_id) as product_supplied
from supplies s
where s.product_id IS NOT NULL
AND s.supply_date > CURRENT_DATE - INTERVAL '180 days'
group by s.supplier_id
order by product_supplied DESC
LIMIT 3

select s.product_id, SUM(quantity_supplied) as total_quantity_supplied
from supplies s
where s.product_id IS NOT NULL
group by s.product_id
ORDER by total_quantity_supplied DESC
LIMIT 1

-- Super complex, it works but is not efficient and has redundant joins
select o.customer_id
from orders o
INNER JOIN (
select o.customer_id
from orders o
where EXTRACT(YEAR from order_date) = 2023
) subquery
on subquery.customer_id = o.customer_id
AND EXTRACT(YEAR from o.order_date) = 2023

-- Simplified version
select o.customer_id
from orders o
group by o.customer_id
HAVING COUNT(CASE when Extract(Year from o.order_date) = 2023 THEN 1 END) > 0
AND COUNT(CASE when extract(Year from o.order_date) != 2023 THEN 1 END) = 0

select c.customer_id
from customers c
where NOT EXISTS (
select 1 from
orders o
where o.customer_id = c.customer_id
)

select o.customer_id, COUNT(o.order_id) as total_orders_placed
from orders o
group by o.customer_id
ORDER BY total_orders_placed DESC
LIMIT 5

select o.customer_id, SUM(o.total_amount) as total_amount_spent
from orders o
group by o.customer_id
order by total_amount_spent DESC
LIMIT 5

select oi.product_id, COUNT(distinct o.customer_id)
from orders o
INNER JOIN order_items oi
on o.order_id = oi.order_id
group by oi.product_id
HAVING COUNT(distinct o.customer_id) > 5

select s.supplier_id, COUNT(DISTINCT s.product_id)
from supplies s
group by s.supplier_id
order by COUNT(DISTINCT s.product_id) DESC
LIMIT 1;

select oi.product_id, COUNT(distinct oi.order_id) as times_ordered
from order_items oi
group by oi.product_id
order by times_ordered DESC
LIMIT 1

select DISTINCT(o.customer_id)
from orders o
where o.order_id IN (
select oi.order_id
from order_items oi
INNER JOIN products p
on p.product_id = oi.product_id
where p.category = 'Electronics'
)

select oi.product_id
from orders o
INNER JOIN order_items oi
ON o.order_id = oi.order_id
where o.customer_id = 1
order by order_date DESC
LIMIT 5

-- This only gives us customers who have ordered some product of clothing category
select c.customer_id
from customers c
INNER JOIN orders o
on o.customer_id = c.customer_id
INNER JOIN order_items oi
on oi.order_id = o.order_id
INNER JOIN products p
on oi.product_id = p.product_id
where p.category = 'Clothing'

-- To get customers who have ordered all products from "clothing" category
select c.customer_id
from customers c
INNER JOIN orders o
on o.customer_id = c.customer_id
INNER JOIN order_items oi
on oi.order_id = o.order_id
INNER JOIN products p1
on p1.product_id = oi.product_id
where p1.category = 'Clothing'
group by c.customer_id
HAVING COUNT(Distinct oi.product_id) = (Select COUNT(DISTINCT product_id) from products p1 where category='Clothing')

select AVG(subquery.order_quantity) as average_items_per_order
from (
select o.order_id, SUM(o.quantity) as order_quantity
from order_items o
group by o.order_id
) subquery

-- Average order total = order total for all orders / number of orders
-- order total for a single order = order.quantity \* price = total amount spent on order

select oi.order*id, SUM(oi.quantity * oi.price) as amount*spent_on_order
from order_items oi
group by oi.order_id
HAVING SUM(oi.quantity * oi.price) >
(select AVG(total_amount_spent) as average_amount_spent_per_order
from (
select oi.order_id, SUM(oi.quantity \* price) as total_amount_spent
from order_items oi
group by oi.order_id
) as order_totals)

-- Orders with number of items greater than the average number of items per order
select o.order_id, o.total_amount
from orders o
where o.total_amount > (select AVG(o.total_amount) from orders o)

-- To list 3 top categories based on the total nubmer of products ordered,
-- we have to find the total number of products ordered for each category,
-- rank the categories in descending order based on the total number of products
-- ordered for each category, and select top 3
select DISTINCT p.category
from products p
INNER JOIN order_items oi
on p.product_id = oi.product_id
group by p.category
order by SUM(oi.quantity) DESC
LIMIT 3

select p.product_id, SUM(oi.quantity \* oi.price) as revenue_product
from products p
INNER JOIN order_items oi
on p.product_id = oi.product_id
group by p.product_id

-- This will give incorrect results, for products which have been ordered but never been
-- supplied. It matches all products that have been ordered with supplies table and in
-- this join, it will match with all the products which have been supplied but do not
-- match the product ordered, giving us incorrect results
select p.product_id
from products p
INNER JOIN order_items oi
ON oi.product_id = p.product_id
INNER JOIN supplies s
ON s.product_id != p.product_id

-- Products that have been ordered but never supplied
-- Products Joined with Orders => All products which have been ordered
-- Left outer JOin with supplies table lists all products which match supplies product_id
-- BUT also keeps records from ordered products which do not have a match with s.product_id
-- MEANING ordered products with product_id that have no matching entry in supplies table,
-- implying that these products were never supplied. For all these rows in the JOIN result
-- of LEFT OUTER JOIN, s.product_id IS NULL
select DISTINCT p.product_id, p.product_name
from products p
INNER JOIN order_items oi
on p.product_id = oi.product_id
LEFT OUTER JOIN supplies s
on s.product_id = p.product_id
where s.product_id IS NULL

-- Ordered but never supplied => product must have been ordered + product not supplied despite of being ordered
-- AND Operator ensures that only when product_id satisfies both conditions, the product_id will be selected
select DISTINCT p.product_id, p.product_name
from products p
WHERE EXISTS(
Select 1
from order_items oi
where oi.product_id = p.product_id
)
AND NOT EXISTS (
select 1
from supplies s
where s.product_id = p.product_id
)

-- Suppliers that have supplied products which were ordered more than 50 times
select DISTINCT s.supplier_id
from supplies s
INNER JOIN (
Select oi.product_id
from order_items oi
group by oi.product_id
HAVING COUNT(oi.order_id) > 50
) as products_ordered
on products_ordered.product_id = s.product_id

-- Total Number of products ordered in each month for the past year
select oi.product_id, EXTRACT(YEAR from o.order_date) as order_year, EXTRACT(MONTH from o.order_date) as order_month, SUM(oi.quantity) as quantity_ordered
from orders o
INNER JOIN order_items oi
on o.order_id = oi.order_id
where EXTRACT(YEAR from o.order_date) = EXTRACT(YEAR from CURRENT_DATE) - 1
group by oi.product_id, EXTRACT(YEAR from o.order_date), EXTRACT(MONTH from o.order_date)
order by oi.product_id, order_year, order_month

SELECT
o1.customer_id,
EXTRACT(MONTH FROM o1.order_date) AS order_month_one,
EXTRACT(MONTH FROM o2.order_date) AS order_month_two,
EXTRACT(YEAR FROM o1.order_date) AS order_year_one,
EXTRACT(YEAR FROM o2.order_date) AS order_year_two
FROM
orders o1
INNER JOIN
orders o2
ON o1.customer_id = o2.customer_id
WHERE
(
ABS(EXTRACT(MONTH FROM o1.order_date) - EXTRACT(MONTH FROM o2.order_date)) = 1
AND EXTRACT(YEAR FROM o1.order_date) = EXTRACT(YEAR FROM o2.order_date)
)
OR (
ABS(EXTRACT(MONTH FROM o1.order_date) - EXTRACT(MONTH FROM o2.order_date)) = 11
AND ABS(EXTRACT(YEAR FROM o1.order_date) - EXTRACT(YEAR FROM o2.order_date)) = 1
)
GROUP BY
o1.customer_id, order_month_one, order_month_two, order_year_one, order_year_two
ORDER BY
o1.customer_id, order_year_one, order_month_one;

-- Select top 5 customers who placed the highest number of distinct orders
select c.customer_id, COUNT(DISTINCT o.order_id) as total_orders
from customers c
INNER JOIN orders o
on o.customer_id = c.customer_id
group by c.customer_id
order by total_orders DESC
LIMIT 5

-- Select top 5 customers who placed the highest number of distinct orders
select c.customer_id, COUNT(DISTINCT o.order_id) as total_orders
from customers c
INNER JOIN orders o
on o.customer_id = c.customer_id
group by c.customer_id
order by total_orders DESC
LIMIT 5

-- products that were ordered in every month of the current year
-- Condition >= 12 is logically incorrect because even if a product was ordered more than once in a month
-- and only once in every other month, because, we are using DISTINCT, that month in which the product
-- was ordered more than once will be counted only exactly once
select oi.product_id, COUNT(DISTINCT EXTRACT(month from o.order_date)) as distinct_months_ordered
from order_items oi
INNER JOIN orders o
on o.order_id = oi.order_id
where EXTRACT(YEAR from o.order_date) = EXTRACT(YEAR from CURRENT_DATE)
group by oi.product_id
HAVING COUNT(DISTINCT EXTRACT(month from o.order_date)) = 12

-- Total Quantity of products supplied in the current year
-- This is complex and NOT NEEDED because a simple sum of
-- quantity_supplied for supplies of current year will give
-- us the total quantity supplied for all products in current year
select SUM(supplied_products_quantity.quantity_supplied)
from (
Select s.product_id, SUM(s.quantity_supplied) as quantity_supplied
from supplies s
where EXTRACT(YEAR from s.supply_date) = EXTRACT(YEAR from CURRENT_DATE)
group by s.product_id
) as supplied_products_quantity

-- Total Quantity of products supplied in current year
select SUM(quantity_supplied) as total_supplied_quantity
from supplies s
where EXTRACT(YEAR from s.supply_date) = EXTRACT(YEAR from CURRENT_DATE)

SELECT COALESCE(SUM(s.quantity_supplied), 0) AS total_quantity_supplied
FROM supplies s
WHERE EXTRACT(YEAR FROM s.supply_date) = EXTRACT(YEAR FROM CURRENT_DATE);

-- Orders that contain more than 3 unique products
select oi.order_id, COUNT(DISTINCT oi.product_id) as distinct_products_ordered
from order_items oi
group by oi.order_id
HAVING COUNT(DISTINCT oi.product_id) > 3
