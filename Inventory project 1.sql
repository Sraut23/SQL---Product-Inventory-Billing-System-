CREATE DATABASE INVENTORYDB;
USE INVENTORYDB;

-- Table: Categories
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY AUTO_INCREMENT,
    CategoryName VARCHAR(100) NOT NULL UNIQUE
);

-- Table: Products
CREATE TABLE Products (
    ProductID INT PRIMARY KEY AUTO_INCREMENT,
    ProductName VARCHAR(200) NOT NULL,
    Barcode VARCHAR(50) UNIQUE,
    CostPrice DECIMAL(10, 2) NOT NULL CHECK (CostPrice >= 0),
    SellingPrice DECIMAL(10, 2) NOT NULL CHECK (SellingPrice >= 0),
    StockQuantity INT NOT NULL DEFAULT 0 CHECK (StockQuantity >= 0),
    CategoryID INT,
    ReorderLevel INT DEFAULT 5,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

-- Table: Suppliers
CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY AUTO_INCREMENT,
    SupplierName VARCHAR(150) NOT NULL,
    ContactNumber VARCHAR(15),
    Email VARCHAR(100) UNIQUE
);

-- Table: Customers
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    Email VARCHAR(255) UNIQUE,
    PhoneNumber VARCHAR(20),
    ShippingAddress VARCHAR(255)
);

