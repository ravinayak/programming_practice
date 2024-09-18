select dept.department_id, SUM(em.salary)
from departments dept
INNER JOIN employees em
on em.department_id = dept.department_id
group by dept.department_id

select em.name, em.department_id, em.salary
from employees em
INNER JOIN (
select em.department_id, AVG(em.salary) as avg_salary
from employees em
group by em.department_id
) as em_avg
on em.department_id = em_avg.department_id
where em.salary > em_avg.avg_salary

select dept.department_id, count(employee_id)
from employees em
INNER JOIN departments dept
on dept.department_id = em.department_id
group by dept.department_id
HAVING count(employee_id) > 1

select customers.customer_id, SUM(orderdetails.quantity \* products_price.price)
from customers
INNER JOIN orders
on customers.customer_id = orders.customer_id
INNER JOIN orderdetails
on orderdetails.order_id = orders.order_id
INNER JOIN products
on products.product_id = orderdetails.product_id
INNER JOIN products_price
on products.product_id = products_price.product_id
group by customers.customer_id

select customers.customer_id, count(order_id)
from customers
INNER JOIN orders
on customers.customer_id = orders.customer_id
group by customers.customer_id
having count(order_id) > 1

select customers.customer_id, sum(quantity)
from customers
INNER JOIN orders
on customers.customer_id = orders.customer_id
INNER JOIN orderdetails
on orderdetails.order_id = orders.order_id
group by customers.customer_id

select categories.category_name, count(DISTINCT mf.manufacturer_id)
from categories
INNER JOIN products
on categories.category_id = products.category_id
INNER JOIN manufacturers mf
on mf.manufacturer_id = products.manufacturer_id
group by categories.category_name
having count(DISTINCT mf.manufacturer_id) > 1

select mf.manufacturer_id, count(pr.product_id)
from manufacturers mf
INNER JOIN products pr
on mf.manufacturer_id = pr.manufacturer_id
group by mf.manufacturer_id

select products.product_id, products.category_id, categories.category_name
from products
inner join categories
on products.category_id = categories.category_id
where categories.category_name = 'Electronics'

select st.student_id, st.name, count(distinct c.course_id)
from students st
INNER JOIN enrollments e
on e.student_id = st.student_id
INNER JOIN courses c
on c.course_id = e.course_id
group by st.student_id
HAVING count(distinct c.course_id) >= 2

select courses.course_id
from courses
where courses.course_id NOT IN (select course_id from enrollments)

select students.student_id
from students
where students.student_id NOT IN (select student_id from enrollments)

# Retrieve list of movies with their respective directors, table schema:

actors => actor_id, actor_name
movieactors => movie_actor_id, movie_id, actor_id
moviedirectors => movie_director_id, movie_id, director_id
directors => director_id, director_name

Below both queries will retrieve the results, one is shorter and other longer

select md.movie_id, md.director_id, d.director_name
from movieactors ma
INNER JOIN moviedirectors md
on md.movie_id = ma.movie_id
INNER JOIN directors d
on d.director_id = md.director_id

select md.movie_id, md.director_id, d.director_name
from moviedirectors md
INNER JOIN directors d
on md.director_id = d.director_id

# Retrieve all actors, with their movies and their respective directors

select actors.actor_id, actors.actor_name, ma.movie_id, d.director_id, d.director_name
from actors
INNER JOIN movieactors ma
on actors.actor_id = ma.actor_id
INNER JOIN moviedirectors md
on ma.movie_id = md.movie_id
INNER JOIN directors d
on d.director_id = md.director_id

# Find actors who have acted in more than one movie

select actors.actor_id, actors.actor_name, COUNT(ma.movie_id)
from actors a
INNER JOIN movieactors ma
on a.actor_id = ma.actor_id
group by actors.actor_id, actors.actor_name
HAVING COUNT(ma.movie_id) > 1

# To find all actors who have acted in more than one movie

