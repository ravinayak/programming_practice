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
