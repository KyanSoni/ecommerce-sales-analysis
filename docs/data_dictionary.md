# Data dictionary

## sales (built in 03_build_sales_table.sql)

| Column | Type | Meaning |
| --- | --- | --- |
| invoice | text | Order number. Starts with C if it is a cancellation |
| stock_code | text | Product code: five digits plus an optional letter |
| description | text | Product name |
| quantity | integer | Units. Negative for cancellations |
| invoice_date | text | Date and time of the order, as yyyy-mm-dd hh:mm:ss |
| year_month | text | Month of the order, such as 2010-11 |
| unit_price | numeric | Price per unit in pounds |
| customer_id | text | Customer number. Blank if unknown |
| country | text | Customer's country |
| revenue | numeric | quantity × unit_price. Negative for cancellations |
| is_cancelled | integer | 1 for a cancellation, 0 for a sale |

## customer_rank (built in 04_business_questions.sql, Q7)

| Column | Type | Meaning |
| --- | --- | --- |
| customer_id | text | Customer number |
| customer_revenue | numeric | Net revenue from that customer over two years |
| tenth | integer | 1 to 10. 1 = the top 10% of customers by revenue |

## sales_export (built in 05_power_bi_export.sql, loaded into Power BI)

Every column of `sales`, plus:

| Column | Type | Meaning |
| --- | --- | --- |
| customer_group | text | Top 10% of customers, Other customers, or No customer number |

## Columns added in Power BI

| Column | Formula | Meaning |
| --- | --- | --- |
| Order Date | Date part of invoice_date | Used by the date slicer |
| Month Start | First day of the month | Monthly charts |
| Year | Year of invoice_date | Line chart legend |
| Month No | Month number | Sorts Month in calendar order |
| Month | Month name, such as Nov | Line chart axis |
| Market | UK or International | Market slicer |
