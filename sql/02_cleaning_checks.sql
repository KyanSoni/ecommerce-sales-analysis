-- E-commerce Sales Analysis
-- 02. Stack the two years and count every data problem
--
-- Each count fills a row of docs/cleaning_log.md.

-- Stack both sheets into one table
CREATE TABLE sales_raw AS
SELECT * FROM raw_2009
UNION ALL
SELECT * FROM raw_2010;

-- Total rows. Expected: 1,067,371
SELECT COUNT(*) AS total_rows FROM sales_raw;

-- Cancellations (invoice starts with C). Expected: 19,494
SELECT COUNT(*) AS cancelled_rows
FROM sales_raw
WHERE "Invoice" LIKE 'C%';

-- Rows with no customer number. Expected: 243,007
SELECT COUNT(*) AS no_customer_rows
FROM sales_raw
WHERE TRIM("Customer ID") = '' OR "Customer ID" IS NULL;

-- Rows with a zero or negative price. Expected: 6,207
SELECT COUNT(*) AS zero_price_rows
FROM sales_raw
WHERE CAST("Price" AS REAL) <= 0;

-- Stock codes that are not products (postage, fees, adjustments)
SELECT "StockCode", MAX("Description") AS description, COUNT(*) AS row_count
FROM sales_raw
WHERE "StockCode" !~ '^[0-9]{5}'
GROUP BY "StockCode"
ORDER BY row_count DESC;

-- Rows with a non-product stock code. Expected: 6,093
SELECT COUNT(*) AS non_product_rows
FROM sales_raw
WHERE "StockCode" !~ '^[0-9]{5}';

-- Exact duplicate rows, including rows that appear in both sheets.
-- Expected: about 34,334 (the exact number depends on how Excel saved the CSVs)
SELECT (SELECT COUNT(*) FROM sales_raw)
     - (SELECT COUNT(*) FROM (SELECT DISTINCT * FROM sales_raw) AS d) AS duplicate_rows;
