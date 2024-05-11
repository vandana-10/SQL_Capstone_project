
USE amazon_capstone;  -- created a database by given data
SELECT  * FROM  amazon_sql;  -- created a table and extracted all rows and columns from table 

-- ANALYSIS LIST

-- ProductLine

SELECT DISTINCT(Productline) FROM amazon_sql;
/* 
PRODUCT LINE
Health and beauty
Electronic accessories
Home and lifestyle
Sports and travel
Food and beverages
Fashion accessories 
*/ 


SELECT Productline,SUM(Total) AS Revenue FROM amazon_sql
GROUP BY Productline
ORDER BY SUM(Total) DESC;


-- PRODUCT ANALYSIS
/*
In Amazon Sales Data there are 6 Distinct productlines and out of 6 Food and beverages produces highest Revenue 
and Health and beauty produces less revenue among all the products. so, we need to concentrate on Health and beauty to improve their sales and Revenue by providing some Offers or put them on a sale to get the attention of Customers on health and beauty
and Remaining products are performing Good.
*/


-- SALES ANALYSIS

SELECT Branch,Productline,count(InvoiceID) AS Sales ,
dense_RANK()OVER(ORDER BY COUNT(InvoiceID) DESC) AS Rank_on_Sales
FROM amazon_sql
group by Branch,Productline;

 /*
productlines like sports and travel,health and beauty and electronic accessories need to improve sales
and Branch B has less Sales when compared to A and C 
and Member ship Customers increasing sales than Normal customer type we can increase Sales by providing membership for Normal Customers 
To Gain more sales we need to put offers on Festival Sesaon to get more customers and in month of january we have more Sales on each product when compared to other months ,so we need to grab attention of every user on occasions to increase our sales
 */
 
 
-- CUSTOMER ANALYSIS 

 SELECT `customer Type`,count(*) AS Sales from amazon_sql
 GROUP BY `Customer type`;
 
/*
Member ship Customers increasing sales than Normal customer type we can increase Sales 
by providing membership for Normal Customers 
and most of the Customers used Ewallet method to purchase products on amazon 
*/


 
-- Business Questions To Answer:

-- Q1-- What is the count of distinct cities in the dataset?
SELECT COUNT(distinct(City)) AS distinct_cities  -- Distinct function helps to retreive all unique values from table 
FROM amazon_sql;                                 -- Count function gives count of values 


-- Q2-- For each branch, what is the corresponding city?
SELECT  Branch,City FROM amazon_sql
GROUP BY  branch,city;


-- Q3--What is the count of distinct product lines in the dataset?
SELECT  COUNT(distinct(productline)) AS distinct_products 
FROM amazon_sql;



-- Q4--.Which payment method occurs most frequently?
SELECT payment,COUNT(Payment)  AS Frequent_method FROM amazon_sql
GROUP BY  Payment
LIMIT 1;
/*
most of the people prefer Ewallet system because  It allows you to store and manage various payment methods
like Debit Card,Credit Card or phone pay ,Google pay
and E-wallets are protected by a password so it is safe to use.
*/



-- Q5--Which product line has the highest sales?
SELECT  productline,COUNT(invoiceid) AS high_sales_made FROM amazon_sql
GROUP BY  productline
ORDER BY  high_sales_made DESC ;
 /*
 here  Invoice ID represents no of orders been placed by unique identifier each transaction.
 so,i think more invoice id 's gives more orders of product line and more sales increased of products 
and it also Helps track and manage sales records.
here in output we can see fashion accessories has more invoice id's which means more orders are placed on fashion accessories
*/



-- Q6--How much revenue is generated each month?        
SELECT monthname,sum(total) AS Revenue  FROM amazon_sql  -- i extract monthname from date column and it has 3 distinct values and 
GROUP BY monthname;                                 -- after group them by month based on total column january has highest revenue 




-- Q7--In which month did the cost of goods sold reach its peak?
SELECT monthname,SUM(cogs)  AS total_cogs FROM amazon_sql   -- sum of cogs gives goods sold and for 
GROUP BY monthname
LIMIT 1;                                          -- each month i group them by monthname and january has high cogs value




-- Q8--Which product line generated the highest revenue?
SELECT productline,SUM(total) AS highest_revenue  FROM amazon_sql
GROUP BY Productline             -- grouping them by Productline based on total column for revenue and order by helps  to sort the 
ORDER BY highest_revenue DESC     --  data in asc or desc and limit condition gives range of values between them
LIMIT 1;