-- Table: PurchaseOrders
CREATE TABLE PurchaseOrders (
    PurchaseID INT PRIMARY KEY AUTO_INCREMENT,
    SupplierID INT NOT NULL,
    OrderDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    TotalAmount DECIMAL(10, 2) CHECK (TotalAmount >= 0),
    OrderStatus VARCHAR(50) DEFAULT 'Pending',
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

-- Table: PurchaseDetails
CREATE TABLE PurchaseDetails (
    PurchaseDetailID INT PRIMARY KEY AUTO_INCREMENT,
    PurchaseID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    UnitPrice DECIMAL(10, 2) NOT NULL CHECK (UnitPrice >= 0),
    Subtotal DECIMAL(10, 2) GENERATED ALWAYS AS (Quantity * UnitPrice) VIRTUAL,
    FOREIGN KEY (PurchaseID) REFERENCES PurchaseOrders(PurchaseID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Table: Sales
CREATE TABLE Sales (
    SaleID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT NOT NULL,
    SaleDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    TotalAmount DECIMAL(10, 2) CHECK (TotalAmount >= 0),
    SaleStatus VARCHAR(50) DEFAULT 'Processing',
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Table: SaleItems
CREATE TABLE SaleItems (
    SaleItemID INT PRIMARY KEY AUTO_INCREMENT,
    SaleID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    UnitPrice DECIMAL(10, 2) NOT NULL CHECK (UnitPrice >= 0),
    Subtotal DECIMAL(10, 2) GENERATED ALWAYS AS (Quantity * UnitPrice) VIRTUAL,
    FOREIGN KEY (SaleID) REFERENCES Sales(SaleID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Modify ProductName column (increase size)
ALTER TABLE Products
MODIFY COLUMN ProductName VARCHAR(255) NOT NULL;

-- Modify ContactNumber column (increase size)
ALTER TABLE Suppliers
MODIFY COLUMN ContactNumber VARCHAR(20);

ALTER TABLE Products
DROP COLUMN Barcode;

RENAME TABLE Categories TO ProductCategories;

-- Q2  Data Insertion & Manipulation (DML)

INSERT INTO ProductCategories (CategoryName) VALUES
('Electronic'),
('Clothing'),
('Home & Kitchen'),
('Health & Beauty'),
('Toys & Games');

INSERT INTO Products (ProductName, CostPrice, SellingPrice, StockQuantity, CategoryID, ReorderLevel) VALUES
('Smartphone A1', 250.00, 300.00, 50, 1, 10),
('Smartwatch X', 120.00, 150.00, 40, 1, 10),
('Laptop Pro 15', 600.00, 800.00, 20, 1, 5),
('Bluetooth Speaker', 35.00, 50.00, 30, 1, 10),
('Wireless Earbuds', 40.00, 65.00, 35, 1, 15),

('T-Shirt Blue', 5.00, 10.00, 100, 2, 20),
('Jeans Slim Fit', 20.00, 35.00, 80, 2, 15),
('Jacket Waterproof', 35.00, 60.00, 25, 2, 10),
('Sneakers', 25.00, 45.00, 30, 2, 10),
('Hoodie Grey', 15.00, 28.00, 50, 2, 15),

('Blender', 30.00, 55.00, 35, 3, 10),
('Electric Kettle', 18.00, 30.00, 22, 3, 10),
('Frying Pan 12"', 15.00, 28.00, 20, 3, 10),
('Microwave Oven', 90.00, 130.00, 10, 3, 5),
('Water Bottle', 2.00, 3.50, 150, 3, 40),

('Protein Bar Pack', 15.00, 25.00, 60, 4, 20),
('Shampoo 500ml', 3.00, 6.00, 200, 4, 50),
('Face Wash', 2.50, 5.00, 180, 4, 50),
('Toothpaste Pack', 1.00, 2.50, 300, 4, 60),
('Vitamins Bottle', 5.00, 9.00, 120, 4, 40),

('Toy Car', 4.00, 8.00, 70, 5, 20),
('Board Game - Chess', 8.00, 14.00, 25, 5, 10),
('Building Blocks Set', 10.00, 18.00, 30, 5, 10),
('Plush Bear', 6.00, 12.00, 50, 5, 20),
('RC Helicopter', 22.00, 40.00, 15, 5, 5);

INSERT INTO Suppliers (SupplierName, ContactNumber, Email) VALUES
('Tech Solutions Inc.', '9876543210', 'info@techsolutions.com'),
('Fashion Forward Ltd.', '8765432109', 'sales@fashionforward.com'),
('Novel Reads Co.', '7654321098', 'orders@novelreads.com'),
('Home Essentials Corp.', '6543210987', 'contact@homeessentials.com'),
('Fresh Foods Depot', '5432109876', 'delivery@freshfoods.com');

INSERT INTO Customers (FirstName, LastName, Email, PhoneNumber, ShippingAddress) VALUES
('Aarav', 'Sharma', 'aarav.sharma@gmail.com', '91-9876543210', '101, MG Road, Bangalore, India'),
('Priya', 'Verma', 'priya.verma@gmail.com', '91-9988776655', '22, Linking Road, Mumbai, India'),
('Rahul', 'Gupta', 'rahul.gupta@gmail.com', '91-9876123456', '45, Park Street, Kolkata, India'),
('Anika', 'Patel', 'anika.patel@gmail.com', '91-9988456789', '67, Ashram Road, Ahmedabad, India'),
('Arjun', 'Reddy', 'arjun.reddy@gmail.com', '91-9876567890', '89, Jubilee Hills, Hyderabad, India'),
('Diya', 'Nair', 'diya.nair@gmail.com', '91-9988123456', '12, Church Street, Chennai, India'),
('Kiran', 'Singh', 'kiran.singh@gmail.com', '91-9876234567', '34, Sector 17, Chandigarh, India'),
('Meera', 'Joshi', 'meera.joshi@gmail.com', '91-9988567890', '56, MG Road, Pune, India'),
('Rohan', 'Mehta', 'rohan.mehta@gmail.com', '91-9876345678', '78, Civil Lines, Delhi, India'),
('Sneha', 'Khan', 'sneha.khan@gmail.com', '91-9988678901', '90, Frazer Road, Patna, India'),
('Vikram', 'Kumar', 'vikram.kumar@gmail.com', '91-9876456789', '21, Residency Road, Lucknow, India'),
('Ishita', 'Das', 'ishita.das@gmail.com', '91-9988789012', '43, GS Road, Guwahati, India'),
('Siddharth', 'Soni', 'siddharth.soni@gmail.com', '91-9876789012', '65, C Scheme, Jaipur, India'),
('Aishwarya', 'Krishnan', 'aishwarya.krishnan@gmail.com', '91-9988890123', '87, MG Road, Kochi, India'),
('Gaurav', 'Yadav', 'gaurav.yadav@gmail.com', '91-9876890123', '109, Ring Road, Indore, India'),
('Tanvi', 'Sharma', 'tanvi.sharma@gmail.com', '91-9988901234', '121, SP Mukherjee Road, Kolkata, India'),
('Manish', 'Verma', 'manish.verma@gmail.com', '91-9876901234', '133, Anna Salai, Chennai, India'),
('Deepika', 'Gupta', 'deepika.gupta@gmail.com', '91-9988012345', '145, MG Road, Bangalore, India'),
('Rajeev', 'Patel', 'rajeev.patel@gmail.com', '91-9876012345', '157, Navrangpura, Ahmedabad, India'),
('Pooja', 'Reddy', 'pooja.reddy@gmail.com', '91-9988123456', '169, Banjara Hills, Hyderabad, India'),
('Sandeep', 'Nair', 'sandeep.nair@gmail.com', '91-9876123456', '181, Marine Drive, Mumbai, India'),
('Shweta', 'Singh', 'shweta.singh@gmail.com', '91-9988234567', '193, Sector 17, Chandigarh, India'),
('Ankit', 'Joshi', 'ankit.joshi@gmail.com', '91-9876234567', '205, FC Road, Pune, India'),
('Ritu', 'Mehta', 'ritu.mehta@gmail.com', '91-9988345678', '217, Connaught Place, Delhi, India'),
('Kamal', 'Khan', 'kamal.khan@gmail.com', '91-9876345678', '229, Boring Canal Road, Patna, India');

INSERT INTO PurchaseOrders (SupplierID, OrderDate, TotalAmount, OrderStatus) VALUES
(1, '2024-01-15 10:00:00', 1250.00, 'Pending'),
(2, '2024-01-16 14:30:00', 800.00, 'Processing'),
(3, '2024-01-17 09:15:00', 2000.00, 'Shipped'),
(4, '2024-01-18 11:00:00', 550.00, 'Delivered'),
(5, '2024-01-19 16:45:00', 1500.00, 'Pending'),
(1, '2024-01-22 08:00:00', 950.00, 'Processing'),
(2, '2024-01-23 13:00:00', 1200.00, 'Shipped'),
(3, '2024-01-24 10:30:00', 3000.00, 'Delivered'),
(4, '2024-01-25 15:00:00', 750.00, 'Pending'),
(5, '2024-01-26 12:15:00', 1800.00, 'Processing'),
(1, '2024-01-29 09:00:00', 1100.00, 'Shipped'),
(2, '2024-01-30 14:00:00', 1000.00, 'Delivered'),
(3, '2024-01-31 11:45:00', 2500.00, 'Pending'),
(4, '2024-02-01 16:00:00', 600.00, 'Processing'),
(5, '2024-02-02 13:30:00', 1650.00, 'Shipped'),
(1, '2024-02-05 10:00:00', 1300.00, 'Delivered'),
(2, '2024-02-06 15:00:00', 850.00, 'Pending'),
(3, '2024-02-07 12:30:00', 2200.00, 'Processing'),
(4, '2024-02-08 17:00:00', 500.00, 'Shipped'),
(5, '2024-02-09 14:15:00', 1400.00, 'Delivered'),
(1, '2024-02-12 11:00:00', 1200.00, 'Pending'),
(2, '2024-02-13 16:00:00', 900.00, 'Processing'),
(3, '2024-02-14 13:45:00', 2700.00, 'Shipped'),
(4, '2024-02-15 18:00:00', 700.00, 'Delivered');

INSERT INTO PurchaseDetails (PurchaseID, ProductID, Quantity, UnitPrice) VALUES
(1, 1, 10, 250.00),
(1, 2, 5, 120.00),
(2, 3, 2, 600.00),
(2, 4, 10, 35.00),
(3, 5, 20, 40.00),
(3, 6, 30, 5.00),
(4, 7, 15, 20.00),
(4, 8, 5, 35.00),
(5, 9, 10, 25.00),
(5, 10, 20, 15.00),
(6, 11, 5, 30.00),
(6, 12, 7, 18.00),
(7, 13, 8, 15.00),
(7, 14, 2, 90.00),
(8, 15, 50, 2.00),
(8, 16, 10, 15.00),
(9, 17, 60, 3.00),
(9, 18, 50, 2.50),
(10, 19, 100, 1.00),
(10, 20, 20, 5.00),
(11, 21, 5, 4.00),
(11, 22, 2, 8.00),
(12, 23, 3, 10.00),
(12, 24, 4, 6.00),
(13, 25, 1, 22.00);

INSERT INTO Sales (CustomerID, SaleDate, TotalAmount, SaleStatus) VALUES
(1, '2024-02-01 10:00:00', 350.00, 'Processing'),
(2, '2024-02-02 14:30:00', 200.00, 'Shipped'),
(3, '2024-02-03 09:15:00', 850.00, 'Delivered'),
(4, '2024-02-04 11:00:00', 150.00, 'Completed'),
(5, '2024-02-05 16:45:00', 400.00, 'Returned'),
(6, '2024-02-08 08:00:00', 280.00, 'Processing'),
(7, '2024-02-09 13:00:00', 600.00, 'Shipped'),
(8, '2024-02-10 10:30:00', 1200.00, 'Delivered'),
(9, '2024-02-11 15:00:00', 300.00, 'Completed'),
(10, '2024-02-12 12:15:00', 700.00, 'Returned'),
(11, '2024-02-15 09:00:00', 320.00, 'Processing'),
(12, '2024-02-16 14:00:00', 550.00, 'Shipped'),
(13, '2024-02-17 11:45:00', 1000.00, 'Delivered'),
(14, '2024-02-18 16:00:00', 200.00, 'Completed'),
(15, '2024-02-19 13:30:00', 450.00, 'Returned'),
(16, '2024-02-22 10:00:00', 380.00, 'Processing'),
(17, '2024-02-23 15:00:00', 220.00, 'Shipped'),
(18, '2024-02-24 12:30:00', 900.00, 'Delivered'),
(19, '2024-02-25 17:00:00', 275.00, 'Completed'),
(20, '2024-02-26 14:15:00', 650.00, 'Returned'),
(21, '2024-03-01 11:00:00', 330.00, 'Processing'),
(22, '2024-03-02 16:00:00', 575.00, 'Shipped'),
(23, '2024-03-03 13:45:00', 1100.00, 'Delivered'),
(24, '2024-03-04 18:00:00', 225.00, 'Completed');

INSERT INTO SaleItems (SaleID, ProductID, Quantity, UnitPrice) VALUES
(1, 1, 1, 300.00),
(1, 4, 1, 50.00),
(2, 2, 1, 150.00),
(2, 5, 1, 65.00),
(3, 3, 1, 800.00),
(3, 6, 5, 10.00),
(4, 7, 2, 35.00),
(4, 8, 1, 60.00),
(5, 9, 3, 45.00),
(5, 10, 1, 28.00),
(6, 11, 1, 55.00),
(6, 12, 1, 30.00),
(7, 13, 2, 28.00),
(7, 14, 1, 130.00),
(8, 15, 10, 3.50),
(8, 16, 2, 25.00),
(9, 17, 15, 6.00),
(9, 18, 10, 5.00),
(10, 19, 20, 2.50),
(10, 20, 5, 9.00),
(11, 1, 1, 300.00),
(11, 2, 1, 150.00),
(12, 3, 1, 800.00),
(12, 4, 2, 50.00);

-- Update specific rows based on conditions 
UPDATE Products
SET StockQuantity = 55
WHERE ProductID = 1; 

UPDATE Products
SET SellingPrice = SellingPrice * 1.10
WHERE CategoryID = (SELECT CategoryID FROM ProductCategories WHERE CategoryName = 'Electronic');

UPDATE Products
SET ReorderLevel = 15
WHERE CategoryID = (
      SELECT CategoryID 
      FROM ProductCategories 
      WHERE CategoryName = 'Electronic'
    )
  AND StockQuantity < 20;
  
UPDATE PurchaseOrders
SET OrderStatus = 'Processing'
WHERE OrderStatus = 'Pending'
  AND OrderDate < '2024-01-20';
  
UPDATE Suppliers
SET Email = 'support@techsolutions.com'
WHERE SupplierName = 'Tech Solutions Inc.';

UPDATE Sales
SET SaleStatus = 'Completed'
WHERE SaleStatus = 'Processing'
  AND SaleDate < '2024-02-10';
  
UPDATE Products
SET SellingPrice = CostPrice * 1.20
WHERE SellingPrice < (CostPrice * 1.20);

UPDATE Customers
SET ShippingAddress = CONCAT(ShippingAddress, ', India')
WHERE ShippingAddress NOT LIKE '%, India';


-- Delete one or more record using conditions
DELETE FROM Products
WHERE StockQuantity < ReorderLevel;

-- Insert multiple rows using a single statement.
INSERT INTO Products (ProductName, CostPrice, SellingPrice, StockQuantity, CategoryID, ReorderLevel) VALUES
('Smart TV 55"', 450.00, 600.00, 15, 1, 5),
('Summer Dress', 12.00, 25.00, 120, 2, 30),
('Coffee Maker', 25.00, 45.00, 28, 3, 10);

-- use LOCK to control concurrent update

START TRANSACTION;
LOCK TABLES Products WRITE;

-- Get current stock of product 1 and 2
SELECT StockQuantity FROM Products WHERE ProductID = 1;
SELECT StockQuantity FROM Products WHERE ProductID = 2;

-- Transfer 10 units from product 1 to product 2
UPDATE Products SET StockQuantity = StockQuantity - 10 WHERE ProductID = 1;
UPDATE Products SET StockQuantity = StockQuantity + 10 WHERE ProductID = 2;

-- Verify new stock levels
SELECT StockQuantity FROM Products WHERE ProductID = 1;
SELECT StockQuantity FROM Products WHERE ProductID = 2;

UNLOCK TABLES;
COMMIT;

-- Q3. Select QUERIES & FILTERING 
-- Retrieve all data from the table.
SELECT * FROM Products;

-- Select specific columns with where conditions.
SELECT ProductName, SellingPrice
FROM Products
WHERE StockQuantity < 30;

-- Use BETWEEN, IN, IS NULL, LIKE for filtering:
SELECT * FROM Products WHERE SellingPrice BETWEEN 20 AND 50;

SELECT * FROM Products WHERE CategoryID IN (1, 3, 5);

SELECT * FROM Products WHERE ReorderLevel IS NULL;

SELECT * FROM Products WHERE ProductName LIKE 'S%';

-- Show top 5 records using LIMIT or sorted by a column
SELECT * FROM Products ORDER BY SellingPrice DESC LIMIT 5;

-- Combine filter using AND, OR , and NOT
SELECT *
FROM Products
WHERE CategoryID = 1 AND StockQuantity > 20;

-- NOT
SELECT * FROM Products WHERE NOT CategoryID = 2;

-- OR 

-- Q4. Sorting, Disting, and Pagination 

-- Display unique Values from a column using DISTINCT 
SELECT DISTINCT CategoryName FROM ProductCategories;
-- 2.
SELECT DISTINCT OrderStatus FROM PurchaseOrders;

-- Sort records in asc & des order using ORDER BY 
SELECT * FROM Products ORDER BY SellingPrice DESC;

-- Implement pagination using LIMIT And OFFSET 
SELECT * FROM Products ORDER BY ProductID LIMIT 10 OFFSET 10;

-- Q5. Aggregate Functions & Grouping
-- Use COUNT, SUM, AVG, MIN, MAX

SELECT COUNT(*) AS TotalProducts FROM Products;

SELECT SUM(StockQuantity) AS TotalStock FROM Products;

SELECT AVG(SellingPrice) AS AverageSellingPrice FROM Products;

-- Find the minimum and maximum selling prices
SELECT MIN(SellingPrice) AS MinPrice, MAX(SellingPrice) AS MaxPrice FROM products;

-- Group records by specific columns and apply aggregation

SELECT
    c.CategoryName,
    COUNT(p.ProductID) AS NumberOfProducts
FROM
    ProductCategories c
JOIN
    Products p ON c.CategoryID = p.CategoryID
GROUP BY
    c.CategoryName;

-- Filter groups using HAVING: 
SELECT
    c.CategoryName,
    COUNT(p.ProductID) AS NumberOfProducts
FROM
    ProductCategories c
JOIN
    Products p ON c.CategoryID = p.CategoryID
GROUP BY
    c.CategoryName
HAVING
    COUNT(p.ProductID) > 5;

-- Q6. JOINS

-- INNER JOIN: 
SELECT
    p.ProductID,
    p.ProductName,
    c.CategoryName
FROM
    Products p
INNER JOIN
    ProductCategories c ON p.CategoryID = c.CategoryID;

-- LEFT JOIN: 
SELECT
    c.CategoryName,
    COUNT(p.ProductID) AS NumberOfProducts
FROM
    ProductCategories c
LEFT JOIN
    Products p ON c.CategoryID = p.CategoryID

GROUP BY
    c.CategoryName;

-- RIGHT JOIN:
SELECT
    p.ProductName,
    s.SupplierName
FROM
    Products p
RIGHT JOIN PurchaseDetails pd ON p.ProductID = pd.ProductID
RIGHT JOIN PurchaseOrders po ON pd.PurchaseID = po.PurchaseID
RIGHT JOIN Suppliers s ON po.SupplierID = s.SupplierID;

-- Join three or more tables to produce a meaningful reports 
SELECT
    s.SaleID,
    c.FirstName,
    c.LastName,
    si.Quantity,
    p.ProductName
FROM
    Sales s
JOIN
    SaleItems si ON s.SaleID = si.SaleID
JOIN
    Products p ON si.ProductID = p.ProductID
JOIN Customers c ON s.CustomerID = c.CustomerID;

-- Q7. Subqueries
-- Subquery in WHERE: 
SELECT *
FROM Products
WHERE SellingPrice > (SELECT AVG(SellingPrice) FROM Products);

-- Subquery in FROM (Derived Table)
SELECT
    p.ProductName,
    p.StockQuantity
FROM
    (SELECT ProductID, ProductName, StockQuantity FROM Products) AS p
WHERE
    p.StockQuantity > 50;

-- Correlated Subquery
SELECT p.ProductName, p.CostPrice, c.CategoryName
FROM Products p
JOIN ProductCategories c ON p.CategoryID = c.CategoryID
WHERE p.CostPrice < (
    SELECT AVG(CostPrice)
    FROM Products
    WHERE CategoryID = p.CategoryID
);


-- Q8. STRING FUNCTION

-- Concatenate 
SELECT CONCAT(FirstName, ' ', LastName) AS FullName FROM Customers;

-- uppercase
SELECT UPPER(ProductName) FROM Products;

-- SUBSTRING
SELECT SUBSTRING(ProductName, 1, 5) FROM Products;

-- REPLACE
SELECT REPLACE(ProductName, 'Blue', 'Navy Blue') FROM Products;

-- REVERSE
SELECT REVERSE(ProductName) from Products;

-- Q9. DATE & TIME Function 
-- Extract year, month, and day 
SELECT
    SaleDate,
    YEAR(SaleDate) AS SaleYear,
    MONTH(SaleDate) AS SaleMonth,
    DAY(SaleDate) AS SaleDay
FROM Sales;

-- Get current date and time
SELECT NOW() AS CurrentDateTime, CURDATE() AS CurrentDate, CURTIME() AS CurrentTime;

-- Find the difference between two dates 
SELECT
    po1.OrderDate AS Order1Date,
    po2.OrderDate AS Order2Date,
    DATEDIFF(po2.OrderDate, po1.OrderDate) AS DateDifference
FROM
    PurchaseOrders po1
JOIN
    PurchaseOrders po2 ON po1.PurchaseID = 1 AND po2.PurchaseID = 2;

-- DATE ADD 
SELECT SaleDate, DATE_ADD(SaleDate, INTERVAL 7 DAY) AS SaleDatePlus7 FROM Sales;

-- Q10. Conditional Logic & Case

-- Use CASE to assign labels based on column values
SELECT
    ProductName,
    StockQuantity,
    CASE
        WHEN StockQuantity > 100 THEN 'High Stock'
        WHEN StockQuantity > 20 THEN 'Medium Stock'
        ELSE 'Low Stock'
    END AS StockStatus
FROM Products;

-- Use CASE in ORDER BY to dynamic logic
SELECT *
FROM Products
ORDER BY
    CASE
        WHEN CategoryID = 1 THEN SellingPrice  -- Sort Electronics by price
        ELSE ProductName                       -- Sort others by name
    END;
    
    
-- Q11. VIEWS

-- CREATE VIEW
CREATE VIEW TopCustomers AS
SELECT
    c.CustomerID,
    c.FirstName,
    c.LastName,
    SUM(s.TotalAmount) AS TotalSales
FROM
    Customers c
JOIN
    Sales s ON c.CustomerID = s.CustomerID
GROUP BY
    c.CustomerID, c.FirstName, c.LastName
ORDER BY
    TotalSales DESC;

-- Create a view for public reporting 
CREATE VIEW PublicProductList AS
SELECT
    ProductName,
    SellingPrice,
    StockQuantity,
    CategoryName
FROM
    Products p
JOIN ProductCategories pc ON p.CategoryID = pc.CategoryID;

-- Query the views 
SELECT * FROM TopCustomers LIMIT 5;
SELECT * FROM PublicProductList;




