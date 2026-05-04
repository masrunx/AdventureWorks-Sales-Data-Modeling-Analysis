-- Create Fact_Sales --

select
    sales_order_number ,
    product_key,
    reseller_key,
    employee_key,
    sales_territory_key,
    sales_order_date,
    quantity,
    unit_price,
    total_sales,
    cost ,
    total_sales - cost AS 'profit'
INTO Fact_Sales
from adventureworks_2022_clean;

-- Create Fact_Targets --

SELECT DISTINCT 
    employee_key,
    [target],
    target_date,
    target_date_year,
    target_date_month,
    target_date_day,
    target_date_day_of_week
INTO Fact_Targets
from adventureworks_2022_clean

--  Create DIM_Products  --

SELECT DISTINCT 
    product_key,
    product_name,
    MIN (cost) AS 'Cost' ,
    MIN (unit_price) AS 'Unit_price'
INTO Dim_Product 
from adventureworks_2022_clean
Group by product_key,product_name



--  Create DIM_Sales_Person  --

SELECT DISTINCT 
    employee_key,
    employee_id,
    salesperson_fullname,
    salesperson_title,
    email_address 
INTO Dim_SalesPerson 
from adventureworks_2022_clean;

--  Create DIM_Reseller  --

select DISTINCT 
    reseller_key,
    reseller_name,
    reseller_business_type,
    reseller_city,
    reseller_state,
    reseller_country
INTO Dim_Reseller
from adventureworks_2022_clean;

--  Create DIM_Territory  --

SELECT DISTINCT 
    sales_territory_key,
    assigned_sales_territory,
    sales_territory_region,
    sales_territory_country,
    sales_territory_group
INTO Dim_Territory 
from adventureworks_2022_clean;

--  Create DIM_Date  --

SELECT DISTINCT 
    sales_order_date,
    sales_order_date_year,
    sales_order_date_month,
    sales_order_date_day,
    sales_order_date_day_of_week
INTO Dim_Date
from adventureworks_2022_clean;
ALTER TABLE Dim_Date ADD quarter VARCHAR(2)

UPDATE Dim_Date
SET quarter = CASE 
    WHEN sales_order_date_month IN ('January','February','March')    THEN 'Q1'
    WHEN sales_order_date_month IN ('April','May','June')            THEN 'Q2'
    WHEN sales_order_date_month IN ('July','August','September')     THEN 'Q3'
    WHEN sales_order_date_month IN ('October','November','December') THEN 'Q4'
END

--    Primary Keys   --

-- Product
ALTER TABLE Dim_Product ALTER COLUMN product_key INT NOT NULL;
ALTER TABLE Dim_Product ADD CONSTRAINT PK_Product PRIMARY KEY (product_key);

-- 2. Sales_Persons
ALTER TABLE Dim_SalesPerson ALTER COLUMN employee_key INT NOT NULL;
ALTER TABLE Dim_SalesPerson ADD CONSTRAINT PK_SalesPerson PRIMARY KEY (employee_key);

-- Resellers 
ALTER TABLE Dim_Reseller ALTER COLUMN reseller_key INT NOT NULL;
ALTER TABLE Dim_Reseller ADD CONSTRAINT PK_Reseller PRIMARY KEY (reseller_key);

-- Territory
ALTER TABLE Dim_Territory
ADD territory_id INT IDENTITY(1,1) PRIMARY KEY

-- Fact_Sales

ALTER TABLE Fact_Sales 
ADD territory_id INT

UPDATE Fact_Sales
SET territory_id = t.territory_id
FROM Fact_Sales
JOIN Dim_Territory t ON t.sales_territory_key = Fact_Sales.sales_territory_key

-- Date 
ALTER TABLE Dim_Date
ADD date_id INT IDENTITY(1,1) PRIMARY KEY

