# AdventureWorks-Sales-Data-Modeling-AnalysisTechnical Workflow
1. Data Cleaning & ETL Process
Data Sanitization: Removed currency symbols ($) and commas (,) from cost, sales, and target columns to enable mathematical computations.  

Type Casting: Converted raw string data into appropriate technical formats, including DECIMAL for financial metrics and INT for keys and quantities.  

Dataset Optimization: Standardized date formats and prepared the adventureworks_2022_clean table for downstream modeling.  

2. Data Modeling (Star Schema)
Schema Architecture: Designed a robust Star Schema to optimize query performance and reporting.  

Fact Tables: Engineered Fact_Sales (transactional data and profit calculation) and Fact_Targets (employee performance benchmarks).  

Dimension Tables: Created dedicated dimensions for Dim_Product, Dim_SalesPerson, Dim_Reseller, Dim_Territory, and Dim_Date.  

Integrity Constraints: Defined Primary Keys and established relationships to ensure data consistency and referential integrity.  

3. Advanced Business Analytics (SQL Views)
I developed complex SQL scripts to solve critical business challenges:

Performance Gap Analysis: Identifies employees achieving less than 50% of their Q1 targets and quantifies the resulting financial loss.  

Pareto Analysis (80/20 Rule): Pinpoints the top 20% of products responsible for generating 80% of total cumulative profit.  

Reseller Churn Analysis: Detects "Churned" resellers who were active in the first half of the year but ceased purchasing in the second half, calculating the total lost sales value.  

Key Metrics & KPIs
Total Sales & Profit: Aggregated metrics for high-level executive monitoring.  

Achievement %: Dynamic calculation of how close each salesperson is to their designated target.  

Sales GAP: Precise measurement of the deficit between actual performance and business goals.  

Profitability Mapping: Identifying low-margin products and regions requiring immediate strategy shifts.  

Tools Used
SQL Server (T-SQL): For data cleaning, schema engineering, and analytical views.

Power BI: For visual storytelling and dashboarding (as shown in the project screenshots).

How to Use
Run 01_Data_Cleaning.sql to prepare the raw dataset.

Execute 02_Schema_Creation.sql to build the Fact and Dimension tables.

Deploy 03_Analysis_Views.sql to generate the analytical reports.

License
This project is licensed under the MIT License - feel free to use the code for your own analysis or learning purposes.
