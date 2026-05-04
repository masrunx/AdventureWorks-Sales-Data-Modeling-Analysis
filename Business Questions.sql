--  السؤال الأول (تحليل الفجوة بين الأهداف والمبيعات) من هم الموظفون الذين حققوا أقل من 50% من أهدافهم في الربع الأول من العام؟ وما هو إجمالي خسارة الشركة  بسببهم؟
GO 


CREATE VIEW View_Sales_Gap_Analysis AS
With actual_sales AS (
select 
    sp.salesperson_fullname,
    sp.employee_key,
    d.sales_order_date_year ,
    d.[quarter],
    SUM (s.total_sales) AS All_Sales  ,
    count (s.sales_order_number) AS Order_Number


    
from Dim_SalesPerson sp
inner join fact_sales s on s.employee_key = sp.employee_key
inner join Dim_Date d on d.sales_order_date = s.sales_order_date
Group by 
    sp.salesperson_fullname,
    sp.employee_key,
    sales_order_date_year,
    [quarter]
),

actual_targets AS (

Select
    employee_key,
    sales_order_date_year ,
    [quarter],
    SUM (Cast ( t.target AS BIGINT)) AS The_Target
From Fact_Targets t
inner join Dim_Date d on d.sales_order_date = t.target_date
Group By 
    employee_key,
    sales_order_date_year ,
    [quarter]

)



select 
    s.salesperson_fullname,
    s.sales_order_date_year,
    s.[quarter],
    ROUND (All_Sales,2) AS 'All_Sales' ,
    The_Target,
    Order_Number,
    Round (Cast (All_Sales AS Float) / The_Target  * 100,2  ) AS Achievement_Pct,
    Round (The_Target - Cast (All_Sales AS Float)  ,2  ) AS GAP
From actual_sales s
inner join actual_targets t on t.employee_key = s.employee_key AND t.quarter = s.quarter AND t.sales_order_date_year = s.sales_order_date_year
Where  Round (Cast (All_Sales AS Float) / The_Target  * 100,2  ) < 50 
AND s.[quarter] = 'Q1'
-- احذف go لو عايز تشغل الكود من غير ما تعمل view

GO
-- لو هتعمل view ف لا تختار هذا الكود
order by sales_order_date_year,[quarter],Achievement_Pct desc


--    السؤال الثاني ما هي الـ 20% من المنتجات التي تجلب 80% من إجمالي الأرباح؟
GO 

CREATE VIEW View_Product_Pareto_80_20 AS
With Product_profit AS (
Select 
    p.product_name, 
    SUM (s.profit) AS Total_profit 
From Dim_Product p
inner join Fact_Sales s on p.product_key =s.product_key
Group by p.product_name
),

Ranked AS (
Select 
   f.product_name,
   f.Total_profit,
   ROW_NUMBER () over (Order By f.Total_profit DESC) AS [RANK],
   SUM (f.Total_profit) over () AS grand_total ,
   SUM (f.Total_profit) over (ORder BY f.Total_profit DESC ) AS running_total,
   ROUND (SUM (f.Total_profit) over (ORder BY f.Total_profit DESC ) / SUM (f.Total_profit) over ()  * 100 ,2 ) AS cumulative_pct


From Product_profit f
)

Select 

   r.product_name,
   r.Total_profit,
   r.grand_total,
   r.running_total,
   r.cumulative_pct

From Ranked r
Where r.cumulative_pct <=80
-- احذف go لو عايز تشغل الكود من غير ما تعمل view
GO
-- لو هتعمل view ف لا تختار هذا الكود
Order By [RANK]

--  السؤال الثالث  من هم الموزعون (Resellers) الذين اشتروا في النصف الأول من العام ولم يعودوا للشراء في النصف الثاني، وما هو حجم المبيعات المفقودة بسببهم؟
GO
CREATE VIEW View_Churned_Resellers AS

With reseller_H1 AS (
Select 

   r.reseller_name,
   r.reseller_key,
   SUM (s.total_sales) AS total_sales  
From Dim_Reseller r
inner join Fact_Sales s on s.reseller_key = r.reseller_key
inner join Dim_Date d on d.sales_order_date =s.sales_order_date
Where d.[quarter] IN ('Q1','Q2')
Group by 
   r.reseller_name,
   r.reseller_key
   ),

reseller_H2 AS (

Select 
  r.reseller_key,
  SUM (s.total_sales) AS total_sales
 
From  Dim_Reseller r
inner join Fact_Sales s on s.reseller_key = r.reseller_key
inner join Dim_Date d on d.sales_order_date =s.sales_order_date
Where d.[quarter] IN ('Q3','Q4')
Group by 
   r.reseller_key
   )
select 
   h1.reseller_key,
   h1.reseller_name,
   h1.total_sales AS Lost_Sales_Value
    
From reseller_H1 h1 
left join  reseller_H2 h2 on h1.reseller_key = h2.reseller_key
Where  h2.reseller_key IS NULL
-- احذف go لو عايز تشغل الكود من غير ما تعمل view
GO