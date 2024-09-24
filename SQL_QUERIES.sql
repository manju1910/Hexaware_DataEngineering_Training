--21-08-2024
Create Database Company
use Company
CREATE TABLE Employee
(ID int PRIMARY KEY,Name varchar(50), Gender varchar(50) , Salary int, DepartmentId int);

INSERT INTO Employee (ID,Name,Gender,Salary,DepartmentId)
VALUES(1,'Tom','Male',4000,1),
(2,'Pam','Female',3000,3),
(3,'John','Male',3500,1),
(4,'Sam','Male',4500,2),
(5,'Tod','Male',2800,2),
(6,'Ben','Male',7000,1),
(7,'Sara','Female',4800,3),
(8,'Valarie','Female',5500,1),
(9,'James','Female',6500,NULL),
(10,'Russell','Male',8800,NULL);



CREATE TABLE Department
(ID int PRIMARY KEY,DepartmentName varchar(50), Location varchar(50) , DepartmentHead varchar(50));

INSERT INTO Department (ID,DepartmentName,Location,DepartmentHead)
VALUES(1,'IT','London','Rick'),
(2,'PayRoll','Delhi','Rion'),
(3,'HR','New York','Christe'),
(4,'Other Department','Sydney','Cindrella');

--INNER JOIN--  --Shows only the Common Data --
SELECT Name,Salary,DepartmentName
FROM Employee
INNER JOIN Department
ON Employee.DepartmentId = Department.ID

--Left Outer Join -- --Shows the Data which is not common also in the left hand side --
SELECT Name,Salary,DepartmentName
FROM Employee
LEFT JOIN Department
ON Employee.DepartmentId = Department.ID

--Right Outer Join -- --Shows the Data which is not common also in the left hand side --
SELECT Name,Salary,DepartmentName
FROM Employee
RIGHT JOIN Department
ON Employee.DepartmentId = Department.ID

--Full Outer JOIN -- -- Shows all the matching and unmatching Datas from Both left and right sides

SELECT Name,Salary,DepartmentName
FROM Employee
FULL OUTER JOIN Department
ON Employee.DepartmentId = Department.ID




-- Exercise --
CREATE TABLE Products
(Product_ID int PRIMARY KEY NOT NULL,Product_Name varchar(50), Price float);

INSERT INTO Products (Product_ID,Product_Name,Price)
VALUES(1,'Laptop',800.00),
(2,'Smartphone',500.00),
(3,'Tablet',300.00),
(4,'Headphones',50.00),
(5,'Monitor',150.00);

select * from products
select * from orders
CREATE TABLE Orders
(Order_ID int PRIMARY KEY NOT NULL,Product_ID int NOT NULL, Quantity int, OrderDate Date);

INSERT INTO Orders(Order_ID,Product_ID,Quantity,OrderDate)
VALUES
(1,1,2,'2024-08-01'),
(2,2,1,'2024-08-02'),
(3,3,3,'2024-08-03'),
(4,1,1,'2024-08-04'),
(5,4,4,'2024-08-05'),
(6,5,2,'2024-08-06'),
(7,6,1,'2024-08-07');

select * from orders

CREATE TABLE Customers
(Customer_ID int PRIMARY KEY NOT NULL,
 Customer_Name varchar(50),
 Email varchar(50));

INSERT INTO Customers (Customer_ID, Customer_Name, Email)
VALUES
(1, 'John Doe', 'john.doe@email.com'),
(2, 'Jane Smith', 'jane.smith@email.com'),
(3, 'Bob Johnson', 'bob.johnson@email.com'),
(4, 'Alice Brown', 'alice.brown@email.com'),
(5, 'Charlie Wilson', 'charlie.wilson@email.com');

ALTER TABLE Orders ADD  Customer_ID int;

UPDATE Orders SET Customer_ID = 1 WHERE Order_ID = 1;
UPDATE Orders SET Customer_ID = 2 WHERE Order_ID = 2;
UPDATE Orders SET Customer_ID = 3 WHERE Order_ID = 3;
UPDATE Orders SET Customer_ID = 4 WHERE Order_ID = 4;
UPDATE Orders SET Customer_ID = 5 WHERE Order_ID = 5;
UPDATE Orders SET Customer_ID = 1 WHERE Order_ID = 6;
UPDATE Orders SET Customer_ID = 2 WHERE Order_ID = 7;