-- Q9-- In which city was the highest revenue recorded?
SELECT city,SUM(total) AS Revenue FROM amazon_sql
GROUP BY city                            -- For Revenue we calculate sum for total column and group them by city and for high
ORDER BY Revenue DESC                    -- revenue i use order function and limit gives highest revenue based on city 
LIMIT 1 ;



-- Q10-- Which product line incurred the highest Value Added Tax?
SELECT productline,SUM(`Tax5%`) AS Total_VAT  FROM amazon_sql     --   for VAT we have a tax5% column by calculating sum of tax and 
GROUP BY Productline                                              -- Group the Productline to get total Tax5% for each product 
ORDER BY Total_VAT DESC                                     -- Ordering them based on total_vat and limit gives highest vat amount 
LIMIT 1 ;



-- Q11--For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."
-- Gross profit margin is a key financial metric that measures the efficiency of a company’s production process or service delivery.
-- In this data Grosspercentage Margin has same values so i choose Total column for reviewing the sales
SELECT productline, SUM(total) AS Revenue ,  avg(total) AS avg_revenue,
CASE
WHEN sum(total) > avg(total)  THEN 'GOOD'     -- Here We take total Revenue and Avg Revenue to distinguish whether the sales or Good
WHEN sum(total) < avg(total)  THEN 'BAD'   -- or Bad so CASE statements works best in this type of conditions and 
ELSE 'OK'                                -- Grouping the product line column so that we  get review for each product line
END AS 'Review on Sales'
FROM amazon_sql
GROUP BY productline;





-- Q12--Identify the branch that exceeded the average number of products sold.
SELECT Branch, SUM(Quantity) AS Total_Products_sold , 
AVG(Quantity)  AS avg_products_sold FROM amazon_sql   -- Here I took avg and sum for Quantity for Comparing the total and avg
GROUP BY Branch                            --  so,I use order by because it gives exceeded the average number of products sold 
ORDER BY avg_products_sold DESC
LIMIT 1;                                  -- branch C is Exceeded when compared to other two branches
                                         -- branch A has more products sold but for Avg Branch C is Exceeded in products sold





-- Q13--Which product line is most frequently associated with each gender?
WITH freq_associate As (
SELECT productline,Gender,COUNT(Invoiceid) as freq_count
 FROM  amazon_sql                   -- invoiceid can give frequency of gender by using count function 
 GROUP BY productline , Gender          -- most of females are increasing the sales on fashion products and then food
 ORDER BY freq_count DESC)
 SELECT * FROM freq_associate
 LIMIT 3;
  
  
  
SELECT productline,Gender,COUNT(Invoiceid) as freq_count
 FROM  amazon_sql                   -- 
 GROUP BY productline , Gender
 ORDER BY freq_count DESC
 LIMIT 3;



-- Q14--Calculate the average rating for each product line.
SELECT productline,AVG(Rating)  AS avg_rating FROM amazon_sql
GROUP BY Productline         -- for avg Rating i group the Productline and use order by function to get highest avg Rating
ORDER BY avg_rating DESC;




-- Q15--Count the sales occurrences for each time of day on every weekday.
SELECT timeofday , dayname , COUNT(total) AS sales  FROM amazon_sql
WHERE dayname !='saturday' AND dayname !='sunday'    -- Here I filter out the dayname by using where condition to get only weekdays
GROUP BY  timeofday , dayname                -- and group them timeofday and dayname columns to get sales count and order by 
ORDER BY Sales DESC  , dayname ASC;        -- function helps to sort the data in desc order




-- Q16--Identify the customer type contributing the highest revenue.
SELECT `customer type` , sum(total) AS highest_revenue
 FROM amazon_sql                        -- For revenue i use total column and group the customer type to get 
GROUP BY `customer type`;               -- highest revenue for each customer type



-- Q17 Determine the city with the highest VAT percentage.
SELECT city , SUM(`tax5%`) AS highest_VAT FROM amazon_sql
GROUP BY city                     -- city Naypyitaw has highest VAT , by using aggregate function and group by function gives
ORDER BY highest_VAT DESC;            -- VAT percentage and order by gives Highest VAT percentage


