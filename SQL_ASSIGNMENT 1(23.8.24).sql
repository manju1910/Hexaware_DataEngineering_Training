--sql queries


--Manju S/23-8-24

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

--assuming the product_id present in product table and its price present in order table

select p.product_id,sum(o.price) as Sales_By_Product from Products p left join Orders o on p.order_id=o.Order_ID group by p.Product_ID,o.price
union
select c.customer_id,sum(o.price) as Sales_By_Customer from Customer c left join Orders o on c.order_id=o.Order_ID group by c.customer_id,o.price
union
select sum(price) as OverallSales from Orders


--Stored procedure

--Insert Operation
create procedure insertoperation11
@productid int,@product_name varchar(50),@price decimal(3,1)
as
begin 


INSERT INTO Products (product_id, product_name, price) VALUES
(@productid, @product_name, @price)
end;

exec insertoperation11 @productid=1,@product_name='SmartTV',@price=230.50;


--Delete operation
create procedure deleteoperation
@productid int,@productname varchar(50)
as
begin 
delete from products where Product_ID =@productid and Product_Name=@productname;
end;

exec deleteoperation @productid=2,@productname='Tablet';


--Update Operation
CREATE PROCEDURE Updateoperation
		@productid INT,
		@productname VARCHAR(100),
		@price DECIMAL(10,2)
AS
BEGIN 
update products set product_name=@productname where Product_ID=@productid and price=@price;
END;

exec Updateoperation @productname='Solar Watch',@productid=1,@price=230

---Retrieve all products from the Products table that belong to the category 'Electronics' and have a price greater than 500.
SELECT * FROM Products
WHERE Category ='Electronics' and Price >500;


---Calculate the total quantity of products sold from the Orders table.
SELECT sum(Quantity) AS TotalQuantity
FROM Products


---Calculate the total revenue generated for each product in the Orders table.
SELECT Sum(Amount) AS totalAmount, ProductID, Category
FROM Products
Group by ProductID;


---Write a query that uses WHERE, GROUP BY, HAVING, and ORDER BY clauses and explain the order of execution.
SELECT ProductID, sum(Price)AS TotalRevenue
From Products
Where Price >10000            
GROUP BY ProductID             
Having TotalRevenue > 20000     
ORDER BY TotalRevenue DESC;     


---Write a query that corrects a violation of using non-aggregated columns without grouping them.
SELECT ProductID, SUM(TotalAmount) AS TotalRevenue
FROM Orders
GROUP BY ProductID;

---Retrieve all customers who have placed more than 5 orders using GROUP BY and HAVING clauses.
SELECT CustomerID,count(OrderID)
FROM Orders
GROUP BY CustomerID
having count(orderID) > 5;


---Create a stored procedure named GetAllCustomers that retrieves all customer details from the Customers table.
CREATE PROCEDURE GetAllCustomers
as 
begin
  select * from Customers
end;
exec GetAllCustomers;


---Create a stored procedure named GetOrderDetailsByOrderID that accepts an OrderID as a parameter and
---retrieves the order details for that specific order.
CREATE PROCEDURE GetOrderDetailsByOrderID
     @OrderID INT
AS
BEGIN
   SELECT * FROM Orders
   WHERE OrderID =@OrderID;
END;
EXEC GetOrderDetailsByOrderID @OrderID =2;


---Create a stored procedure named GetProductsByCategoryAndPrice that accepts a product Category and 
---a minimum Price as input parameters and retrieves all products that meet the criteria.
CREATE PROCEDURE GetProductsByCategoryAndPrice
       @Category Varchar(50),
	   @MinPrice Decimal(10,2)
AS
BEGIN
   SELECT * FROM Products
   Where Category = @Category AND Price > @MinPrice;
END;
EXEC GetProductsByCategoryAndPrice @Category='Electronics', @MinPrice = 12000.00


---Create a stored procedure named InsertNewProduct that accepts parameters for ProductName, Category, Price, and 
---StockQuantity and inserts a new product into the Products table.
CREATE PROCEDURE InsertNewProduct
	@ProductName VARCHAR(50),
	@Category VARCHAR(50),
	@Price DECIMAL(10,2),
	@StockQuantity INT
AS
BEGIN
      insert into Products(ProductName,Category,Price,StockQuantity)
	  Values(@ProductName,@Category,@Price,@StockQuantity);
END;
EXEC InsertNewProduct @ProductName='JoyStick',@Category='Electronics',@Price=7000.00,@StockQuantity=9;


---Create a stored procedure named UpdateCustomerEmail that accepts a CustomerID and 
---a NewEmail parameter and updates the email address for the specified customer.
CREATE PROCEDURE UpdateCustomerEmail
  @CustomerID int,
  @NewEmail VARCHAR(100)
AS
BEGIN
  update Customers
  set Email= @NewEmail
  where CustomerID= @CustomerID
END;
EXEC UpdateCustomerEmail @CustomerID =6,@NewEmail='asha.rao14@gmail.com';


---Create a stored procedure named DeleteOrderByID that accepts an OrderID as a parameter and 
---deletes the corresponding order from the Orders table.
CREATE PROCEDURE DeleteOrderByID
  @OrderID int
AS
BEGIN
  DELETE from Orders
  where OrderID=@OrderID;
END;
exec DeleteOrderByID @OrderID=2;


---Create a stored procedure named GetTotalProductsInCategory that accepts a Category parameter and 
---returns the total number of products in that category using an output parameter.
CREATE PROCEDURE GetTotalProductsInCategory
  @category int,
  @TotalProducts int output
as 
begin
  select TotalProducts= count(*) from Products
  where category=@category;
end;
DECLARE @Total INT;
EXEC GetTotalProductsInCategory @Category = 'Furniture', @TotalProducts = @Total OUTPUT;
SELECT @Total AS GetTotalProductsInCategory;