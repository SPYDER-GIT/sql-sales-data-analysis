# SQL Sales Data Analysis Project

## Project Overview

This project analyzes retail sales data from the Superstore dataset using MySQL. The objective is to extract meaningful business insights related to revenue, customer behavior, product performance, and regional sales trends.

The analysis was performed using SQL queries involving aggregation functions, grouping, Common Table Expressions (CTEs), and window functions.

---

## Objectives

The project aims to answer the following business questions:

* What is the total revenue generated?
* How many customers and orders exist?
* Who are the highest-value customers?
* Which cities, states, and regions generate the most revenue?
* Which product categories perform best?
* What are the monthly sales trends?
* Which customers contribute most to each region?
* How does cumulative revenue grow over time?

---

## Dataset Information

Dataset: Superstore Sales Dataset

Source: Kaggle

Dataset Size:

* 9,800 records
* 18 columns

Columns:

| Column        |
| ------------- |
| Row ID        |
| Order ID      |
| Order Date    |
| Ship Date     |
| Ship Mode     |
| Customer ID   |
| Customer Name |
| Segment       |
| Country       |
| City          |
| State         |
| Postal Code   |
| Region        |
| Product ID    |
| Category      |
| Sub-Category  |
| Product Name  |
| Sales         |

---

## Tools Used

* MySQL Server
* MySQL Workbench
* SQL
* Git
* GitHub

---

## Skills Demonstrated

### SQL Fundamentals

* SELECT
* WHERE
* ORDER BY
* LIMIT
* DISTINCT

### Data Aggregation

* SUM()
* COUNT()
* ROUND()

### Grouping and Analysis

* GROUP BY
* HAVING

### Advanced SQL

* Common Table Expressions (CTEs)
* Window Functions
* RANK()
* OVER()

### Business Analytics

* Revenue Analysis
* Customer Segmentation
* Product Performance Analysis
* Regional Analysis
* Trend Analysis

---

## Database Setup

Create Database:

```sql
CREATE DATABASE sales_analysis;
USE sales_analysis;
```

Create Table:

```sql
CREATE TABLE superstore (
    `Row ID` INT,
    `Order ID` TEXT,
    `Order Date` TEXT,
    `Ship Date` TEXT,
    `Ship Mode` TEXT,
    `Customer ID` TEXT,
    `Customer Name` TEXT,
    `Segment` TEXT,
    `Country` TEXT,
    `City` TEXT,
    `State` TEXT,
    `Postal Code` INT,
    `Region` TEXT,
    `Product ID` TEXT,
    `Category` TEXT,
    `Sub-Category` TEXT,
    `Product Name` TEXT,
    `Sales` DOUBLE
);
```

Import Dataset:

```sql
LOAD DATA LOCAL INFILE 'train.csv'
INTO TABLE superstore
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
```

---

# Analysis Queries

## 1. Total Revenue

Business Question:

How much total revenue has the company generated?

```sql
SELECT ROUND(SUM(`Sales`),2) AS total_revenue
FROM superstore;
```

---

## 2. Total Number of Orders

Business Question:

How many unique orders were placed?

```sql
SELECT COUNT(DISTINCT `Order ID`) AS total_orders
FROM superstore;
```

---

## 3. Total Customers

Business Question:

How many unique customers purchased products?

```sql
SELECT COUNT(DISTINCT `Customer ID`) AS total_customers
FROM superstore;
```

---

## 4. Top 10 Customers by Revenue

Business Question:

Who are the most valuable customers?

```sql
SELECT
    `Customer Name`,
    ROUND(SUM(`Sales`),2) AS total_sales
FROM superstore
GROUP BY `Customer Name`
ORDER BY total_sales DESC
LIMIT 10;
```

---

## 5. Top 10 Cities by Revenue

Business Question:

Which cities contribute the most sales revenue?

```sql
SELECT
    City,
    ROUND(SUM(`Sales`),2) AS revenue
FROM superstore
GROUP BY City
ORDER BY revenue DESC
LIMIT 10;
```

---

## 6. Revenue by State

Business Question:

Which states generate the highest revenue?

```sql
SELECT
    State,
    ROUND(SUM(`Sales`),2) AS revenue
FROM superstore
GROUP BY State
ORDER BY revenue DESC;
```

---

## 7. Revenue by Region

Business Question:

Which geographical region performs best?

```sql
SELECT
    Region,
    ROUND(SUM(`Sales`),2) AS revenue
FROM superstore
GROUP BY Region
ORDER BY revenue DESC;
```

---

## 8. Category Performance

Business Question:

Which product categories generate the most revenue?

```sql
SELECT
    Category,
    ROUND(SUM(`Sales`),2) AS revenue
FROM superstore
GROUP BY Category
ORDER BY revenue DESC;
```

---

## 9. Sub-Category Performance

Business Question:

Which sub-categories perform best?

```sql
SELECT
    `Sub-Category`,
    ROUND(SUM(`Sales`),2) AS revenue
FROM superstore
GROUP BY `Sub-Category`
ORDER BY revenue DESC;
```

---

## 10. Most Popular Products

Business Question:

Which products are sold most frequently?

```sql
SELECT
    `Product Name`,
    COUNT(*) AS times_sold
FROM superstore
GROUP BY `Product Name`
ORDER BY times_sold DESC
LIMIT 10;
```

---

## 11. Average Order Value

Business Question:

What is the average revenue generated per order?

```sql
SELECT
ROUND(
SUM(`Sales`) /
COUNT(DISTINCT `Order ID`),2
) AS average_order_value
FROM superstore;
```

---

## 12. Customer Lifetime Value

Business Question:

How much revenue has each customer generated over their lifetime?

```sql
SELECT
    `Customer Name`,
    COUNT(DISTINCT `Order ID`) AS orders,
    ROUND(SUM(`Sales`),2) AS lifetime_value
FROM superstore
GROUP BY `Customer Name`
ORDER BY lifetime_value DESC
LIMIT 20;
```

---

## 13. Sales by Segment

Business Question:

Which customer segment contributes the most revenue?

```sql
SELECT
    Segment,
    ROUND(SUM(`Sales`),2) AS revenue
FROM superstore
GROUP BY Segment
ORDER BY revenue DESC;
```

---

## 14. Monthly Revenue Trend

Business Question:

How does revenue change throughout the year?

```sql
SELECT
    MONTH(STR_TO_DATE(`Order Date`,
    '%d-%m-%Y')) AS month,
    ROUND(SUM(`Sales`),2) AS revenue
FROM superstore
GROUP BY month
ORDER BY month;
```

---

## 15. Top Customers in Each Region

Business Question:

Who are the highest-performing customers within each region?

```sql
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
```

---

## 16. Running Revenue Analysis

Business Question:

How does cumulative revenue grow over time?

```sql
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
```

---

## Key Insights

* Identified top-performing customers by total revenue.
* Evaluated sales contribution by region, state, and city.
* Analyzed category and sub-category performance.
* Calculated customer lifetime value.
* Measured average order value.
* Created cumulative revenue analysis using window functions.
* Generated monthly revenue trends for business monitoring.

---

## Future Improvements

* Create Power BI Dashboard
* Build Tableau Visualizations
* Perform Customer Segmentation
* Add Profit Analysis
* Implement Sales Forecasting

---

## Author

Suraj Singh

SQL | Data Analytics | Business Intelligence