-- Q18--Identify the customer type with the highest VAT payments.
SELECT `customer type` , SUM(`tax5%`) AS highest_VAT FROM amazon_sql
GROUP BY `customer type`             -- 'member'customer types gives high VAT and revenue by using aggregate function and group by 
ORDER BY highest_VAT DESC;            --  function gives VAT percentage and order by gives Highest VAT for customer type 



-- Q19--What is the count of distinct customer types in the dataset?
SELECT   distinct `customer type` , COUNT(distinct(`customer type`)) AS count_distinct_customer
FROM amazon_sql                   --  for unique customer types i use distinct function to get unique values and i use count 
GROUP BY `Customer type`;         --  function to get count of unique values and i group them by customer type


SELECT COUNT(distinct(`customer type`)) AS count_distinct_customer
 FROM amazon_sql;



-- Q20--What is the count of distinct payment methods in the dataset?
SELECT COUNT(distinct(payment)) AS count_payment_methods
 FROM amazon_sql;               -- --  for unique payment methods i use distinct function to get unique methods  and i use count 
                                 --  function to get count of unique methods  


SELECT distinct(payment) , COUNT(distinct(payment)) AS count_payment_methods
FROM amazon_sql
GROUP BY Payment;


-- Q21--Which customer type occurs most frequently?
SELECT `Customer type`,COUNT(Invoiceid) as freq_count
 FROM  amazon_sql                   -- for most frequent customer type i use invoiceid column it can give which type of customer
 GROUP BY `Customer type`           -- is buys things frequently and i group them by Customer type
 ORDER BY freq_count DESC;


-- Q22--Identify the customer type with the highest purchase frequency.
SELECT `Customer type`,COUNT(Quantity) AS purchase_frequency  FROM amazon_sql
GROUP BY `Customer type`;     -- Quantity column can give purchase frequency by using aggregate function and group by 
                               --  the customer type   


SELECT `Customer type`,COUNT(*)  AS purchase_frequency FROM amazon_sql
GROUP BY `Customer type`;

SELECT `Customer type`,COUNT(InvoiceID) AS purchase_frequency FROM amazon_sql
GROUP BY `Customer type`;


-- Q23--Determine the predominant gender among customers.
SELECT Gender,COUNT(InvoiceID) AS predominant_gender FROM amazon_sql
GROUP BY Gender;           -- invoiceid column can give  predominant gender  by using aggregate function and group by 
                               --  the customer type 
SELECT Gender,COUNT(*) AS predominant_gender FROM amazon_sql
GROUP BY Gender;  



-- Q24--Examine the distribution of genders within each branch.
SELECT Gender , Branch , COUNT(invoiceid) AS disturibution_gender 
FROM amazon_sql              -- Count of invoiceid gives distribution and i group them by gender and branch column
GROUP BY Gender , Branch         -- order by helps to sort the data in desc or asc order
ORDER BY disturibution_gender DESC ;


-- Q25--Identify the time of day when customers provide the most ratings.
SELECT timeofday , COUNT(Rating) AS Most_ratings FROM amazon_sql
GROUP BY timeofday           -- Here i group the timeofday column and count of rstings gives highesst ratings and order by to get  
ORDER BY Most_ratings DESC;     -- highest rating 


-- Q26--Determine the time of day with the highest customer ratings for each branch
SELECT timeofday , Branch , COUNT(Rating) AS Most_ratings FROM amazon_sql
GROUP BY timeofday , Branch        -- Here i group the timeofday column and count of rstings gives highesst ratings and order by 
ORDER BY Most_ratings DESC
LIMIT 3;     --  function gives  highest rating for branch and timeofday



-- Q27--Identify the day of the week with the highest average ratings.
SELECT dayname , AVG(Rating) as avg_rating FROM amazon_sql
GROUP BY dayname         -- Here i group the dayname column for avg ratings i use avg function and order by to get  
ORDER BY avg_rating DESC
LIMIT 3;     -- highest avg rating 



-- Q28--Determine the day of the week with the highest average ratings for each branch.
SELECT dayname , Branch, AVG(Rating) as avg_rating FROM amazon_sql
GROUP BY dayname , Branch         -- -- Here i group the dayname,branch column and for avg ratings i use avg aggregate function
ORDER BY avg_rating DESC
LIMIT 3;     --  and order by gives highest  avg rating based on dayname and branch





