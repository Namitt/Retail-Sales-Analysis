-- Retail Sales Analysis

-- Create Table

DROP TABLE IF EXISTS retail_sales_analysis.retail_sales;
CREATE TABLE retail_sales_analysis.retail_sales
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
                        
SELECT * 
FROM retail_sales_analysis.retail_sales;

SELECT COUNT(*)
FROM retail_sales_analysis.retail_sales;

SELECT * 
FROM retail_sales_analysis.retail_sales
WHERE 
	transactions_id IS NULL
    OR
    sale_date IS NULL
    OR
    sale_time IS NULL
    OR
    customer_id IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    price_per_unit IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;

-- DELETE NULL VALUES

DELETE FROM retail_sales_analysis.retail_sales
WHERE
	transactions_id IS NULL
    OR
    sale_date IS NULL
    OR
    sale_time IS NULL
    OR
    customer_id IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    price_per_unit IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
-- Data Exploration

-- Total number of sales?
SELECT COUNT(*) total_sales
FROM retail_sales_analysis.retail_sales;

-- Total number of unique customes
SELECT COUNT(DISTINCT customer_id) total_customers
FROM retail_sales_analysis.retail_sales;

-- Unique categories
SELECT DISTINCT category unique_categories
FROM retail_sales_analysis.retail_sales;

-- Data Analysis

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

SELECT *
FROM retail_sales_analysis.retail_sales
WHERE sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022

SELECT *
FROM retail_sales_analysis.retail_sales
WHERE
	category = 'Clothing'
    AND
    quantity > 3
    AND
    SUBSTR(sale_date, 1,7) = '2022-11';
    
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT 
	category, 
	SUM(total_sale) total_sales
FROM retail_sales_analysis.retail_sales
GROUP BY category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT 
	ROUND(AVG(age), 2) avg_age
FROM retail_sales_analysis.retail_sales
WHERE category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT *
FROM retail_sales_analysis.retail_sales
WHERE total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT 
	gender, 
	category, 
	COUNT(transactions_id) total_transcations
FROM retail_sales_analysis.retail_sales
GROUP BY category, gender;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year


WITH rank_cte AS(
	SELECT 
		YEAR(sale_date) `Year`, 
		MONTH(sale_date) `Month`, 
		ROUND(AVG(total_sale), 2) avg_sale,
		RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) `Rank`
	FROM retail_sales_analysis.retail_sales
	GROUP BY 1, 2
	)
SELECT *
FROM rank_cte 
WHERE `Rank` = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT 
	customer_id, 
	SUM(total_sale) total_purchase
FROM retail_sales_analysis.retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT 
	category, 
    COUNT(DISTINCT customer_id) total_unique_customers
FROM retail_sales_analysis.retail_sales
GROUP BY 1;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

SELECT 
	CASE
		WHEN HOUR(sale_time) <= 12 THEN 'Morning'
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
	END Shift,
    COUNT(transactions_id)
FROM retail_sales_analysis.retail_sales
GROUP BY 1;

-- END 