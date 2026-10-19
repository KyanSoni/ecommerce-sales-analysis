-- E-commerce Sales Analysis
-- 03. Build the clean sales table
--
-- SELECT DISTINCT       removes exact duplicate rows
-- CAST                  turns text into numbers (NUMERIC keeps money exact)
-- NULLIF(..., '')       turns an empty customer number into a proper blank
-- revenue               quantity x price; negative for cancellations
-- is_cancelled          1 for a cancellation, 0 for a sale
-- ~ '^[0-9]{5}'         keeps real products only (drops postage and fees)
-- unit_price > 0        drops zero and negative prices

CREATE TABLE sales AS
SELECT DISTINCT
  "Invoice"                              AS invoice,
  "StockCode"                            AS stock_code,
  TRIM("Description")                    AS description,
  CAST("Quantity" AS INTEGER)            AS quantity,
  "InvoiceDate"                          AS invoice_date,
  substr("InvoiceDate", 1, 7)            AS year_month,
  CAST("Price" AS NUMERIC)               AS unit_price,
  NULLIF(TRIM("Customer ID"), '')        AS customer_id,
  "Country"                              AS country,
  ROUND(CAST("Quantity" AS INTEGER) * CAST("Price" AS NUMERIC), 2) AS revenue,
  CASE WHEN "Invoice" LIKE 'C%' THEN 1 ELSE 0 END AS is_cancelled
FROM sales_raw
WHERE "StockCode" ~ '^[0-9]{5}'
  AND CAST("Price" AS NUMERIC) > 0;

-- Rows before and after cleaning. Expected: 1,067,371 and 1,021,129
SELECT (SELECT COUNT(*) FROM sales_raw) AS before_cleaning,
       (SELECT COUNT(*) FROM sales)     AS after_cleaning;

-- Date range of the clean data
SELECT MIN(invoice_date) AS first_sale, MAX(invoice_date) AS last_sale FROM sales;
