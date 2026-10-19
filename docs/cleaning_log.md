# Cleaning log

Every check comes from [sql/02_cleaning_checks.sql](../sql/02_cleaning_checks.sql) and [sql/03_build_sales_table.sql](../sql/03_build_sales_table.sql).

| What I found | Rows | What I did | Why |
| --- | --- | --- | --- |
| Total rows in both sheets | 1,067,371 | Stacked into one table | One table is easier to query |
| Cancellations (invoice starts with C) | 19,494 | Kept and flagged with `is_cancelled` | They reduce revenue, so they belong in the totals |
| No customer number | 243,007 | Kept, left out of customer questions | The sale happened, but the buyer is unknown |
| Stock codes that are not products | 6,093 | Removed | Postage, fees, vouchers and adjustments are not product sales |
| Zero or negative price | 6,207 | Removed | No revenue, and often stock adjustments |
| Exact duplicate rows | 34,334 | Removed with `SELECT DISTINCT` | Includes rows that appear in both sheets |
| Invoice numbers turned into dates by Excel | Found in Power BI | Converted back to text | Excel had applied a date format to the column |
| **Rows after cleaning** | **1,021,129** | | |

A row can have more than one problem, so the counts do not add up to the gap between before and after.

## Checks against Excel and Power BI

| Measure | PostgreSQL | Power BI |
| --- | --- | --- |
| Gross sales | £19,642,696.35 | £19,642,696.35 |
| Orders | 39,516 | 39,517 |
| Average order value | £497.08 | £497.07 |

The one-order gap is unexplained and stated in the README. It also explains the 1p difference in average order value, since Power BI divides the same sales by one more order.

## Lesson learned

Never open a raw CSV in Excel and save it. Excel changed invoice numbers into dates, which is how the mismatch above started. The database now imports the untouched original.