Here we do not have to perform any joins necessarily, because
movieactors table contains all the mapping betwee actor_id and movie_id,
We can group this table by actor_id, and aggregate movie_id with a
Having clause to find the result

select ma.actor_id, COUNT(ma.movie_id)
from movieactors ma
group by ma.actor_id
HAVING COUNT(ma.movie_id) > 1

# Identify movies that feature a specific actor and director combination

select a.actor_id, a.actor_name, md.movie_id, d.director_id, d.director_name
from actors a
INNER JOIN movieactors ma
on ma.actor_id = a.actor_id
INNER JOIN moviedirectors md
on md.movie_id = ma.movie_id
INNER JOIN directors d
on d.director_id = md.director_id
where a.actor_id = 1
AND d.director_id = 1

suppliers => supplier_id, supplier_name, contact_email
orders => order_id, customer_id, order_date
supplierorders => supplier_order_id, supplier_id, order_id

# List all suppliers who have supplied at least one order

1. Simple Query:

Select
s.supplier_id,
s.supplier_name,
s.contact_email,
COUNT(so.order_id)
From
suppliers s
INNER JOIN
supplierorders so
ON s.supplier_id = so.supplier_id
GROUP BY s.supplier_id, s.supplier_name, s.contact_email
HAVING COUNT(so.order_id) > 1

2. More complicated Query:
   SELECT
   s.supplier_id,
   s.supplier_name,
   s.contact_email,
   subquery.order_count
   FROM
   suppliers s
   INNER JOIN (
   SELECT
   so.supplier_id,
   COUNT(so.order_id) AS order_count
   FROM
   supplierorders so
   GROUP BY
   so.supplier_id
   HAVING
   COUNT(so.order_id) > 1
   ) AS subquery
   ON s.supplier_id = subquery.supplier_id;

# Calculate the total number of orders fulfilled by each supplier

Select
s.supplier_id,
s.supplier_name,
s.contact_email,
COUNT(so.order_id)
From
suppliers s
INNER JOIN
supplierorders so
ON s.supplier_id = so.supplier_id
GROUP BY s.supplier_id, s.supplier_name, s.contact_email

# Identify suppliers who have not supplied any orders

select s.supplier_id, s.supplier_name, s.contact_email
from suppliers s
where s.supplier_id NOT IN (
Select distinct supplier_id from supplierorders
)

patients => patient_id, date_of_birth, patient_name
doctors => doctor_id, doctor_name, specialty
appointments => appointment_id, doctor_id, patient_id, appointment_date

# List all appointments for a specific patient

select a.appointment_id, a.appointment_date, p.patient_id
from patients p
INNER JOIN appointments a
on a.patient_id = p.patient_id
where a.patient_id = 1

# Find doctors with more than a certain number of appointments

select d.doctor_id, d.doctor_name, d.specialty, COUNT(a.appointment_id) as total_appointments
from doctors d
INNER JOIN appointments a
on a.doctor_id = d.doctor_id
group by d.doctor_id, d.doctor_name, d.specialty
HAVING COUNT(a.appointment_id) > 1

# Identify patients who have appointments with more than one doctor

SELECT
p.patient_id,
p.date_of_birth,
p.patient_name,
COUNT(app.doctor_id) AS doctor_count
FROM
patients p
INNER JOIN (
SELECT DISTINCT a.patient_id, a.doctor_id
FROM appointments a
) AS app
ON p.patient_id = app.patient_id
GROUP BY
p.patient_id, p.date_of_birth, p.patient_name
HAVING
COUNT(app.doctor_id) > 1;

sales => sale_id, saleperson_id, amount, sale_date
salespeople => salesperson_id, name, region
regions => region_id, region

# Total Sales amount made by each salesperson

select
s.salesperson_id
SUM(s.amount) as Total_Sales
from
sales s
group by
s.salesperson_id

# Listing salespeople who have not made any sales

select
sp.salesperson_id,
sp.name,
sp.region
from
salespeople sp
where
sp.salesperson_id
NOT IN
(select distinct s.salesperson_id from sales s)

