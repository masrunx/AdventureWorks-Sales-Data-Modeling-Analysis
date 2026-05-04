SELECT * INTO adventureworks_2022_clean
FROM adventureworks_2022_denormalize$

Update adventureworks_2022_clean
SET cost =  REPLACE (REPLACE (cost,'$',''),',','')

Update adventureworks_2022_clean
SET total_sales =  REPLACE (REPLACE (total_sales,'$',''),',','')

Update adventureworks_2022_clean
SET unit_price =  REPLACE (REPLACE (unit_price,'$',''),',','')

Update adventureworks_2022_clean
SET [target] = REPLACE (REPLACE ([target],'$',''),',','')

UPDATE adventureworks_2022_clean
SET target_date = REPLACE (target_date,',','')

ALTER TABLE adventureworks_2022_clean
ALTER COLUMN [target] INT

ALTER TABLE adventureworks_2022_clean
ALTER COLUMN cost DECIMAL

ALTER TABLE adventureworks_2022_clean
ALTER COLUMN quantity INT

ALTER TABLE adventureworks_2022_clean
ALTER COLUMN unit_price DECIMAL

ALTER TABLE adventureworks_2022_clean
ALTER COLUMN total_sales DECIMAL

ALTER TABLE adventureworks_2022_clean
ALTER COLUMN product_key INT

ALTER TABLE adventureworks_2022_clean
ALTER COLUMN reseller_key INT

ALTER TABLE adventureworks_2022_clean
ALTER COLUMN employee_key INT

ALTER TABLE adventureworks_2022_clean
ALTER COLUMN sales_territory_key INT

ALTER TABLE adventureworks_2022_clean
ALTER COLUMN employee_id INT