--INNER JOIN--  --Shows only the Common Data --
SELECT *
FROM Products
INNER JOIN Orders
ON Products.Product_Id = Orders.Product_ID

--Left Outer Join -- --Shows the Data which is not common also in the left hand side --
SELECT *
FROM Products
LEFT JOIN Orders
ON Products.Product_Id = Orders.Product_ID

--Right Outer Join -- --Shows the Data which is not common also in the left hand side --
SELECT *
FROM Products
RIGHT JOIN Orders
ON Products.Product_Id = Orders.Product_ID

--Full Outer JOIN -- -- Shows all the matching and unmatching Datas from Both left and right sides

SELECT *
FROM Products
FULL OUTER JOIN Orders
ON Products.Product_Id = Orders.Product_ID


Select p.Product_Name,o.OrderDate, SUM(o.Quantity) AS Total_Quantity
FROM Orders o
JOIN Products p ON o.Product_ID = p.Product_ID
GROUP BY GROUPING SETS ((p.Product_Name),(o.OrderDate));


Select o.Order_ID, o.Product_ID,
(Select p.Product_Name FROM Products p WHERE p.Product_ID = o.Product_ID) AS Product_Name
From Orders o;



SELECT u. user id, u. user name
FROM Users u
WHERE EXISTS (SELECT 1 FROM Orders o WHERE o. user id = u. user id);

SELECT p. Product_ID, p.Price
FROM Products p
WHERE p.Price > ANY(SELECT Price FROM Products WHERE Product_Name LIKE 'Laptop%');

SELECT p. Product_Name, p.Price
FROM Products p
WHERE p.Price > ALL(SELECT Price FROM Products WHERE Product_Name LIKE 'Smartphone%');


Select u.user_id, u.user_name
FROM Users u
WHERE user_id IN (SELECT user_id
From Orders 
WHERE product_id IN (
SELECT Product_ID
From Products 
WHERE Price > 1000 )
);



