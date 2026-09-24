-- ===========================================
-- create database 
-- ===========================================
CREATE DATABASE novamart;

use novamart;
-- ===========================================
-- Create table customers, order, products
-- =========================================== 
CREATE TABLE customers (
    Customer_ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100) NOT NULL,
    Phone VARCHAR(100) NOT NULL,
    City VARCHAR(100) NOT NULL,
    State VARCHAR(100) DEFAULT NULL,
    Country VARCHAR(100) NOT NULL,
    Signup_Date DATE NOT NULL,
    Gender VARCHAR(10) DEFAULT NULL,
    Age INT DEFAULT NULL
);

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    Product_Name VARCHAR(100) NOT NULL,
    Category VARCHAR(100) DEFAULT 'other',
    Sub_Category VARCHAR(100) DEFAULT 'other',
    Brand VARCHAR(100) DEFAULT 'other',
    Unit_Price DECIMAL(10 , 2 ) CHECK (Unit_Price > 0.0),
    Cost_Price DECIMAL(10 , 2 ) CHECK (Cost_Price > 0.0),
    Stock INT DEFAULT 0
);

CREATE TABLE orders (
    Order_ID INT PRIMARY KEY AUTO_INCREMENT,
    Customer_ID INT NOT NULL REFERENCES customer (customer_id),
    Product_ID INT NOT NULL REFERENCES customer (product_id),
    Order_Date DATE NOT NULL,
    Quantity INT NOT NULL,
    Unit_Price DECIMAL(10 , 2 ) CHECK (UNIT_PRICE > 0),
    Total_Amount DECIMAL(10 , 2 ) CHECK (Total_Amount > 0),
    Order_Status VARCHAR(100) DEFAULT 'Unknown',
    Payment_Method VARCHAR(100) DEFAULT 'Unknown'
);
-- Insert Data via import wizard !!! 
-- 1. Retrieve all products belonging to the "Electronics" category.
SELECT 
    *
FROM
    products
WHERE
    category = 'Electronics';
-- 2. Find all products with a Unit_Price greater than $500.
SELECT 
    *
FROM
    products
WHERE
    unit_price > 500;
-- 3. List all customers from the United States.
SELECT 
    *
FROM
    customers
WHERE
    country = 'United States';
-- 4. Show all orders placed in November 2024.
SELECT 
    *
FROM
    orders
WHERE
    Order_Date BETWEEN '2024-11-01' AND '2024-11-30';
-- 5. Calculate the total stock available across all products.
SELECT 
    SUM(stock) AS Total_Stock
FROM
    products;

-- 6. Find the details of the most expensive product.
SELECT 
    product_name, MAX(cost_price) AS cost_price
FROM
    products;
SELECT 
    product_name, MAX(unit_price) AS unit_price
FROM
    products;

-- 7. Show all orders where the customer ordered more than 3 quantity of a product.
SELECT 
    *
FROM
    orders
WHERE
    quantity > 3;
-- 8. Retrieve all orders where the Total_Amount exceeds $200.
SELECT 
    *
FROM
    orders
WHERE
    total_amount > 200;
-- 9. List all distinct categories and brands available in the Products table.
SELECT DISTINCT
    category
FROM
    products;
SELECT DISTINCT
    brand
FROM
    products;
-- 10. Find the product with the lowest stock.
SELECT 
    product_name, MIN(stock)
FROM
    products;

-- 11. Calculate the total revenue generated from all Completed and Shipped orders. 
SELECT 
    SUM(total_amount) AS Completed_Revenue
FROM
    orders
WHERE
    order_status = 'Completed';
SELECT 
    SUM(total_amount) AS Shipped_revenue
FROM
    orders
WHERE
    order_status = 'Shipped';

-- ===========================================
-- Section 2 Intermidiate
-- =========================================== 
-- 12. Find the total quantity sold and total revenue for each product category.
SELECT 
    p.Category,
    SUM(o.Quantity) AS Totla_Qty_Sold,
    SUM(o.Total_amount) AS total_revenue
FROM
    Orders o
        JOIN
    products p ON o.product_id = p.product_id
WHERE
    o.Order_Status IN ('completed' , 'Shiped')
