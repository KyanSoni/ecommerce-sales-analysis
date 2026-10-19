# Power BI columns and measures (DAX)

All formulas live in the `sales_export` table of [powerbi/ecommerce_dashboard.pbix](../powerbi/ecommerce_dashboard.pbix).

## Calculated columns

```dax
Order Date = DATE(YEAR(sales_export[invoice_date]), MONTH(sales_export[invoice_date]), DAY(sales_export[invoice_date]))
Month Start = DATE(YEAR(sales_export[invoice_date]), MONTH(sales_export[invoice_date]), 1)
Year = YEAR(sales_export[invoice_date])
Month No = MONTH(sales_export[invoice_date])
Month = FORMAT(sales_export[invoice_date], "MMM")
Market = IF(sales_export[country] = "United Kingdom", "UK", "International")
```

`Month` is sorted by `Month No`, and `Year` is set to Don't summarize.

## Measures

```dax
Net Revenue = SUM(sales_export[revenue])
Gross Sales = CALCULATE(SUM(sales_export[revenue]), sales_export[is_cancelled] = 0)
Cancelled Value = -CALCULATE(SUM(sales_export[revenue]), sales_export[is_cancelled] = 1)
Cancelled % = DIVIDE([Cancelled Value], [Gross Sales])
Orders = CALCULATE(DISTINCTCOUNT(sales_export[invoice]), sales_export[is_cancelled] = 0)
Average Order Value = DIVIDE([Gross Sales], [Orders])
Customers = DISTINCTCOUNTNOBLANK(sales_export[customer_id])
International Share = DIVIDE(CALCULATE([Net Revenue], sales_export[Market] = "International"), [Net Revenue])
```

## Card labels

These show whole numbers in full on the cards (for example 39,517 rather than 40K).

```dax
Orders Label = FORMAT([Orders], "#,0")
Customers Label = FORMAT([Customers], "#,0")
```

## How they work

- `CALCULATE` works out a total with a filter applied.
- `DIVIDE` divides and returns a blank instead of an error when dividing by zero.
- `DISTINCTCOUNT` counts each invoice once, however many product rows it has.
- Every rate divides one total by another, so it stays correct under any slicer selection.