-- DATA INTEGRITY-- --Used to preserve the data stored with some constriants --
CREATE TABLE Products(
ProductID INT PRIMARY KEY,  -- Enforces unique ProductID --
ProductName VARCHAR(100) NOT NULL, -- Prevents NULL values for ProductName --	
Category VARCHAR(50) NOT NULL,
Price DECIMAL(10,2) CHECK (Price > 0), -- Ensures Price is positive --
StockQuantity INT DEFAULT 0  -- Default value for StockQuantity --

-- fUNCTIONS --
SELECT ProductName, UPPER(ProductName) AS ProductNameUpperCase
FROM Products;
SELECT ProductName, LOWER(ProductName) AS ProductNameLowerCase
FROM Products;
SELECT ProductName, SUBSTRING(ProductName, 1, 3) AS ShortName
FROM Products;
SELECT ProductName,LEN(ProductName) AS NameLength
FROM Products;
SELECT ProductName,REPLACE (ProductName,' Phone', 'Device') AS UpdatedProductName
FROM Products;
SELECT ProductName,LTRIM(RTRIM(ProductName)) AS TrimmedProductName
FROM Products;
SELECT Product_Name, CHARINDEX( 'e' , Product_Name) AS PositionOfE
FROM Products;
SELECT Product_Name,category ,CONCAT(Product_Name, '-' , category) AS ProductDetai1s
FROM Products;
SELECT Product_Name,LEFT (Product_Name, 5) AS ShortName
FROM Products;
SELECT Product_Name,RIGHT (Product_Name, 3) AS ShortName
FROM Products;
SELECT Product_Name,REVERSE (Product_Name) AS ReversedName
FROM Products;
SELECT Product_Name, FORMAT (Price,'N1') AS Formattedprice
FROM Products;

SELECT Product_Name, REPLICATE (Product_Name, 3) AS RepeatedProductName
FROM Products;



SELECT GETDATE() AS CurrentDate,
DATEADD(DAY,10,GETDATE()) AS FutureDate;

SELECT DATEADD(YEAR,-1, GETDATE()) AS DateMinus1Year;

SELECT DATEDIFF(DAY,' 2020-01-01' ,GETDATE()) AS DaysDifference;

SELECT DATEDIFF(DAY,' 2024-01-01 ' ,GETDATE()) AS DaysDifference;

SELECT FORMAT(GETDATE(),' MMMM dd, yyyy') AS FormattedDate;
SELECT FORMAT(GETDATE(),'dd ,MM, yyyy') AS FormattedDate;
SELECT YEAR(GETDATE()) AS CurrentYear;
SELECT MONTH(' 2024-05-15') AS MonthExtracted;
SELECT DAY(' 2024-05-15') AS DAYExtracted;

SELECT DATEDIFF(MONTH, '2002-10-26', GETDATE()) AS DaysDiff;



-- practice questions 22-08-2024

--Date Function Exercises
--Calculate the number of months between your birthday and the current date.

select datediff(month,'2002-10-19',getdate())

--Retrieve all orders that were placed in the last 4 days of a particular date.

select p.product_name from Products p inner join Orders o on p.Product_ID=o.Product_ID where o.OrderDate > (select dateadd(day,-4,'2024-08-07'))
 

--Write a query to extract the year, month, and day from the current date.
select year(getdate()) as  year ,month(getdate()) as  month,day(getdate()) as day

--Calculate the difference in years between two given dates.
select datediff(year,'2020-03-04',getdate())

--Retrieve the last day of the month for a given date.
 SELECT EOMONTH('2024-08-15') AS last_day_of_month;

 --or

 -- Example date
DECLARE @date DATE = '2024-08-15';

-- Get the last day of the month
DECLARE @last_day DATE = EOMONTH(@date);

-- Get the day name of the last day
SELECT 
    @last_day AS last_day_of_month,
    FORMAT(@last_day, 'dddd') AS day_name;






--String Function Exercises
--Convert all customer names to uppercase.
select upper(product_name) from Products

--Extract the first 5 characters of each product name.
select left(product_name,5) from Products

--Concatenate the product name and category with a hyphen in between.
select CONCAT(product_name,'-',price) from Products

--Replace the word 'Phone' with 'Device' in all product names.
select replace(product_name,'phone','device') from Products
--Find the position of the letter 'a' in customer names.
select charindex('a',product_name ) from Products




--Aggregate Function Exercises
--Calculate the total sales amount for all orders.
select sum(price) from products

--Find the average price of products in each category.
select avg(price),product_name from Products group by Product_Name

--Count the number of orders placed in each month of the year.

--Find the maximum and minimum order quantities.
SELECT MAX(Quantity) AS MaxQuantity
FROM Orders;
SELECT Min(Quantity) AS MaxQuantity
FROM Orders;

--Calculate the sum of stock quantities grouped by product category.

SELECT 
    p.Product_Name,
    SUM(o.Quantity) AS TotalOrderedQuantity
FROM 
    Orders o
JOIN 
    Products p ON o.Product_ID = p.Product_ID
GROUP BY 
    p.Product_Name;


--Join Exercises
--Write a query to join the Customers and Orders tables to display customer names and their order details.

--Perform an inner join between Products and Orders to retrieve product names and quantities sold.
SELECT 
    p.Product_Name,
    o.Quantity
FROM 
    Products p
INNER JOIN 
    Orders o ON p.Product_ID = o.Product_ID;

--Use a left join to display all products, including those that have not been ordered.
SELECT 
    p.Product_Name,
    COALESCE(o.Quantity, 0) AS Quantity
FROM 
    Products p
LEFT JOIN 
    Orders o ON p.Product_ID = o.Product_ID;

--Write a query to join Employees with Departments and list employee names and their respective department names.
SELECT 
    e.Name AS EmployeeName,
    d.DepartmentName
FROM 
    Employee e
INNER JOIN 
    Department d ON e.DepartmentId = d.ID;

--Perform a self-join on an Employees table to show pairs of employees who work in the same department.

select e.name,e1.name,e.departmentId from Employee e  join employee e1 on e.departmentId=e1.departmentId where e.ID<e1.ID


-- Subquery Exercises --

-- Write a query to find products whose price is higher than the average price of all products. --
SELECT Product_Name, Price
FROM Products 
WHERE Price > (SELECT AVG(Price) FROM Products);

-- Retrieve customer names who have placed at least one order by using a subquery. --
SELECT * FROM Orders
SELECT Customer_Name
From Customers 
WHERE Customer_ID IN(SELECT DISTINCT Customer_ID FROM Orders);
-- Find the top 3 most expensive products using a subquery. --
SELECT Product_Name, Price
FROM Products
WHERE Price IN (
    SELECT DISTINCT TOP 3 Price
    FROM Products
    ORDER BY Price DESC
);
-- Write a query to list all employees whose salary is higher than the average salary of their department. --
SELECT e.EmployeeName, e.Salary, e.DepartmentID
FROM Employees e
WHERE e.Salary > (
    SELECT AVG(Salary)
    FROM Employees
    WHERE DepartmentID = e.DepartmentID
);
-- Use a correlated subquery to find employees who earn more than the average salary of all employees in their department.--
SELECT e.EmployeeName, e.Salary, e.DepartmentID
FROM Employees e
WHERE e.Salary > (
    SELECT AVG(Salary)
    FROM Employees
    WHERE DepartmentID = e.DepartmentID
);

-- Grouping and Summarizing Data Exercises --

--Group orders by customer and calculate the total amount spent by each customer.--
SELECT c.Customer_Name, SUM(p.Price * o.Quantity) AS total_spent
FROM Customers c
JOIN Orders o ON c.Customer_ID = o.Customer_ID
JOIN Products p ON o.Product_ID = p.Product_ID
GROUP BY c.Customer_ID, c.Customer_Name;

--Group products by category and calculate the average price for each category.--
SELECT Category, AVG(Price) AS avg_price
FROM Products
GROUP BY Category;

-- Group orders by month and calculate the total sales for each month.--
SELECT MONTH(OrderDate) AS order_month, SUM(p.Price * o.Quantity) AS total_sales
FROM Orders o
JOIN Products p ON o.Product_ID = p.Product_ID
GROUP BY MONTH(OrderDate)
ORDER BY order_month;

-- Write a query to group products by category and calculate the number of products in each category.--
SELECT Category, COUNT(*) AS product_count
FROM Products
GROUP BY Category;

-- Use the HAVING clause to filter groups of customers who have placed more than 5 orders.--
SELECT c.Customer_ID, c.Customer_Name, COUNT(o.Order_ID) AS order_count
FROM Customers c
JOIN Orders o ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID, c.Customer_Name
HAVING COUNT(o.Order_ID) > 5;


--Set Operations (UNION, INTERSECT, EXCEPT)--

-- Write a query to combine the results of two queries that return the names of customers from different tables using UNION.--
SELECT Customer_Name AS Name FROM Customers
UNION
SELECT Employee_Name AS Name FROM Employees;

-- Find products that are in both the Electronics and Accessories categories using INTERSECT.--
SELECT Product_ID, Product_Name
FROM Products
WHERE Category = 'Electronics'
INTERSECT
SELECT Product_ID, Product_Name
FROM Products
WHERE Category = 'Accessories';

-- Write a query to find products that are in the Electronics category but not in the Furniture category using EXCEPT.--
SELECT Product_ID, Product_Name
FROM Products
WHERE Category = 'Electronics'
EXCEPT
SELECT Product_ID, Product_Name
FROM Products
WHERE Category = 'Furniture';



--23-08-24

--mathematical operatins
select round(price,2) from Products
select ceiling(price) from Products
select floor(price) from Products
select sqrt(price) from Products
select power(price,2) from Products
select price%5 from Products
select abs(min(price)-max(price)) from Products
select rand() 

select exp(min(price)) from  Products

select log(price) from Products

select ceiling(round((price-(price*0.15)),2)),floor(round((price-(price*0.15)),2)) from Products

--calculate the total amount spent by each customer

SELECT c.customer_name, SUM(o.TotalAmount) AS TotalAmountSpent
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name;

-- Find customer who have spent more than $1000 in total
select sum(TotalAmount) as TotalAMountSpent
from Orders
group by CustomerID
having sum(TotalAmount)>1000;

--Find product categories with more than 5 products
select count(ProductID) as Product_quantity, category
from Products
group by category
having COUNT(productID)>5;

--calculate the total number of products for each category and supplier combination

select category,SupplierID, COUNT(ProductID) as Number_of_Products from Products group by Category,SupplierID

--summarize total sales by product and customer and also provide overall total

--assuming the product_id present in product table and its prize present in order table

select p.product_id,sum(o.prize) as Sales_By_Product from Products p left join Orders o on p.order_id=o.Order_ID group by p.Product_ID,o.prize
union
select c.customer_id,sum(o.prize) as Sales_By_Customer from Customer c left join Orders o on c.order_id=o.Order_ID group by c.customer_id,o.prize
union
select sum(price) as OverallSales from Orders




--Stored procedure

create procedure getallproducts
as
begin
select * from Products
end

exec getallproducts


--giving parameters for stored procedure

create procedure getproductbyid
@productid int
as
begin 
select * from products where Product_ID =@productid;
end;

exec getproductbyid @productid=1;


-- giving two parameters

create procedure getproductsbycategoryandprice
@category varchar(50),
@minprice decimal (10,2)
as
begin
select * from products where category=@category and price >=@minprice;
end;
exec getproductsbycategoryandprice @category='Electronics',@minprice=500.00;


create procedure gettotalproductsincategory
@category varchar(50),
@totalproducts int output
as
begin
select @totalproducts =count(*)
from products where category =@category;
end;

declare @total int;
exec gettotalproductsincategory @ category ='Electronics',@totalproducts =@total output;
select @total as totalproductsincategory;

------------using try catch block


CREATE PROCEDURE ProcessOrder
@ProductID INT,
@Quantity INT,
@OrderDate DATE
AS
BEGIN
    BEGIN TRANSACTION;
    BEGIN TRY
       --Insert Order --
        INSERT INTO Orders (Product_ID, Quantity, OrderDate)
        VALUES (@ProductID, @Quantity, @OrderDate);
       -- Update Product Stock --
        UPDATE Products SET StockQuantity = StockQuantity - @Quantity
        WHERE Product_ID = @ProductID;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        -- You can handle errors here, such as logging or returning an error message --
        THROW;
    END CATCH;
END;


--or

CREATE PROCEDURE Processorder
@ProductID INT,
@Quantity INT,
@OrderDate DATE
AS
BEGIN
BEGIN TRANSACTION;
	BEGIN TRY
		--Insert order
		INSERT INTO Orders (Product_ID, Quantity, Order_Date) VALUES (@ProductID, @Quantity, @OrderDate);
		--(each time a order is placed, the quantity of the stock is reduced)
		--Update product stock
		UPDATE Products
		SET StockQuantity = StockQuantity- @Quantity 
		WHERE Product_ID = @ProductID;
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION;
		--You can handle errors here, such as logging or returning an error message
		THROW;
	END CATCH;
END;




CREATE PROCEDURE AdjustStock

@ProductID INT,

@Adjustment INT

AS

BEGIN

IF @Adjustment > 0

BEGIN

--Add to stock

UPDATE Products

SET StockQuantity = StockQuantity + @Adjustment WHERE ProductID = @ProductID;

END

ELSE IF @Adjustment < 0

BEGIN

--Subtract from stock

UPDATE Products

SET StockQuantity = StockQuantity + @Adjustment

WHERE ProductID = @ProductID;

END

END;

EXEC AdjustStock @ProductID = 1, @Adjustment = 5;

--Increase stock by 5 Decrease stock by 3

EXEC AdjustStock @ProductID = 1, @Adjustment = -3




--24-08-24


CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    PhoneNumber VARCHAR(15)
);

