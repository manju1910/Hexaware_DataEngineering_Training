create database practice
use practice

CREATE TABLE salesman (
    salesman_id INT PRIMARY KEY,
    name VARCHAR(255),
    city VARCHAR(255),
    commission DECIMAL(4, 2)
);
INSERT INTO salesman (salesman_id, name, city, commission) VALUES
(5001, 'James Hoog', 'New York', 0.15),
(5002, 'Nail Knite', 'Paris', 0.13),
(5005, 'Pit Alex', 'London', 0.11),
(5006, 'Mc Lyon', 'Paris', 0.14),
(5003, 'Lauson Hen', NULL, 0.12),
(5007, 'Paul Adam', 'Rome', 0.13);
  

select * from salesman

select commission,name,city from salesman o where commission =(select max(commission) from salesman i where o.city=i.city )

-- find the avg commssion of salesman from paris
select avg(commission) from salesman where city = 'Paris'


-- find out if there are cities with only one salesman ,no null city and list them
select city from salesman group by city having count(city)=1 and count(city) is not null
--or
select city,count(salesman_id) from salesman where city is not null group by city having count(city)=1


-- Determine the maximum commission in each city, and list the salesmen who earn this commission
-- Clue: Join,sub query 
--task 3.1- first find the max commision of each city
select max(commission),city from salesman  where city is not null group by city  

--task 3.2
--find the person who got that maximum in each city  clue:join|
SELECT name 
FROM salesman s 
WHERE s.commission = (
    SELECT MAX(s1.commission)  
    FROM salesman s1 
    WHERE s.city = s1.city AND s1.city IS NOT NULL
);

--or
SELECT city, commission, name
FROM salesman s1
WHERE commission = (
    SELECT MAX(s2.commission)
    FROM salesman s2
    WHERE s1.city = s2.city
);

--or using join
SELECT s.*
from salesman s
join(
    select city,max(commission) as m
    from salesman
    where city is not null
    group by city
    ) sales on s.commission=sales.m and s.city=sales.city;

-------------------------------------------------


CREATE TABLE orders (
    ord_no INT PRIMARY KEY,
    purch_amt DECIMAL(10, 2),
    ord_date DATE,
    customer_id INT,
    salesman_id INT
);
 
 
INSERT INTO orders (ord_no, purch_amt, ord_date, customer_id, salesman_id) VALUES
(70001, 150.5, '2012-10-05', 3005, 5002),
(70009, 270.65, '2012-09-10', 3001, 5005),
(70002, 65.26, '2012-10-05', 3002, 5001),
(70004, 110.5, '2012-08-17', 3009, 5003),
(70007, 948.5, '2012-09-10', 3005, 5002),
(70005, 2400.6, '2012-07-27', 3007, 5001),
(70008, 5760, '2012-09-10', 3002, 5001),
(70010, 1983.43, '2012-10-10', 3004, 5006),
(70003, 2480.4, '2012-10-10', 3009, 5003),
(70012, 250.45, '2012-06-27', 3008, 5002),
(70011, 75.29, '2012-08-17', 3003, 5007),
(70013, 3045.6, '2012-04-25', 3002, 5001);

 


--task 4  sub query
-- -- Task 4 - Sub-Query
-- Write a query to display all the orders from the orders table issued by the salesman 'Paul Adam'.
select * from orders o join salesman s on o.salesman_id=s.salesman_id where name='Paul Adam'
--or
select * from orders where salesman_id = (select salesman_id from salesman where name ='Paul Adam')


--- Task 5 
-- Write a query to display all the orders which values are greater than the average purch_amt for 10th October 2012
-- frist calculate avg value for that date and print rows which are greater than thst value
--5.1  find avg value for 10th oct
select avg(purch_amt) from orders where ord_date='2012-10-10'
--5.2
select * from orders where purch_amt > (select avg(purch_amt) from orders where ord_date='2012-10-10')

--Task 6
--write a query to find all orders amounts which are above average amounts for their customers

select purch_amt,customer_id from orders o where purch_amt > (select avg(purch_amt) from 
 orders i  where o.customer_id=i.customer_id)


 --Task 7 To rpint allthe sales done by the persons in the city paris use:subquery

 select * from salesman s inner join orders o on s.salesman_id=o.salesman_id 
 where s.city='Paris'
 --byusing subquery

                   select * from orders o where o.salesman_id in (select salesman_id from salesman s where city='Paris' )



