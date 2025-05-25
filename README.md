# Relational Database Design and Querying for Product Inventory Management & Billing Syatem 

## Project Overview

The `INVENTORYDB` serves as a robust backend for managing products, categories, suppliers, customers, purchase orders, and sales within an inventory ecosystem. The SQL script provides a practical demonstration of designing a normalized database structure, populating it with sample data, and executing a wide range of SQL commands to extract meaningful insights and maintain data integrity. It's an excellent resource for learning and demonstrating SQL proficiency in a business context.

## Database Schema Design (DDL)

The database schema is meticulously designed to ensure data integrity and efficient retrieval, comprising the following tables:

  * **`ProductCategories`**: Manages distinct product categories, ensuring uniqueness and providing a hierarchical structure for products.

      * `CategoryID` (Primary Key, `INT`, `AUTO_INCREMENT`)
      * `CategoryName` (`VARCHAR(100)`, `NOT NULL`, `UNIQUE`)

  * **`Products`**: Stores detailed information about each product, including pricing, stock levels, and categorization.

      * `ProductID` (Primary Key, `INT`, `AUTO_INCREMENT`)
      * `ProductName` (`VARCHAR(255)`, `NOT NULL`)
      * `CostPrice` (`DECIMAL(10, 2)`, `NOT NULL`, `CHECK (CostPrice >= 0)`)
      * `SellingPrice` (`DECIMAL(10, 2)`, `NOT NULL`, `CHECK (SellingPrice >= 0)`)
      * `StockQuantity` (`INT`, `NOT NULL`, `DEFAULT 0`, `CHECK (StockQuantity >= 0)`)
      * `CategoryID` (`INT`, Foreign Key referencing `ProductCategories`)
      * `ReorderLevel` (`INT`, `DEFAULT 5`)

  * **`Suppliers`**: Contains information about product suppliers.

      * `SupplierID` (Primary Key, `INT`, `AUTO_INCREMENT`)
      * `SupplierName` (`VARCHAR(150)`, `NOT NULL`)
      * `ContactNumber` (`VARCHAR(20)`)
      * `Email` (`VARCHAR(100)`, `UNIQUE`)

  * **`Customers`**: Stores customer demographic and contact details.

      * `CustomerID` (Primary Key, `INT`, `AUTO_INCREMENT`)
      * `FirstName` (`VARCHAR(100)`, `NOT NULL`)
      * `LastName` (`VARCHAR(100)`, `NOT NULL`)
      * `Email` (`VARCHAR(255)`, `UNIQUE`)
      * `PhoneNumber` (`VARCHAR(20)`)
      * `ShippingAddress` (`VARCHAR(255)`)

  * **`PurchaseOrders`**: Records details of orders placed with suppliers.

      * `PurchaseID` (Primary Key, `INT`, `AUTO_INCREMENT`)
      * `SupplierID` (`INT`, `NOT NULL`, Foreign Key referencing `Suppliers`)
      * `OrderDate` (`DATETIME`, `DEFAULT CURRENT_TIMESTAMP`)
      * `TotalAmount` (`DECIMAL(10, 2)`, `CHECK (TotalAmount >= 0)`)
      * `OrderStatus` (`VARCHAR(50)`, `DEFAULT 'Pending'`)

  * **`PurchaseDetails`**: Itemized breakdown of each `PurchaseOrder`.

      * `PurchaseDetailID` (Primary Key, `INT`, `AUTO_INCREMENT`)
      * `PurchaseID` (`INT`, `NOT NULL`, Foreign Key referencing `PurchaseOrders`)
      * `ProductID` (`INT`, `NOT NULL`, Foreign Key referencing `Products`)
      * `Quantity` (`INT`, `NOT NULL`, `CHECK (Quantity > 0)`)
      * `UnitPrice` (`DECIMAL(10, 2)`, `NOT NULL`, `CHECK (UnitPrice >= 0)`)
      * `Subtotal` (`DECIMAL(10, 2)`, `GENERATED ALWAYS AS (Quantity * UnitPrice) VIRTUAL`)

  * **`Sales`**: Records details of customer sales transactions.

      * `SaleID` (Primary Key, `INT`, `AUTO_INCREMENT`)
      * `CustomerID` (`INT`, `NOT NULL`, Foreign Key referencing `Customers`)
      * `SaleDate` (`DATETIME`, `DEFAULT CURRENT_TIMESTAMP`)
      * `TotalAmount` (`DECIMAL(10, 2)`, `CHECK (TotalAmount >= 0)`)
      * `SaleStatus` (`VARCHAR(50)`, `DEFAULT 'Processing'`)

  * **`SaleItems`**: Itemized breakdown of each `Sales` transaction.

      * `SaleItemID` (Primary Key, `INT`, `AUTO_INCREMENT`)
      * `SaleID` (`INT`, `NOT NULL`, Foreign Key referencing `Sales`)
      * `ProductID` (`INT`, `NOT NULL`, Foreign Key referencing `Products`)
      * `Quantity` (`INT`, `NOT NULL`, `CHECK (Quantity > 0)`)
      * `UnitPrice` (`DECIMAL(10, 2)`, `NOT NULL`, `CHECK (UnitPrice >= 0)`)
      * `Subtotal` (`DECIMAL(10, 2)`, `GENERATED ALWAYS AS (Quantity * UnitPrice) VIRTUAL`)