INSERT INTO Customers (CustomerID, FirstName, LastName, Email, PhoneNumber) VALUES
(1, 'amit', 'sharma', 'amit.sharma@example.com', '9876543210'),
(2, 'priya', 'mehta', 'priya.mehta@example.com', '8765432109'),
(3, 'rohit', 'kumar', 'rohit.kumar@example.com', '7654321098'),
(4, 'neha', 'verma', 'neha.verma@example.com', '6543210987'),
(5, 'siddharth', 'singh', 'siddharth.singh@example.com', '5432109876'),
(6, 'asha', 'rao', 'asha.rao@example.com', '4321098765');

--data cleaning 
UPDATE Customers
SET FirstName = LTRIM(RTRIM(LOWER(FirstName))),
LastName = LTRIM(RTRIM(LOWER(LastName)))

--to select the people with us formatted phone number

SELECT *

FROM Customers WHERE FirstName LIKE 'A%';

SELECT *

FROM Customers.

WHERE Phone Number LIKE '[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]';


--select lastnme it should contain only 5 letters

SELECT * FROM Customers WHERE LastName LIKE '_____'


==top
SELECT CustomerID, OrderID, TotalAmount,

SELECT TOP (1000) [OrderID]

[ProductID]

[OrderDate]

[Quantity]