# Identify regions with the highest total sales

select r.region_id, r.region_name, subquery.total_sales
from regions r
INNER JOIN (
select sp.region, SUM(s.amount) as total_sales
from salespeople sp
INNER JOIN sales s
on s.salesperson_id = sp.salesperson_id
group by sp.region
order by total_sales DESC
LIMIT 1
) AS subquery
on r.region_name = subquery.region

Possible Incorrect Query:

select r.region_id, r.region_name, subquery.total_sales
from regions r
INNER JOIN (
select sp.salesperson_id, sp.region, SUM(s.amount) as total_sales
from salespeople sp
INNER JOIN sales s
on s.salesperson_id = sp.salesperson_id
group by sp.salesperson_id, sp.region
order by total_sales DESC
LIMIT 1
) AS subquery
on r.region_name = subquery.region

=> Here we are grouping by salesperson_id, region which may not
be give us the correct grouping by region because it is possible
to have combinations of salesperson_id/region for same region with
different salesperson_id, in this case we will end up finding incorrect
amount of total sales for a region
Ex: salesperson_id, region amount
2 North 1900
3 North 2100
The above grouping will give (2, North, 1900) as total_sales for North
but the correct total sales amount for North is 4000. It is also possible
that we may get incorrect region because (salesperson_id, region) has
more entries for incorrect region

books => book_id, author_id, publisher_id, book_title
authors => author_id, author_name
publishers => publisher_id, publisher_name

# Tasks include listing all books along with their authors and publishers

select b.book_id, b.author_id, b.publisher_id, b.book_title, a.author_name, p.publisher_name
from books b
INNER JOIN authors a
on b.author_id = a.author_id
INNER JOIN publishers p
on p.publisher_id = b.publisher_id

# Find authors who have written books for more than one publisher

select a.author_id, a.author_name, COUNT(b.publisher_id) as publishers_count
from authors a
INNER JOIN books b
on a.author_id = b.author_id
group by a.author_id, a.author_name
HAVING publisher_count > 1

# Identify publishers that have published a large number of books

select p.publisher_id, p.publisher_name, COUNT(b.book_id) as book_count
from publishers p
INNER JOIN books b
on b.publisher_id = p.publisher_id
group by p.publisher_id, p.publisher_name
HAVING COUNT(b.book_id) > 1

cities => city_id, country_id, city_name
populations => population, city_id, population_id
countries => country_id, country_name

# List all cities with their populations

select c.city_id, c.country_id, c.city_name, p.population
from cities c
INNER JOIN populations p
on p.city_id = c.city_id

# Find countries with more than a specified number of cities

To count the specified number of cities, we should use COUNT and not SUM

select c.country_id, c.country_name, COUNT(cities.city_id) as NUMBER_OF_CITIES
from countries c
INNER JOIN cities
on cities.country_id = c.country_id
group by c.country_id, c.country_name
Having COUNT(cities.city_id) > 2

# Identify cities with populations above a certain threshold

select c.city_id, c.city_name, SUM(p.population) as TOTAL_POPULATION
from cities c
Inner join populations p
on p.city_id = c.city_id
group by c.city_id, c.city_name
HAVING sum(p.population) > 1000

# Identify all customers including those who have not placed any orders

Customers who have not placed orders: We use distinct because same customer can place multiple orders, and hence we can
have duplicate customer_id in the subquery, using "distinct" removes duplicates and gives us only unique customer_id

select c.customer_id, c.name as customer_name, c.address as customer_address
from customers c
where c.customer_id NOT IN (
select distinct customer_id from orders
)

customers who have placed orders:

select c.customer_id, c.name as customer_name, c.address as customer_address
from customers c
where c.customer_id IN (
select distinct customer_id from orders
)

# List customers with their order details and ensures customers without any orders are also represented in the result

SELECT
c.customer_id,
c.name AS customer_name,
c.address AS customer_address,
o.order_id,
o.order_date,
od.product_id,
od.quantity
FROM
customers c
LEFT OUTER JOIN
orders o ON c.customer_id = o.customer_id
LEFT OUTER JOIN
orderdetails od ON o.order_id = od.order_id;

