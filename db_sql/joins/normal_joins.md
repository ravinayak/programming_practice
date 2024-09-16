select column_name, data_type, is_nullable, column_default
from information_schema.columns
where table_name = 'categories'

select emp.salary, dept.department_name, dept.location
from employees emp
INNER JOIN departments dept
on emp.department_id = dept.department_id;

select cust.name, cust.address, orders.order_date, odt.quantity
from customers cust
INNER JOIN orders
on cust.customer_id = orders.customer_id
INNER JOIN orderdetails odt
on odt.order_id = orders.order_id

select products.product_name, manufacturer_name, country as manufacturer_country, category_name
from products
INNER JOIN categories
ON products.category_id = categories.category_id
INNER JOIN manufacturers
ON products.manufacturer_id = manufacturers.manufacturer_id

select students.student_id, name as student_name, course_name, advisor_name
from students
INNER JOIN enrollments ers
ON students.student_id = ers.student_id
INNER JOIN courses
ON courses.course_id = ers.course_id
INNER JOIN advisors
ON advisors.advisor_id = students.advisor_id
select course_id from enrollments where enrollments.student_id=1
select \* from courses where course_id = 201

select movies.release_year, movies.movie_title, actors.actor_name, directors.director_name
from actors
INNER JOIN movieactors
on actors.actor_id = movieactors.actor_id
INNER JOIN movies
on movies.movie_id = movieactors.movie_id
INNER JOIN moviedirectors
on movies.movie_id = moviedirectors.movie_id
INNER JOIN directors
on directors.director_id = moviedirectors.director_id

select supplier_name, contact_email as supplier_contact_email, order_date
from suppliers
INNER JOIN supplierorders
on suppliers.supplier_id = supplierorders.supplier_id
INNER JOIN orders
on supplierorders.order_id = orders.order_id

select column_name, data_type, is_nullable, column_default
from information_schema.columns
where table_name = 'populations'

select country_name, city_name, population
from countries
INNER JOIN cities
on cities.country_id = countries.country_id
INNER JOIN populations
on populations.city_id = cities.city_id

select name as customer_name, address as customer_address, order_date
from customers
LEFT OUTER JOIN orders_left
on customers.customer_id = orders_left.customer_id

select department_name, manager_name
from departments_right
RIGHT OUTER JOIN managers
on departments_right.manager_id = managers.manager_id

select name as employee_name, salary as employee_salary, department_name, location as department_location
from employees
FULL OUTER JOIN departments
on employees.department_id = departments.department_id

select em.name as employee_name, m.name as manager_name
from employees_manager em
INNER JOIN employees_manager m
ON em.manager_id = m.employee_id

# Important problem - and solution

# Problem 21: Retrieve all pairs of bookings that overlap in time for the same room by using a SELF JOIN on Bookings.

SELECT DISTINCT b1.room_id, b1.booking_id, b2.booking_id
FROM bookings b1
INNER JOIN bookings b2
ON b1.room_id = b2.room_id -- Same room
AND b1.booking_id < b2.booking_id -- Avoid joining the same booking
AND b1.start_date <= b2.end_date -- b1 starts before b2 ends
AND b1.end_date >= b2.start_date -- b1 ends after b2 starts
ORDER BY b1.room_id;

When using self joins to retrieve information for rows that have same rooms, same address for a person
we should use a condition where we

1. only get DISTINCT PAIRS => If we are retrieving names of two persons, we dont want those pairs to have
   structure like (a1, b1) and (b1, a1), in this case we can use c1.name < c2.name where c1 and c2 represent
   customers. This will ensure that only (a1, b1) is retrieved, and (b1, a1) is NOT RETRIEVED because a1 < b1
2. same row IS NOT DUPLICATED => c1.name != c2.name, c1.room_id != c2.room_id
   This is to ensure that the same row is not joined with itself, for ex: c1.room_id = 20, c2.room_id = 40
   Only Pairs which have room_id as different values for c1, c2 are joined, same values will NOT BE JOINED
   together

# Problem 22: Retrieve pairs of customers who share the same address by using a SELF JOIN on Customers_Self.

SELECT c_one.name AS customer_one_name, c_two.name AS customer_two_name, c_one.address AS customer_address
FROM customers_self c_one
INNER JOIN customers_self c_two
ON c_one.address = c_two.address
WHERE c_one.name != c_two.name
AND c_one.name < c_two.name -- Ensure no duplicate pairs
ORDER BY c_one.name;

# Retrieve all pairs of employees who have the same job title by using a SELF JOIN on Employees_Job.

select em.name as employee_one_name, m.name as employee_two_name, em.job_title
from employees_job em
INNER JOIN employees_job m
on em.job_title = m.job_title
where em.employee_id != m.employee_id and
em.name < m.name
order by em.name

# Retrieve all pairs of products whose prices differ by 100 or less by using a SELF JOIN on Products_Price