[TotalAmount]

FROM [collage].[dbo].[Orders]

--artion using cust id .see ss in phn

SELECT CustomerID, OrderID, TotalAmount, SUM(TotalAmount) OVER (PARTITION BY Custome ID ORDER BY OrderDate) AS Running Total FROM Orders1;


--giving rank as 1,2,3 in output


SELECT CustomerID, TotalSales, RANK() OVER (ORDER BY TotalSales DESC) AS SalesRank FROM (

SELECT CustomerID, SUM (TotalAmount) AS TotalSales ~ FROM Orders1

GROUP BY CustomerID

) AS SalesData;




--CTE common table expression
--(CTE) in SQL is a temporary result set that you can reference within a SELECT, INSERT, UPDATE, 
--or DELETE statement. CTEs are often used to simplify complex queries by breaking them down into more manageable parts

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeName VARCHAR(100),
    ManagerID INT NULL
);

INSERT INTO Employees (EmployeeName, ManagerID)
VALUES 
('Amit Sharma', NULL),  -- Top manager
('Priya Mehta', 1),     -- Reports to Amit
('Rohit Kumar', 1),     -- Reports to Amit
('Neha Verma', 2),      -- Reports to Priya
('Siddharth Singh', 2), -- Reports to Priya
('Asha Rao', 3);        -- Reports to Rohit

