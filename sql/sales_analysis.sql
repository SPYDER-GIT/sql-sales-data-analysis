USE sales_analysis;

-- =====================================
-- 1. Total Revenue
-- =====================================

SELECT ROUND(SUM(`Sales`),2) AS total_revenue
FROM superstore;

-- =====================================
-- 2. Total Number of Orders
-- =====================================

SELECT COUNT(DISTINCT `Order ID`) AS total_orders
FROM superstore;

-- =====================================
-- 3. Total Customers
-- =====================================

SELECT COUNT(DISTINCT `Customer ID`) AS total_customers
FROM superstore;

-- =====================================
-- 4. Top 10 Customers by Revenue
-- =====================================

SELECT
    `Customer Name`,
    ROUND(SUM(`Sales`),2) AS total_sales
FROM superstore
GROUP BY `Customer Name`
ORDER BY total_sales DESC
LIMIT 10;

-- =====================================
-- 5. Top 10 Cities by Revenue
-- =====================================

SELECT
    City,
    ROUND(SUM(`Sales`),2) AS revenue
FROM superstore
GROUP BY City
ORDER BY revenue DESC
LIMIT 10;

-- =====================================
-- 6. Revenue by State
-- =====================================

SELECT
    State,
    ROUND(SUM(`Sales`),2) AS revenue
FROM superstore
GROUP BY State
ORDER BY revenue DESC;

-- =====================================
-- 7. Revenue by Region
-- =====================================

SELECT
    Region,
    ROUND(SUM(`Sales`),2) AS revenue
FROM superstore
GROUP BY Region
ORDER BY revenue DESC;

-- =====================================
-- 8. Category Performance
-- =====================================

SELECT
    Category,
    ROUND(SUM(`Sales`),2) AS revenue
FROM superstore
GROUP BY Category
ORDER BY revenue DESC;

-- =====================================
-- 9. Sub-Category Performance
-- =====================================

SELECT
    `Sub-Category`,
    ROUND(SUM(`Sales`),2) AS revenue
FROM superstore
GROUP BY `Sub-Category`
ORDER BY revenue DESC;

-- =====================================
-- 10. Most Popular Products
-- =====================================

SELECT
    `Product Name`,
    COUNT(*) AS times_sold
FROM superstore
GROUP BY `Product Name`
ORDER BY times_sold DESC
LIMIT 10;

-- =====================================
-- 11. Average Order Value
-- =====================================

SELECT
ROUND(
SUM(`Sales`) /
COUNT(DISTINCT `Order ID`),2
) AS average_order_value
FROM superstore;

-- =====================================
-- 12. Customer Lifetime Value
-- =====================================

SELECT
    `Customer Name`,
    COUNT(DISTINCT `Order ID`) AS orders,
    ROUND(SUM(`Sales`),2) AS lifetime_value
FROM superstore
GROUP BY `Customer Name`
ORDER BY lifetime_value DESC
LIMIT 20;

-- =====================================
-- 13. Sales by Segment
-- =====================================

SELECT
    Segment,
    ROUND(SUM(`Sales`),2) AS revenue
FROM superstore
GROUP BY Segment
ORDER BY revenue DESC;

-- =====================================
-- 14. Monthly Revenue Trend
-- =====================================

SELECT
    MONTH(STR_TO_DATE(`Order Date`,
    '%d-%m-%Y')) AS month,
    ROUND(SUM(`Sales`),2) AS revenue
FROM superstore
GROUP BY month
ORDER BY month;

-- =====================================
-- 15. Top Customers in Each Region
-- =====================================

WITH customer_sales AS
(
    SELECT
        Region,
        `Customer Name`,
        SUM(`Sales`) AS revenue,
        RANK() OVER(
            PARTITION BY Region
            ORDER BY SUM(`Sales`) DESC
        ) AS rnk
    FROM superstore
    GROUP BY Region, `Customer Name`
)

SELECT *
FROM customer_sales
WHERE rnk <= 5;

-- =====================================
-- 16. Running Revenue Analysis
-- =====================================

WITH daily_sales AS
(
SELECT
    STR_TO_DATE(`Order Date`,
    '%d-%m-%Y') AS order_date,
    SUM(`Sales`) AS revenue
FROM superstore
GROUP BY order_date
)

SELECT
    order_date,
    revenue,
    SUM(revenue)
    OVER(
        ORDER BY order_date
    ) AS cumulative_revenue
FROM daily_sales;