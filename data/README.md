# Data

The data is not stored in this repository. Download it from the source:

**Online Retail II**, UCI Machine Learning Repository
https://archive.ics.uci.edu/dataset/502/online+retail+ii

## How to prepare it

1. Download and unzip `online_retail_II.xlsx`.
2. Format the InvoiceDate column as `yyyy-mm-dd hh:mm:ss` (Ctrl+1 > Custom), so PostgreSQL reads the dates correctly.
3. Save each sheet as CSV UTF-8: `Year 2009-2010` as `retail_2009.csv` and `Year 2010-2011` as `retail_2010.csv`.
4. Run the files in [../sql](../sql) in number order, importing the CSVs after `01_create_tables.sql`.

## Licence and credit

Chen, D. (2019). Online Retail II. UCI Machine Learning Repository. Licensed under Creative Commons Attribution 4.0 (CC BY 4.0).