GROUP BY p.Category
ORDER BY Total_revenue DESC;
-- 13. Calculate the average price of products in the "Clothing" category.
SELECT 
    AVG(cost_price) AS avg_price
FROM
    products
WHERE
    category = 'Clothing';
-- 14. List customers who have placed at least 3 orders.
SELECT 
    c.Name, c.Customer_id, COUNT(o.Order_ID) AS Total_Orders
FROM
    customers c
        JOIN
    orders o ON c.Customer_Id = o.Customer_Id
GROUP BY c.Customer_id , c.name
HAVING COUNT(o.Order_ID) > 3;

-- 15. Find the most frequently ordered product (by total quantity sold).
SELECT 
    p.product_id,
    p.product_name AS Product_name,
    SUM(o.Quantity) AS Total_Quantity_sold
FROM
    orders o
        JOIN
    Products p ON p.product_id = o.product_id
WHERE
    o.order_Status IN ('Completed' , 'Shipped')
GROUP BY p.Product_ID , p.product_name
ORDER BY Total_quantity_sold DESC
LIMIT 1;
-- 16. Show the Top 5 most expensive products in the Electronics category.
SELECT 
    Product_Name, Brand, Unit_price
FROM
    products
WHERE
    Category = 'Electronics'
ORDER BY Unit_price DESC
LIMIT 5;
-- 17. Calculate the total quantity sold by each Brand.
SELECT 
    p.Brand, SUM(o.Quantity) AS Total_Quantity_sold
FROM
    orders o
        JOIN
    products p ON p.product_id = o.product_id
WHERE
    o.order_status IN ('Completed' , 'Shipped')
GROUP BY p.Brand;
-- 18. List the cities of customers who have spent more than $300 in total.
SELECT 
    c.City, c.Name, SUM(o.Total_amount) AS Total_Amount_Spent
FROM
    customers c
        JOIN
    orders o ON c.customer_id = o.Customer_id
WHERE
    o.Order_status IN ('Completed' , 'Shipped')
GROUP BY c.city
HAVING SUM(o.total_amount) > 300
ORDER BY Total_Amount_Spent DESC;
-- 19. Find the customer who spent the most (highest lifetime value).
SELECT 
    c.Customer_ID,
    c.Name,
    c.Email,
    SUM(o.Total_Amount) AS Lifetime_Value
FROM
    Customers c
        JOIN
    Orders o ON c.Customer_ID = o.Customer_ID
WHERE
    o.Order_Status IN ('Completed' , 'Shipped')
GROUP BY c.Customer_ID , c.Name , c.Email
ORDER BY Lifetime_Value DESC
LIMIT 1;
-- 20. Calculate the remaining stock of each product after fulfilling all Completed/Shipped orders.
SELECT 
    p.Product_ID,
    p.Product_Name,
    p.Stock AS Initial_Stock,
    COALESCE(SUM(o.Quantity), 0) AS Total_Sold,
    (p.Stock - COALESCE(SUM(o.Quantity), 0)) AS Remaining_Stock
FROM
    Products p
        LEFT JOIN
    Orders o ON p.Product_ID = o.Product_ID
        AND o.Order_Status IN ('Completed' , 'Shipped')
GROUP BY p.Product_ID , p.Product_Name , p.Stock
ORDER BY Remaining_Stock ASC;

-- ===========================================
-- Section 3 Advance
-- =========================================== 

-- 21. Show the monthly revenue trend (Year-Month) for Completed and Shipped orders.
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS year_mnth,
    SUM(total_amount) AS monthly_revenue
FROM
    orders
WHERE
    order_status IN ('Completed' , 'Shipped')
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY year_mnth DESC;

-- 22. Calculate the revenue contribution percentage of each Category.
SELECT 
    p.category,
    SUM(o.total_amount) AS category_rev,
    ROUND(SUM(o.total_amount) / (SELECT 
                    SUM(total_amount)
                FROM
                    orders
                WHERE
                    order_status IN ('completed' , 'Shipped')) * 100,
            2) AS revenue_pct
FROM
    orders o
        JOIN
    products p ON p.product_id = o.product_id
WHERE
    o.order_status IN ('completed' , 'shipped')
GROUP BY p.Category;