## Data Manipulation Operations (DML)

The script provides examples of fundamental DML operations:

  * **Data Insertion**: Populating all defined tables with diverse sample records to simulate a real-world inventory scenario.
  * **Data Updates**: Demonstrating various `UPDATE` statements, including:
      * Modifying product stock levels and selling prices.
      * Adjusting reorder levels based on stock quantity and category.
      * Updating purchase order and sales statuses.
      * Correcting supplier email addresses and standardizing customer shipping addresses.
  * **Data Deletion**: Removing product records where `StockQuantity` falls below the `ReorderLevel`.
  * **Transaction Management**: Illustrating the use of `START TRANSACTION`, `LOCK TABLES`, and `COMMIT` for ensuring data consistency during concurrent updates, such as transferring stock between products.

## Advanced SQL Querying Techniques

The SQL script includes a rich collection of queries demonstrating various advanced SQL capabilities for data retrieval and analysis:

### Data Retrieval and Filtering

  * **Basic Selection**: `SELECT *` to retrieve all columns.
  * **Specific Column Selection**: `SELECT` desired columns with `WHERE` clauses for conditional filtering.
  * **Conditional Filtering**: Utilizing `BETWEEN`, `IN`, `IS NULL`, and `LIKE` for precise data subsetting.
  * **Combined Filters**: Employing `AND`, `OR`, and `NOT` operators for complex logical conditions.
  * **Limiting Results**: Using `LIMIT` to fetch a specified number of top records.

### Sorting, Uniqueness, and Pagination

  * **Distinct Values**: Retrieving unique entries from columns using `DISTINCT`.
  * **Ordering Results**: Sorting data in ascending or descending order with `ORDER BY`.
  * **Pagination**: Implementing `LIMIT` and `OFFSET` for efficient retrieval of data pages.

### Aggregate Functions and Grouping

  * **Statistical Aggregation**: Demonstrating `COUNT`, `SUM`, `AVG`, `MIN`, and `MAX` for summarizing data.
  * **Grouped Aggregation**: Using `GROUP BY` to perform aggregations on categorized data (e.g., number of products per category).
  * **Filtered Groups**: Applying `HAVING` to filter results of `GROUP BY` clauses.

### Complex Joins

  * **INNER JOIN**: Combining rows from multiple tables based on matching column values.
  * **LEFT JOIN**: Retrieving all records from the left table and matched records from the right table.
  * **RIGHT JOIN**: Retrieving all records from the right table and matched records from the left table.
  * **Multi-Table Joins**: Constructing queries that join three or more tables to generate comprehensive reports (e.g., sales reports detailing customer and product information).

### Subqueries

  * **Subquery in `WHERE`**: Filtering results based on a condition derived from another query's output.
  * **Subquery in `FROM` (Derived Tables)**: Using the result of a subquery as a temporary table for further operations.
  * **Correlated Subqueries**: Executing a subquery dependent on the outer query's rows for row-by-row comparison.

### String Manipulation

  * **Concatenation**: Combining multiple string columns using `CONCAT()`.
  * **Case Conversion**: Converting strings to uppercase with `UPPER()`.
  * **Substring Extraction**: Extracting portions of strings using `SUBSTRING()`.
  * **Text Replacement**: Substituting specific text within strings using `REPLACE()`.
  * **String Reversal**: Reversing string order with `REVERSE()`.

### Date and Time Operations

  * **Component Extraction**: Extracting `YEAR`, `MONTH`, and `DAY` from date fields.
  * **Current Date/Time**: Retrieving current system date and time using `NOW()`, `CURDATE()`, and `CURTIME()`.
  * **Date Difference**: Calculating the difference between two dates with `DATEDIFF()`.
  * **Date Arithmetic**: Adding intervals to dates using `DATE_ADD()`.

### Conditional Logic with CASE Statements

  * **Value-based Labeling**: Assigning descriptive labels based on column values (e.g., `StockStatus` based on `StockQuantity`).
  * **Dynamic Ordering**: Implementing `CASE` within `ORDER BY` clauses to define conditional sorting logic.

## Database Views

The script defines SQL `VIEW`s to simplify complex queries and enhance data accessibility for reporting and public consumption:

  * **`TopCustomers`**: A view summarizing total sales per customer, ordered by sales amount, useful for identifying high-value clients.
  * **`PublicProductList`**: A simplified view of product information (name, price, stock, category) suitable for public-facing reports or applications.

## Usage

To utilize this SQL script:

1.  **Database Environment**: Ensure you have a MySQL database server configured.
2.  **Execution**: Run the `Inventory project 1.sql` script within your MySQL client (e.g., MySQL Workbench, command-line client). This will:
      * Create the `INVENTORYDB` database.
      * Define all necessary tables with their respective columns, constraints, and relationships.
      * Populate the tables with sample data.
      * Execute various DML operations and query examples.
3.  **Exploration**: Explore the created database and experiment with the provided queries to understand the schema and data interactions. Adapt the queries or create new ones to suit specific inventory management analysis needs.
