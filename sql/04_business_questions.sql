-- E-commerce Sales Analysis
-- 04. The eleven business questions
--
-- Net revenue = sales minus cancellations.
-- Questions about orders use sales only (is_cancelled = 0).
-- December 2011 is left out of monthly questions because it stops on the 9th.

-- Q1. Revenue per month against the same month a year earlier
WITH monthly AS (
  SELECT year_month, SUM(revenue) AS net_revenue
  FROM sales
  WHERE year_month < '2011-12'
  GROUP BY year_month
)
SELECT year_month,
       ROUND(net_revenue) AS net_revenue,
       ROUND(LAG(net_revenue, 12) OVER (ORDER BY year_month)) AS same_month_last_year,
       ROUND(100.0 * (net_revenue - LAG(net_revenue, 12) OVER (ORDER BY year_month))
             / LAG(net_revenue, 12) OVER (ORDER BY year_month), 1) AS change_pct
FROM monthly
ORDER BY year_month;

-- Q2. The peak months (times_average 1.5 = one and a half times an average month)
WITH monthly AS (
  SELECT year_month, SUM(revenue) AS net_revenue
  FROM sales
  WHERE year_month < '2011-12'
  GROUP BY year_month
)
SELECT year_month,
       ROUND(net_revenue) AS net_revenue,
       ROUND(net_revenue / (SELECT AVG(net_revenue) FROM monthly), 2) AS times_average
FROM monthly
ORDER BY net_revenue DESC
LIMIT 5;

-- Q3. Share of sales value that is cancelled
SELECT ROUND(SUM(CASE WHEN is_cancelled = 0 THEN revenue ELSE 0 END)) AS gross_sales,
       ROUND(-SUM(CASE WHEN is_cancelled = 1 THEN revenue ELSE 0 END)) AS cancelled_value,
       ROUND(100.0 * -SUM(CASE WHEN is_cancelled = 1 THEN revenue ELSE 0 END)
             / SUM(CASE WHEN is_cancelled = 0 THEN revenue ELSE 0 END), 1) AS cancelled_pct
FROM sales;

-- Q4. Top 10 products by revenue
SELECT stock_code, MAX(description) AS product,
       ROUND(SUM(revenue)) AS net_revenue, SUM(quantity) AS units
FROM sales
GROUP BY stock_code
ORDER BY net_revenue DESC
LIMIT 10;

-- Q4b. Top 10 products by units, to compare with Q4
SELECT stock_code, MAX(description) AS product,
       ROUND(SUM(revenue)) AS net_revenue, SUM(quantity) AS units
FROM sales
GROUP BY stock_code
ORDER BY units DESC
LIMIT 10;

-- Q5. Share of revenue from the top 20% of products (NTILE(5): group 1 = top 20%)
WITH product AS (
  SELECT stock_code, SUM(revenue) AS net_revenue
  FROM sales
  GROUP BY stock_code
),
ranked AS (
  SELECT net_revenue, NTILE(5) OVER (ORDER BY net_revenue DESC) AS fifth
  FROM product
)
SELECT ROUND(100.0 * SUM(CASE WHEN fifth = 1 THEN net_revenue ELSE 0 END)
             / SUM(net_revenue), 1) AS top_20_pct_share
FROM ranked;

-- Q6. Products cancelled most
SELECT stock_code, MAX(description) AS product,
       COUNT(*) AS cancelled_lines,
       ROUND(-SUM(revenue)) AS cancelled_value
FROM sales
WHERE is_cancelled = 1
GROUP BY stock_code
ORDER BY cancelled_value DESC
LIMIT 10;

-- Q7. Share of revenue from the top 10% of customers
-- First rank every customer into ten equal groups (also used by 05_power_bi_export.sql)
CREATE TABLE customer_rank AS
SELECT customer_id,
       SUM(revenue) AS customer_revenue,
       NTILE(10) OVER (ORDER BY SUM(revenue) DESC) AS tenth
FROM sales
WHERE customer_id IS NOT NULL
GROUP BY customer_id;

SELECT ROUND(100.0 * SUM(CASE WHEN tenth = 1 THEN customer_revenue ELSE 0 END)
             / SUM(customer_revenue), 1) AS top_10_pct_share,
       SUM(CASE WHEN tenth = 1 THEN 1 ELSE 0 END) AS top_10_pct_customers
FROM customer_rank;

-- Q8a. Average order value (one invoice = one order)
SELECT ROUND(SUM(revenue) / COUNT(DISTINCT invoice), 2) AS average_order_value
FROM sales
WHERE is_cancelled = 0;

-- Q8b. Orders per customer
SELECT ROUND(1.0 * COUNT(DISTINCT invoice) / COUNT(DISTINCT customer_id), 1) AS orders_per_customer
FROM sales
WHERE is_cancelled = 0 AND customer_id IS NOT NULL;

-- Q9. Share of customers who bought only once
WITH per_customer AS (
  SELECT customer_id, COUNT(DISTINCT invoice) AS orders
  FROM sales
  WHERE is_cancelled = 0 AND customer_id IS NOT NULL
  GROUP BY customer_id
)
SELECT COUNT(*) AS customers,
       SUM(CASE WHEN orders = 1 THEN 1 ELSE 0 END) AS one_order_only,
       ROUND(100.0 * SUM(CASE WHEN orders = 1 THEN 1 ELSE 0 END) / COUNT(*), 1) AS one_order_pct
FROM per_customer;

-- Q10. Revenue by country (100 minus the UK share = international share)
SELECT country,
       ROUND(SUM(revenue)) AS net_revenue,
       ROUND(100.0 * SUM(revenue) / (SELECT SUM(revenue) FROM sales), 1) AS share_pct
FROM sales
GROUP BY country
ORDER BY net_revenue DESC
LIMIT 6;

-- Q11. Countries with the highest average order value (50 orders or more)
SELECT country,
       COUNT(DISTINCT invoice) AS orders,
       ROUND(SUM(revenue) / COUNT(DISTINCT invoice), 2) AS average_order_value
FROM sales
WHERE is_cancelled = 0
GROUP BY country
HAVING COUNT(DISTINCT invoice) >= 50
ORDER BY average_order_value DESC
LIMIT 10;
