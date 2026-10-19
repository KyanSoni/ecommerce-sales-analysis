-- E-commerce Sales Analysis
-- 05. Build the table that Power BI loads
--
-- Labels every sale by whether the buyer is in the top 10% of customers
-- (from customer_rank, built in 04_business_questions.sql, Q7).
-- Export it with pgAdmin > Import/Export Data > Export, Header on,
-- as sales_export.csv, then load it in Power BI with Get data > Text/CSV.

CREATE TABLE sales_export AS
SELECT s.*,
       CASE WHEN s.customer_id IS NULL THEN 'No customer number'
            WHEN c.tenth = 1 THEN 'Top 10% of customers'
            ELSE 'Other customers' END AS customer_group
FROM sales s
LEFT JOIN customer_rank c ON s.customer_id = c.customer_id;

-- Check: rows per customer group
SELECT customer_group, COUNT(*) AS rows, ROUND(SUM(revenue)) AS net_revenue
FROM sales_export
GROUP BY customer_group
ORDER BY net_revenue DESC;