-- 23. Calculate Gross Profit and Gross Margin % for each Category. (Profit = Total_Amount − Cost_Price × Quantity)
SELECT 
    p.category,
    ROUND(SUM(o.total_amount), 2) AS Total_Revenue,
    ROUND((SUM(o.total_amount - (p.cost_price * o.quantity))),
            2) AS gross_profit,
    ROUND((SUM(o.total_amount - (p.cost_price * o.quantity)) / SUM(o.total_amount)) * 100,
            2) AS gross_profit_pct
FROM
    orders o
        JOIN
    products p ON p.product_id = o.product_id
WHERE
    o.order_status IN ('Completed' , 'Shipped')
GROUP BY p.category;

-- 24. Find the Top 10 customers by total spend.
SELECT 
    c.name, SUM(o.total_amount) AS Total_Spent
FROM
    orders o
        JOIN
    customers c ON c.customer_id = o.customer_id
WHERE
    o.order_status IN ('Completed' , 'Shipped')
GROUP BY c.name
ORDER BY Total_Spent DESC
LIMIT 10;
-- 25. Calculate the cancellation rate by month.
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS mnth,
    COUNT(order_status) AS count_of_cancel
FROM
    orders
WHERE
    order_status IN ('Cancelled')
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY mnth;

-- 26. Find the best performing brand in each category (using ranking)
WITH brand_rank AS (
SELECT p.category,
p.brand,
SUM(o.total_amount) AS revenue,
RANK() OVER(PARTITION BY p.category ORDER BY SUM(o.total_amount) DESC) AS rnk

FROM orders o
JOIN products p
ON o.product_id = p.product_id
WHERE order_status IN ("completed","shipped")
GROUP BY p.category,p.brand
)

SELECT category,brand,revenue 
FROM brand_rank
where rnk =1
ORDER BY revenue DESC;

-- 27. Segment customers into High Value / Medium Value / Low Value based on total spending
WITH customer_spending AS (
SELECT c.name,c.customer_id,COALESCE(SUM(o.total_amount),0) AS total_spent
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
AND o.order_status IN ("completed","shipped")
GROUP BY c.name,c.customer_id
)
SELECT customer_id, name , total_spent,
CASE 
	WHEN total_spent >= 1000 THEN 'HIGH VALUE'
    WHEN total_spent >= 500 THEN 'Medium Value'
    ELSE 'LOW VALUE'
    END AS customer_segments
FROM customer_spending
ORDER BY total_spent DESC;

-- 28. Products at stock-out risk (high sales quantity + low current stock)
WITH productsales AS(
SELECT p.product_name, p.product_id,p.stock AS current_stock,COALESCE(SUM(o.quantity),0) as Total_sold
FROM products p
LEFT JOIN orders o
ON p.product_id = o.product_id
AND o.order_status IN ("completed","Shipped")
GROUP BY p.product_name,p.product_id
)
SELECT 
product_id,
product_name,
current_stock,
total_sold
from productsales
WHERE current_stock < 10
AND total_sold >(SELECT AVG(total_sold) FROM productsales)
ORDER BY current_stock ASC,Total_sold DESC;

-- 29. Analyze performance by Payment Method (orders, average order value, and total revenue)

SELECT 
    payment_method,
    ROUND(AVG(total_amount), 2) AS average_order_value,
    COUNT(order_id) AS total_order_placed,
    ROUND(SUM(total_amount), 2) AS total_revenue
FROM
    orders
WHERE
    order_status IN ('completed' , 'Shipped')
GROUP BY payment_method
ORDER BY total_revenue DESC;

-- 30. Calculate Month-over-Month revenue growth percentage.
WITH month_rev as (
SELECT 
date_format(order_date, "%y-%m") as yr_mnth,
sum(total_amount) as revenue 
FROM orders WHERE order_status IN ("Completed","Shipped")
GROUP BY yr_mnth

)

SELECT yr_mnth,revenue,
lag(revenue) over (ORDER BY yr_mnth) AS prev_month_rev,
round(100 * (revenue - lag(revenue) OVER (ORDER BY yr_mnth))
/nullif(lag(revenue) OVER (ORDER BY yr_mnth),0),2) as mnt_wise_pct
FROM month_rev;