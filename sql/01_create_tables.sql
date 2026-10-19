-- E-commerce Sales Analysis
-- 01. Create the raw tables and check the import
--
-- Every column is TEXT so no row is rejected on import.
-- Numbers are converted in 03_build_sales_table.sql.
-- After running this, import retail_2009.csv into raw_2009 and
-- retail_2010.csv into raw_2010 (pgAdmin > Import/Export Data, Header on).

CREATE TABLE raw_2009 (
  "Invoice" TEXT,
  "StockCode" TEXT,
  "Description" TEXT,
  "Quantity" TEXT,
  "InvoiceDate" TEXT,
  "Price" TEXT,
  "Customer ID" TEXT,
  "Country" TEXT
);

CREATE TABLE raw_2010 (
  "Invoice" TEXT,
  "StockCode" TEXT,
  "Description" TEXT,
  "Quantity" TEXT,
  "InvoiceDate" TEXT,
  "Price" TEXT,
  "Customer ID" TEXT,
  "Country" TEXT
);

-- Check the import. Expected: 525,461 and 541,910 rows.
SELECT COUNT(*) AS rows_2009 FROM raw_2009;
SELECT COUNT(*) AS rows_2010 FROM raw_2010;
