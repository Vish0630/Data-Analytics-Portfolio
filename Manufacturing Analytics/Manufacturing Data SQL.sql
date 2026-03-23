Create Database Maunfacturing_Data;
use Maunfacturing_Data;

Create table Main
(

Buyer varchar(10),
Cust_Code	varchar(20),
Cust_Name	varchar(20),
Delivery_Period	varchar(10),
Department_Name	varchar (50),
Designer boolean,
Doc_Date	date,
 DocNum	int,
 EMP_Code	varchar(10),
 Emp_Name varchar(20),
 Perday_machine_cost float,
 Press_Qty	int,
 Processed_Qty	int, 
 Produced_Qty	int, 
 Rejected_Qty	int,
 Repeat_qty	int,
 today_Manufactured_qty	int,
 TotalQty	int,
 TotalValue	float,
 WO_Qty	int,
 Machine_Code	varchar(20),
 Operation_Name	varchar(20),
 Operation_Code	varchar(20),
 Item_Code	varchar(20), 
 Item_Name varchar(100));
 
 SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'local_infile';

LOAD DATA LOCAL INFILE 'C:/Users/admin/Documents/Main.csv'
INTO TABLE Main
CHARACTER SET latin1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

Select * from Main;

/*******************************************Overview******************************************************************/

/*Total Manufactured Quantity*/
SELECT  CONCAT(ROUND(SUM(produced_Qty) / 1000000, 2), ' M') AS Total_Manufactured_Quantity
FROM Main;

/* Total Processed quantity*/
SELECT  CONCAT(ROUND(SUM(Processed_Qty) / 1000000, 2), ' M') AS Total_Processed_Quantity
FROM Main;

/*Total Rejected Quantity*/
Select Concat(round(sum(Rejected_Qty)/1000,2), 'K')as Total_Rejected_Quantity
from Main;

/* Total wastage */

SELECT 
    CONCAT(
        ROUND((SUM(WO_Qty) - SUM(Produced_Qty)) / 1000000, 2),
        ' M'
    ) AS Total_Wastage
FROM Main;



/* Buyerwise Produced and processed quantity*/

Select Buyer,
concat(round(sum(Produced_Qty)/1000000,2), 'M') as Produced_Qty,
concat(round(sum(Processed_Qty)/1000000,2), 'M') as Processed_Qty 
from Main
Group by Buyer
Having Sum(Produced_Qty)>0

Union All
Select
'Total' as Buyer,
concat(round(sum(Produced_Qty)/1000000,2), 'M'),
concat(round(sum(Processed_Qty)/1000000,2), 'M') 
from Main
Where (Produced_Qty)>0;

/*Rejected by department*/

Select Department_Name,
concat(round(Sum(Rejected_Qty)/1000,2),'K') as Rejected_Qty
from Main
where Rejected_Qty>0
group by Department_Name
order by Rejected_Qty desc;

/*Monthwise revenue of department*/

select
Department_Name,
date_format(Doc_Date, '%M') as Month,
concat(round(sum(TotalValue)/1000000,2), 'M') as Total_Revenue
from Main
group by date_format(Doc_Date, '%M'), Department_Name
order by Total_Revenue desc;

/***************************************Production Analysis*********************************************************/

/*Customer Wise producedquantity*/
select Cust_Name,
concat(round(sum(Produced_Qty)/1000000,2), 'M') as total_produced_quantity
from Main
Group By Cust_Name
Having Sum(Produced_Qty)>0

union all
select 
'Total' as Cust_Name,
concat(round(sum(Produced_Qty)/1000000,2), 'M')
from Main
where Produced_Qty>0;

/*Employeewise Production Quantity*/

Select Emp_Name,
concat(round(sum(Produced_Qty)/1000000,2), 'M') as produced_Qty
from Main
where produced_Qty>0
Group by Emp_Name
order by Emp_Name desc;

/*Buyer and Departmentwise Production*/

Select Buyer,
Department_Name,
concat(round(sum(Produced_Qty)/1000000,2),'M') as Produced_Qty
from Main
where Produced_Qty>0
Group By Buyer, Department_Name
Order by Buyer;

/*Top 5 Production by Machine*/

select Machine_Code,
concat(round(sum(Produced_Qty)/1000000,2), 'M') as Produced_Qty
from Main
where Produced_Qty>0
Group by Machine_Code
order by Produced_Qty Desc
Limit 5;

/* Monthly Manufactured Quantity*/

SELECT DATE_FORMAT(Doc_Date, '%M') AS Month,
       CONCAT(ROUND(SUM(Produced_Qty)/1000000,2),' M') AS Produced_Qty
FROM Main
GROUP BY DATE_FORMAT(Doc_Date, '%M')
Order by DATE_FORMAT(Doc_Date, '%M') desc;

/**************************************Wastage Analysis********************************************************/

Alter table main
Add column Wastage int;

update main
set wastage=WO_Qty-Produced_Qty;

/* Wastage and rejection by Department*/

select Department_Name,
concat(round(sum(Wastage)/1000000,2),'M') as Wastage,
concat(round(sum(Rejected_Qty)/1000,2),'K') as rejected
from Main
group by Department_Name
having sum(wastage)>0
Order by wastage Desc;

/*Top 10 Machine Rejected Quantity*/

Select Machine_Code,
concat(round(Sum(Rejected_Qty)/1000,2),'K') as Rejected_Qty
from Main
group by Machine_Code
order by Rejected_Qty desc
Limit 10;

/*Employeewise Rejected Quantity*/

Select Emp_Name,
concat(round(Sum(Rejected_Qty)/1000,2),'K') as Rejected_Qty
from Main
where Rejected_Qty>0
Group by Emp_Name
Order by Rejected_Qty desc;

/* Monthwise Rejected Quantity*/
SELECT 
    date_format(Doc_Date, '%M') AS month,
    SUM(Rejected_Qty) AS total_rejected_quantity
FROM Main
GROUP BY date_format(Doc_Date, '%M') 
Having sum(Rejected_Qty)>0;

/**************************************Revenue Analysis****************************************************************/

Select buyer,
Department_Name,
concat(round(sum(TotalValue)/1000000,2),'M') as Total_Revenue
from Main
group by  Department_Name,buyer
having Total_Revenue>0
Order by Department_Name;

/* Revenue by month*/

select
date_format(Doc_Date, '%M') as Month,
concat(round(sum(TotalValue)/1000000,2), 'M') as Total_Revenue
from Main
group by date_format(Doc_Date, '%M')
order by Total_Revenue desc;

/* Revenue by Machine*/

Select Machine_Code,
concat(round(sum(TotalValue)/1000000,2), 'M') as TotalValue
from Main
Group by Machine_Code
order by sum(TotalValue) desc
Limit 5;

/*******************************************Thank You******************************************************************/








 
