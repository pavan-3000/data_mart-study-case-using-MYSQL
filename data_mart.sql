select * from weekly_sales limit 10;

## Date cleansing

create table clean_weekly_sales as 
select week_date,
week(week_date) as week_number,
month(week_date) as month_number,
year(week_date) as calender_number,
case
 when segment=null 
then 'Unknown'
 else segment end as segment, 
 customer_type,sales,
case
    when right(segment,1)='1' then 'young_adult'
    when right(segment,1)='2' then 'middle'
    when right(segment,1) in ('3','4') then 'retire'
    else 'unknow'
    end as age_band,
case 
    when left(segment,1)='C' then 'couple'
    when left(segment,1)='F' then 'familes'
    else 'unknowns'
    end as 'demongraphic',
    region,platform,
    transactions,
    round(sales/transactions,2) as avg_transaction
    from weekly_sales;
    
    select * from clean_weekly_sales limit 10;
    
    -- data Exploration
    
    -- how many transacton were there for each year in the dataset?
    
    select calender_number,
    sum(transactions) as total_transaction
    from clean_weekly_sales group by calender_number;
    
    
    -- total sales for each region and month
    
    select region,month_number,
    sum(sales) 
    from clean_weekly_sales
    group by region,month_number;
    
    -- what is the total count of transaction for each platform
    
    select platform,
    sum(transactions) as total_transaction
    from clean_weekly_sales
    group by platform;
    
   -- what is percentage of sales Retail vs shoify for each month

create table percentage_vs as
SELECT
  calender_number,
  demongraphic,
  SUM(SALES) AS yearly_sales,
  ROUND(
    (
      100 * SUM(sales)/
        SUM(SUM(SALES)) OVER (PARTITION BY demongraphic)
    ),
    2
  ) AS percentage
FROM clean_weekly_sales
GROUP BY
  calender_number,
  demongraphic
ORDER BY
  calender_number,
  demongraphic;
  
## 7.Which age_band and demographic values contribute the most to Retail sales?
create table contributed as 
SELECT
  age_band,
  demongraphic,
  SUM(sales) AS total_sales
FROM clean_weekly_sales
WHERE platform = 'Retail'
GROUP BY age_band, demongraphic
ORDER BY total_sales DESC;
select * from contributed;