CREATE TABLE customer (
    customer_id INT PRIMARY KEY,
    cust_name VARCHAR(255),
    city VARCHAR(255),
    grade INT NULL,
    salesman_id INT
);
INSERT INTO customer (customer_id, cust_name, city, grade, salesman_id) VALUES
(3002, 'Nick Rimando', 'New York', 100, 5001),
(3005, 'Graham Zusi', 'California', 200, 5002),
(3001, 'Brad Guzan', 'London', NULL, 5005),
(3004, 'Fabian Johns', 'Paris', 300, 5006),
(3007, 'Brad Davis', 'New York', 200, 5001),
(3009, 'Geoff Camero', 'Berlin', 100, 5003),
(3008, 'Julian Green', 'London', 300, 5002),
(3003, 'Jozy Altidor', 'Moscow', 200, 5007);

select * from customer
     



---- Task 8 
-- Write a query to find the name and id of all salesmen who had more than one customer

--8.1  
select salesman_id from customer group by salesman_id having count(salesman_id)>1
--8.2
select name,salesman_id from salesman where salesman_id in (select salesman_id from customer group by salesman_id having count(salesman_id)>1)
                      
--All & Any
--ALL
--when all the orders which is greater than poojitha's order(her maximum order)so far she made
--for this we use all
 select * from orders where purch_amt> ALL(select purch_amt from orders where customer_id =3005) 
--consider 3005 is poojitha's id
--this can by be done in normal form like

select * from orders where purch_amt >(select max(purch_amt) from orders where customer_id=3005)

--Any
-- if the pruch_amt is more than the minimum value is okay if poojitha's minimum oreeder is at 
--rs.150 any order greate than 150 is ok



--Task 9
--write a query to displY only those customers whose grade are higher than the grade of all customers present in newyork



select cust_name,customer_id from customer where grade >(select max(grade) from customer where city='New York')

--using all
SELECT CUST_NAME 
FROM CUSTOMER
WHERE GRADE > ALL(SELECT GRADE 
FROM CUSTOMER
WHERE CITY = 'NEW YORK');



--Task 10
--write a query to find all orders with an amount (purch_amt)smaller than any amount for a customer in london
-- 3 subqueries
--using any (u can also use min function)
--10.1 find people in london
select customer_id from customer where city= 'London'--3001,3008
--10.2 find min order in that 3001 and 3008
select * from orders where customer_id in (3001,3008)
-- find orders below that minimum
select * from orders where purch_amt <250.45

--final ans
select * from orders where purch_amt <ANY(select purch_amt from	
									orders where customer_id in (select 
									customer_id from customer 
									where city= 'London'))







CREATE TABLE EmployeeData (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Salary INT,
    StartDate DATE
);

INSERT INTO EmployeeData (EmployeeID, FirstName, LastName, Salary, StartDate) VALUES
(1, 'John', 'Doe', 70000, '2020-05-01'),
(2, 'Jane', 'Smith', 85000, '2018-08-15'),
(3, 'Emily', 'Jones', 94000, '2019-12-30'),
(4, 'Chris', 'Brown', 62000, '2021-03-22');

select * from EmployeeData
--task 1
--sort the employee by the len of the first name
select FirstName from EmployeeData order by len(FirstName)


-- Task 2
-- Get the Initials JD, JS, EJ, CB

select left(FirstName,1)+left(LastName,1) from EmployeeData


--Task 3
--Extract and display the first three letters of each epmployer's last name and display it in upper 
--CLUE:SUBSTRING
select upper(left(LastName,3)) from EmployeeData
--using substring
select upper(substring(LastName,1,3)) from EmployeeData


--Task 4
--wirte a query to calcualte the tenure(no.of.years they employed) of each employee in complete years as of today)


SELECT 2024 - CAST(SUBSTRING(CONVERT(VARCHAR, StartDate, 120), 1, 4) AS INT) AS tenure
FROM EmployeeData;

--using datediff

select *,DATEDIFF(year,StartDate,getdate()) from EmployeeData

--Task 5
--assume a year salary increase of 3% for each employee.write a query to calculatee their new salary 
--rounded to the nearest wholenumber.

select round((Salary + 0.03 * Salary),2) from employeedata
-------------------------------------------------------------------------------------------------------------------------------------------



 
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(100),
    department VARCHAR(50)
);
 
CREATE TABLE projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(100),
    employee_id INT,
    start_date DATE,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);
 
 
INSERT INTO employees (employee_id, name, department) VALUES
(1, 'Alice', 'Engineering'),
(2, 'Bob', 'Engineering'),
(3, 'Charlie', 'HR'),
(4, 'David', 'Marketing');
 
INSERT INTO projects (project_id, project_name, employee_id, start_date) VALUES
(101, 'Alpha', 1, '2021-01-10'),
(102, 'Beta', 2, '2021-03-15'),
(103, 'Gamma', 1, '2021-02-20');

--find engineering people who are mapped to project
--subquery using exists(here exists always give 0 or 1 (boolean values))
select * from employees o  where department ='Engineering' and exists(select * from projects i where o.employee_id =i.employee_id)


