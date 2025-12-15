-- SQL Retail Sales Analysis - P1
DROP TABLE IF EXISTS retail_sales;
Create table retail_sales
			(
				transactions_id INT PRIMARY KEY,
				sale_date DATE,
				sale_time TIME,
				customer_id INT,
				gender VARCHAR(15),
				age INT,
				category VARCHAR(15),
				quantity INT,
				price_per_unit FLOAT,
				cogs FLOAT,	
				total_sale FLOAT
			); 
Alter table retail_sales 
Rename column quantiy to quantity;

Select* FROM retail_sales
limit 10

Select count(*)
from retail_sales
-- Data Cleaning 
Select * from retail_sales
where transactions_id is null
or 
sale_date is null
or
sale_time is null
or 
customer_id is null
or
gender is null
or 
age is null
or
category is null
or
quantity is null
or
price_per_unit is null
or
cogs is null
or
total_sale is null;

Delete from retail_sales 
where 
transactions_id is null
or 
sale_date is null
or
sale_time is null
or 
customer_id is null
or
gender is null
or 
age is null
or
category is null
or
quantity is null
or
price_per_unit is null
or
cogs is null
or
total_sale is null;

--Data Exploration 

-- How many sales we have ?
Select count(*) as total_sale from retail_sales

-- How many unique cutomes we have ?
Select count (DISTINCT customer_id) as total_sale from retail_sales

Select DISTINCT category from retail_sales;

-- Data Analysis & Business key problems & answers
-- write sql query to retrieve all columns from sales made on "2022-11-05"

Select * from retail_sales
where sale_date = '2022-11-05'

-- write sql query to retrieve all transaction where category is clothing and quantity sold is more than 4 in the month of Nov-2022

Select * from retail_sales
where
category = 'Clothing' 
AND 
quantity >= 4
AND
TO_CHAR(sale_date, 'YYYY-MM')='2022-11' 

-- write sql query to calculate the total sales for each category 
Select category, sum(total_sale) as net_sale, count(*)as total_sales
from retail_sales
group by category 

-- write sql query to find average age of customers who purchased items from the 'Beauty' category.
Select Round(avg(age),2) as AVG_age
from retail_sales
where category ='Beauty'

-- write sql query to find all transactions where the total sale is greater than 1000.
Select * 
from retail_sales
where total_sale > 1000

-- write sql query to find the total number of transactions made by each gender in each category
Select gender, category, count(transactions_id)as No_transactions
from retail_sales
group by category, gender

-- write sql query to calculate the avgerage sale for each month. find out best selling month for each year
Select year, month, Avg_sale from
(Select Extract (year from sale_date) as year,
Extract (month from sale_date) as month,
AVG(total_sale) as Avg_sale,
RANK () OVER (partition by  Extract (year from sale_date) order by AVG(total_sale) DESC) as rank
from retail_sales
group by 1,2
)as t1 
where rank = 1

-- write sql query to find the top 5 customers based on the highst total sales
Select customer_id, SUM(total_sale) as total_sales
from retail_sales
group by customer_id
order by total_sales DESC
limit 5

-- write sql query to find the number of unique customers who purchased items from each category
Select COUNT(DISTINCT customer_id)as unique_customers, category
from retail_sales
group by category

-- write sql query to create each shift and number of orders (morning<=12, afternoon between 12 & 17, Evening >17)
with hourly_sale
as
(
Select *, 
 case
   when EXTRACT (Hour from sale_time) < 12 then 'Morning'
   when EXTRACT (Hour from sale_time) BETWEEN 12 AND 17 then 'Afternoon'
   else 'Evening'
 end as shift 
from retail_sales
) Select  shift,COUNT (*) as total_orders from hourly_sale
group by shift 

-- end of project