# List all employees and their project assignments, including employees who are not currently assigned to any project - Show relationship between employees and projects cmoprehensively

select ej.employee_id, ep.project_id, ej.job_title, em.name as employee_name, em.salary as employee_salary, ep.role as employee_role
from employees em
LEFT OUTER JOIN employees_job ej
on em.name = ej.name
LEFT OUTER JOIN employees_projectroles ep
on ej.employee_id = ep.employee_id

# Teachers and the classes they teach, including those teachers who do not have any classes assigned to them

select t.teacher_id, t.teacher_name, t.department_id, c.class_id, c.class_name
from teachers t
LEFT OUTER JOIN classes c
on t.teacher_id = c.teacher_id

# List all orders and the products associated with them, including products that have never been ordered, - product performance and inventory

Select
p.product_id, p.category_id, p.manufacturer_id, p.product_name, pp.product_name, pp.price, o.order_date
from
products p
LEFT OUTER JOIN
products_price pp
on p.product_id = pp.product_id
LEFT OUTER JOIN
orderdetails od
on od.product_id = p.product_id
LEFT OUTER JOIN orders o
on o.order_id = od.order_id

# Sales data by employees, including cases where sales entries exist without a corresponding employee record - data discrepancies / future sales assgns

select s.sale_id, s.salesperson_id, s.amount, s.sale_date, sp.name as salesperson_name, sp.region
from sales s
LEFT OUTER JOIN salespeople sp
on s.salesperson_id = sp.salesperson_id

# List all departments and their managers, including managers who are not currently managing any department

Use of where clause to simplify complicated JOIN condition:

SELECT
e.name AS employee_name,
e.salary,
d.department_id,
d.department_name,
d.location
FROM
employees e
JOIN
employees_manager m ON e.name = m.name -- Get all employees from the employees table
WHERE
m.manager_id = e.employee_id -- Only consider employees who are managers
LEFT OUTER JOIN
departments d ON e.department_id = d.department_id; -- Join departments to get the department info

Complicated JOIN without where clause:

select subquery.employee_name, subquery.salary, d.department_id, d.location, d.department_name
from departments d
RIGHT OUTER JOIN (
select e.name as employee_name, e.department_id, e.salary as salary
from employees e
where e.name IN (
select m.name from employees_manager m
where m.manager_id = m.employee_id
)
) as subquery
on d.department_id = subquery.department_id

# Comprehensive view of employees and departments, including employees not assigned to any department and departments with no employees

employees => name, department_id, salary
departments => department_id, department_name, location

select e.name, e.department_id as employee_department, e.salary, d.department_id as department_id, d.location, d.department_name
from employees e
FULL OUTER JOIN departments d
on e.department_id = d.department_id

# Cartesian product of all possible combinations of products and colors to display every possible product variant

In CROSS JOIN we do not use any JOIN CONDITION, because we want to generate all possible combinations without any
matches to exhibit all possible variations

select p.product_id, p.category_id, p.manufacturer_id, p.product_name, c.color_name, c.color_id
from products p
CROSS JOIN colors c

# Identify pairs or groups of employees who report to the same manager useful for managerial analysis and team structuring

select em.employee_id, em.manager_id, em.name as employee_name, m.name as manager_name
from employees_manager em1
INNER JOIN employees_manager em2
ON em1.manager_id = em2.manager_id # employees that have the same manager_id will be matched
WHERE em1.name < em2.name # SELF PAIRING ROWS, Duplicate pairs will be removed => (a, a) ; (a, b), (b,a)
INNER JOIN employees_manager m
ON em1.manager_id = m.employee_id

# Find and list overlapping bookings for the same room, which is crucial for managing conflicts and optimizing room usage