INSERT INTO Employees (EmployeeName, ManagerID)
VALUES 
('Vikram Gupta', 4),  -- Reports to Neha
('Rajesh Patel', 5);  -- Reports to Siddharth


WITH RecursiveEmployeeCTE AS (

SELECT EmployeeID, ManagerID, EmployeeName

FROM Employees1

WHERE ManagerID IS NULL  --until this line is called anchor member or base case

UNION ALL

SELECT e. EmployeeID, e. ManagerID, e. EmployeeName

FROM Employees1 e

INNER JOIN RecursiveEmployeeCTE. r ON e. ManagerID = r. EmployeeID

)

SELECT * FROM RecursiveEmploye@CTE;



--cte eplanation

--The first part of a recursive CTE is called the anchor member.
--This is the non-recursive query that provides the initial result set, typically representing the base case in the recursion. It runs only once.


--The second part is the recursive member.It runs repeatedly, each time using the results from the previous iteration as input until no more rows are returned





--roll up  ROLLUP gives the grand total of the Totalsales done --ROLLUP is a SQL extension that allows you to create subtotals and grand totals for a set of columns in a result set

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    ProductID INT,
    Category VARCHAR(50),
    Amount DECIMAL(10, 2),
    SaleDate DATE
);
 
INSERT INTO Sales (SaleID, ProductID, Category, Amount, SaleDate) 
VALUES 
(1, 101, 'Electronics', 1500.00, '2024-01-15'),
(2, 102, 'Furniture', 800.00, '2024-01-16'),
(3, 103, 'Electronics', 2000.00, '2024-01-17'),
(4, 104, 'Electronics', 1200.00, '2024-02-01'),
(5, 105, 'Furniture', 900.00, '2024-02-03');

SELECT Category, SUM(Amount) AS TotalSales FROM Sales ~

GROUP BY ROLLUP (Category);


--corelated subquery


CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderAmount DECIMAL(10, 2),
    OrderDate DATE
);
 
INSERT INTO Orders (OrderID, CustomerID, OrderAmount, OrderDate)
VALUES 
(1, 1, 500.00, '2024-01-15'),
(2, 2, 700.00, '2024-01-16'),
(3, 1, 300.00, '2024-01-17'),
(4, 3, 1200.00, '2024-02-01'),
(5, 2, 900.00, '2024-02-03');


SELECT DISTINCT 01. CustomerID

FROM Orders2 01

WHERE (

SELECT COUNT(*)

FROM Orders2 02

WHERE 02.CustomerID = 01.CustomerID

) > 1;


--view,materialized view,schema binding

CREATE TABLE ProductSales (
    SaleID INT PRIMARY KEY,
    ProductID INT,
    Amount DECIMAL(10, 2),
    SaleDate DATE
);
 
INSERT INTO ProductSales (SaleID, ProductID, Amount, SaleDate)
VALUES 
(1, 101, 1500.00, '2024-01-15'),
(2, 102, 800.00, '2024-01-16'),
(3, 103, 2000.00, '2024-01-17'),
(4, 104, 1200.00, '2024-02-01'),
(5, 105, 900.00, '2024-02-03');

CREATE VIEW TotalSales By Product WITH SCHEMABINDING

AS

SELECT ProductID, SUM (Amount) AS TotalSales FROM dbo.ProductSales GROUP BY ProductID;

select * from TotalSalesByProduct

