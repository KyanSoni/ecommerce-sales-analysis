# Excel checks

Before loading anything into the database, I explored a copy of the raw workbook (`explore.xlsx`, not uploaded because it is over 30 MB) and recorded these numbers to check the SQL against.

Sheet `Checks`, column B for `Year 2009-2010` and column C for `Year 2010-2011`:

| Cell | Formula | What it tells you |
| --- | --- | --- |
| B1 | `=COUNTA('Year 2009-2010'!A:A)-1` | Number of rows |
| B2 | `=COUNTIF('Year 2009-2010'!A:A,"C*")` | Cancellation rows |
| B3 | `=COUNTIF('Year 2009-2010'!D:D,"<0")` | Rows with a negative quantity |
| B4 | `=COUNTIF('Year 2009-2010'!F:F,"<=0")` | Rows with a zero or negative price |
| B5 | `=COUNTA('Year 2009-2010'!A:A)-COUNTA('Year 2009-2010'!G:G)` | Rows with no customer number |
| B6 | `=MIN('Year 2009-2010'!E:E)` | First sale date |
| B7 | `=MAX('Year 2009-2010'!E:E)` | Last sale date |
| B8 | `=SUMPRODUCT('Year 2009-2010'!D2:D600000,'Year 2009-2010'!F2:F600000)` | Total of quantity × price |

Comparing B7 (last date of the first sheet) with C6 (first date of the second) showed the two sheets overlap, so some rows appear in both. That is why the SQL removes exact duplicates.

I also built a pivot table of quantity by country, which showed the United Kingdom far ahead of every other market.

The two row counts (525,461 and 541,910) matched the PostgreSQL import exactly.