bookings => booking_id, room_id, start_date, end_date
This is a classic case of self_join, for Overlaps we have the condition
a. a1.start_time <= a2.end_time
b. a1.end_time >= a2.start_time
To avoid duplicate pairing with itself, or duplicate pairs of the form (a, b), (b, a)
a. a1.booking_id < a2.booking_id

SELECT
b1.room_id as room_id,
b1.booking_id as booking_one_id,
b1.start_date as booking_one_start_date,
b1.end_date as booking_one_end_date,
b2.booking_id as booking_two_id,
b2.start_date as booking_two_start_date,
b2.end_date as booking_two_end_date
FROM
bookings b1
INNER JOIN
bookings b2
ON
b1.room_id = b2.room_id
WHERE
b1.start_date <= b2.end_date
AND
b1.end_date >= b2.start_date
AND
b1.booking_id < b2.booking_id
ORDER BY
b1.booking_id

# Identify customers who have the same address, useful for merging duplicate records or family/group targeting

Same address => Self Join

SELECT
c1.customer_id as customer_one_id,
c2.customer_id as customer_two_id,
c1.name as customer_one_name,
c2.name as customer_two_name,
c1.address as customer_address
FROM
customers c1
INNER JOIN
customers c2
ON
c1.address = c2.address
WHERE
c1.customer_id < c2.customer_id
ORDER BY
c1.customer_id

# Identify employees with the same job title

employees => name, department_id, salary
employees_job => employee_id, name, job_title

Simple Query: Generates all employees with same job title with employee_id, name, job_title for
pairs of employees that share the same job title

SELECT
em1.name as employee_one_name,
em2.name as employee_two_name,
em1.employee_id as employee_one_id,
em2.employee_id as employee_two_id,
em1.job_title as employee_job_title
FROM
employees_job em1
INNER JOIN
employees_job em2
ON
em1.job_title = em2.job_title
WHERE
em1.employee_id < em2.employee_id
ORDER BY
em1.employee_id

NOTE: Employees with the same job title, along with department_id and salary of employees.
This is complex as we have to perform 2 additional LEFT OUTER JOINS on employees table
to fetch department_id, salary for employees of em1 and em2 table separately
LEFT OUTER JOIN is CRUCIAL because we want to keep the rows from previous INNER JOIN intact
without losing them in case "name" of any of the employee_one, employee_two does not match
with the employees table "name"

SELECT
em1.employee_id as employee_one_id,
em2.employee_id as employee_two_id,
em1.name as employee_one_name,
em2.name as employee_two_name,
em1.job_title as employee_job_title,
e1.department_id as employee_one_department_id,
e1.salary as employee_one_salary,
e2.department_id as employee_two_department_id,
e2.salary as employee_two_salary
FROM
employees_job em1
INNER JOIN
employees_job em2
ON
em1.job_title = em2.job_title
LEFT OUTER JOIN
employees e1
ON
e1.name = em1.name
LEFT OUTER JOIN
employees e2
ON
e2.name = em2.name
WHERE
em1.employee_id < em2.employee_id
ORDER BY
em1.employee_id

# Find Pairs of students with the same birth date

students_birth => student_id, birth_date, name

SELECT
sb1.student_id as student_one_id,
sb2.student_id as student_two_id,
sb1.name as student_one_name,
sb2.name as student_two_name,
sb1.birth_date as student_birth_date
FROM
students_birth sb1
INNER JOIN
students_birth sb2
ON
sb1.birth_date = sb2.birth_date
WHERE
sb1.student_id < sb2.student_id
ORDER BY
sb1.student_id

# Find products with similar price ranges

SELECT
pp1.product_id as product_one_id,
pp2.product_id as product_two_id,
pp1.product_name as product_one_name,
pp2.product_name as product_two_name,
pp1.price as product_price,
p1.category_id as product_one_category_id,
p2.category_id as product_two_category_id,
p1.manufacturer_id as product_one_manufacturer_id,
p2.manufacturer_id as product_two_manufacturer_id
FROM
products_price pp1
INNER JOIN
products_price pp2
ON
pp1.price = pp2.price
LEFT JOIN
products p1
ON
pp1.product_id = p1.product_id
LEFT JOIN
products p2
ON
pp2.product_id = p2.product_id
WHERE
pp1.product_id < pp2.product_id
ORDER BY
pp1.product_id