NOTE: It is important to use ABS function here because without ABS function, all the price differences
which are -ve, where same product is combined with another product such that product1 has less price than
product2 with a difference of <= 100 will NOT BE CONSIDERED although it should be considered
Ex: product 1 - 250, product2 - 300 => price difference is <= 100, and it should be considered in the
result but if we do NOT use ABS function, this product combination will NOT be considered

SELECT p1.product_name AS product_one_name,
p2.product_name AS product_two_name,
p1.price AS product_one_price,
p2.price AS product_two_price
FROM products_price p1
INNER JOIN products_price p2
ON ABS(p1.price - p2.price) <= 100 -- Absolute difference to ensure both greater and lesser comparisons
WHERE p1.product_id != p2.product_id -- Exclude self-pairs
AND p1.product_name < p2.product_name -- Avoid duplicate pairs like (Product A, Product B) and (Product B, Product A)
ORDER BY p1.product_name;

# Retrieve orders that have overlapping dates for the same customer by using a SELF JOIN on Orders_Overlap.

Only 1 condition to check if orders overlap is sufficient, because if Order1 overlaps with Order2, then
Order2 surely overlaps with Order1, hence 2nd condition check is redundant and not required
(or1.end_date >= or2.order_date AND or1.order_date <= or2.end_date)
OR
(or2.end_date >= or1.order_date AND or2.order_date <= or1.end_date)

SELECT
or1.order_id AS order_one_id,
or1.customer_id AS order_one_customer_id,
or1.order_date AS order_one_order_date,
or1.end_date AS order_one_end_date,
or2.order_id AS order_two_id,
or2.customer_id AS order_two_customer_id,
or2.order_date AS order_two_order_date,
or2.end_date AS order_two_end_date
FROM orders_overlap or1
INNER JOIN orders_overlap or2
ON or1.customer_id = or2.customer_id -- Ensure both orders are from the same customer
AND or1.order_id != or2.order_id -- Avoid comparing the same order with itself
AND or1.order_date <= or2.end_date -- Order 1 starts before or when Order 2 ends
AND or1.end_date >= or2.order_date -- Order 1 ends after or when Order 2 starts
WHERE or1.order_id < or2.order_id -- Avoid duplicate pairs (e.g., (1, 2) and (2, 1))
ORDER BY or2.order_id;

# Retrieve flights departing from the same airport at overlapping times by using a SELF JOIN on Flights.

For flights, departure_time is same as order_date for orders,
and arrival_time is same as end_date for orders
Flight => departure_time => flight leaves airport to start its trip => same as start of order => order_date is when order is placed, starts order
Flight => arrival_time => flight ends its trip, returns back to airport => same as end of order => end_date is when order is received, ends order

# Use this analogy to find Overlapping Flights

select
f1.flight_id as flight_one_id,
f1.departure_time as flight_one_departure_time,
f1.arrival_time as flight_one_arrival_time,
f1.departure_airport as flight_one_departure_airport,
f2.flight_id as flight_two_id,
f2.departure_time as flight_two_departure_time,
f2.arrival_time as flight_two_arrival_time,
f2.departure_airport as flight_two_departure_airport
from flights f1
INNER JOIN flights f2
on f1.departure_airport = f2.departure_airport
where f1.departure_time <= f2.arrival_time
AND f1.arrival_time >= f2.departure_time
AND f1.flight_id != f2.flight_id
AND f1.flight_id < f2.flight_id
order by f1.flight_id

# Retrieve pairs of courses that have overlapping schedules by using a SELF JOIN on CourseSchedule

select
c1.course_id as course_one_course_id,
c1.start_time as course_one_start_time,
c1.end_time as course_one_end_time,
c1.course_name as course_one_name,
c2.course_id as course_two_course_id,
c2.start_time as course_two_start_time,
c2.end_time as course_two_end_time,
c2.course_name as course_two_name
from courseschedule c1
INNER JOIN courseschedule c2
on c1.start_time <= c2.end_time AND c1.end_time >= c2.start_time
where c1.course_id != c2.course_id
AND c1.course_id < c2.course_id
order by c1.course_id

# Retrieve employees who have the same role but work on different projects by using a SELF JOIN on Employees_ProjectRoles

SELECT
em1.role AS employee_one_role,
em1.project_id AS employee_one_project_id,
em1.employee_id AS employee_one_employee_id,
em1.name AS employee_one_name,
em2.name AS employee_two_name,
em2.employee_id AS employee_two_employee_id,
em2.project_id AS employee_two_project_id,
em2.role AS employee_two_role
FROM employees_projectroles em1
INNER JOIN employees_projectroles em2
ON em1.role = em2.role -- Same role
AND em1.project_id != em2.project_id -- Different projects
WHERE em1.name < em2.name -- Avoid duplicate pairs and self-joins
ORDER BY em1.name;