# List orders with overlapping order dates for the same customer

SELECT
oo1.order_id as order_one_id,
oo2.order_id as order_two_id,
oo1.customer_id as order_customer_id,
oo1.order_date as order_one_order_date,
oo2.order_date as order_two_order_date,
oo1.end_date as order_one_end_date,
oo2.end_date as order_two_end_date
FROM
orders_overlap oo1
INNER JOIN
orders_overlap oo2
ON
oo1.customer_id = oo2.customer_id
WHERE
oo1.order_id < oo2.order_id
AND
oo1.order_date <= oo2.end_date
AND
oo1.end_date >= oo2.order_date
ORDER BY
oo1.order_id

# Identify employees with the same manager

employees_manager => employee_id, manager_id, name
em1.employee_id != em1.manager_id =>
=> This is to avoid joining employees with their managers because
manager_id of manager is same as employee_id
=> We only want to join non-manager employees together if they
have the same manager, we dont want to join and employee and a manger
if they have same manager_id. IN current table a manager has the
employee_id value in manager_id field

SELECT
em1.employee_id as employee_one_id,
em2.employee_id as employee_two_id,
em1.manager_id as employee_manager,
em1.name as employee_one_name,
em2.name as employee_two_name,
m1.name as manager_name
FROM
employees_manager em1
INNER JOIN
employees_manager em2
ON
em1.manager_id = em2.manager_id
INNER JOIN
employees_manager m1
ON
m1.employee_id = em1.manager_id
WHERE
em1.employee_id < em2.employee_id
AND
em1.employee_id != em1.manager_id
AND
em2.employee_id != em1.manager_id
ORDER BY
em1.manager_id

# Find flights departing from the same airport at overlapping times

flights => flight_id, departure_time, arrival_time, departure_airport

SELECT
f1.flight_id as flight_one_id,
f2.flight_id as flight_two_id,
f1.departure_airport as flight_departure_airport,
f1.departure_time as flight_one_departure_time,
f1.arrival_time as flight_one_arrival_time,
f2.departure_time as flight_two_departure_time,
f2.arrival_time as flight_two_arrival_time
FROM
flights f1
INNER JOIN
flights f2
ON
f1.departure_airport = f2.departure_airport
WHERE
f1.flight_id < f2.flight_id
AND
f1.departure_time <= f2.arrival_time
AND
f1.arrival_time >= f2.departure_time
ORDER BY
f1.flight_id

# Find pairs of courses with overlapping schedules

courseschedule => course_id, start_time, end_time, course_name

SELECT
c1.course_id as course_one_id,
c1.start_time as course_one_start_time,
c1.end_time as course_one_end_time,
c1.course_name as course_one_name,
c2.course_id as course_two_id,
c2.start_time as course_two_start_time,
c2.end_time as course_two_end_time,
c2.course_name as course_two_name
FROM
courseschedule c1
INNER JOIN
courseschedule c2
ON
c1.start_time <= c2.end_time
AND
c1.end_time >= c2.start_time
WHERE
c1.course_id < c2.course_id
ORDER BY
c1.course_id

# Find pairs of employees in the same role for different projects

employees_projectroles => employee_id, project_id, name, role

SELECT
ep1.employee_id as employee_one_id,
ep1.project_id as employee_one_project_id,
ep1.name as employee_one_name,
ep1.role as employee_role,
ep2.employee_id as employee_two_id,
ep2.project_id as employee_two_project_id,
ep2.name as employee_two_name
FROM
employees_projectroles ep1
INNER JOIN
employees_projectroles ep2
ON
ep1.role = ep2.role
AND
ep1.project_id != ep2.project_id
WHERE
ep1.employee_id < ep2.employee_id
ORDER BY
ep1.employee_id
