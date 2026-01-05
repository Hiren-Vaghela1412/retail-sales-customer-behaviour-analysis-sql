	create database Project;
	use Project;

	CREATE TABLE dim_products(
		product_sk INT PRIMARY KEY,
		product_id VARCHAR(50) ,
		product_name VARCHAR(100),
		category VARCHAR(50),
		brand VARCHAR(100),
		origin_location VARCHAR(100)
	);

	select * from dim_products;

	CREATE TABLE dim_customers (
		customer_sk INT PRIMARY KEY,
		customer_id varchar(50),
		first_name VARCHAR(100),
		last_name VARCHAR(100),
		email VARCHAR(100),
		residential_location varchar(150),
		customer_segment varchar(100)
	);

	select count(*) from dim_customers;


	CREATE TABLE dim_dates (
		full_date DATE NOT NULL,
		date_sk INT PRIMARY KEY,         
		year INT NOT NULL,                 
		month INT NOT NULL,              
		day INT NOT NULL,                 
		weekday INT NOT NULL,              
		quarter INT NOT NULL               
	);

	Select count(*) From dim_dates;


	CREATE TABLE dim_salespersons (
		salesperson_sk   INT PRIMARY KEY,
		salesperson_id   VARCHAR(10)  ,
		salesperson_name VARCHAR(100) ,
		salesperson_role VARCHAR(50)  
	);

	Select count(*) from dim_salespersons;


	CREATE TABLE dim_stores (
		store_sk INT PRIMARY KEY,
		store_id VARCHAR(20) NOT NULL,
		store_name VARCHAR(100) NOT NULL,
		store_type VARCHAR(50) NOT NULL,
		store_location VARCHAR(100) NOT NULL,
		store_manager_sk INT,

		foreign key (store_manager_sk) references dim_salespersons(salesperson_sk)
	);


	CREATE TABLE dim_campaigns (
		campaign_sk INT PRIMARY KEY,
		campaign_id VARCHAR(20) NOT NULL,
		campaign_name VARCHAR(100) NOT NULL,
		start_date_sk INT NOT NULL,
		end_date_sk INT NOT NULL,
		campaign_budget DECIMAL(12,2) NOT NULL,
		CONSTRAINT fk_campaign_start_date
		foreign key (start_date_sk) references dim_dates(date_sk),
		CONSTRAINT fk_campaign_end_date	
		foreign key (end_date_sk) references dim_dates(date_sk)
	);

	select Count(*) from dim_campaigns;


	CREATE TABLE fact_sales (
		sales_sk INT PRIMARY KEY,
		sales_id VARCHAR(30) NOT NULL,
		customer_sk INT NOT NULL,
		product_sk INT NOT NULL,
		store_sk INT NOT NULL,
		salesperson_sk INT NOT NULL,
		campaign_sk INT NOT NULL,
		sales_date DATETIME NOT NULL,
		total_amount DECIMAL(12,2) NOT NULL,

		CONSTRAINT fk_sales_customer
			FOREIGN KEY (customer_sk) REFERENCES dim_customers(customer_sk),

		CONSTRAINT fk_sales_product
			FOREIGN KEY (product_sk) REFERENCES dim_products(product_sk),

		CONSTRAINT fk_sales_store
			FOREIGN KEY (store_sk) REFERENCES dim_stores(store_sk),

		CONSTRAINT fk_sales_salesperson
			FOREIGN KEY (salesperson_sk) REFERENCES dim_salespersons(salesperson_sk),

		CONSTRAINT fk_sales_campaign
			FOREIGN KEY (campaign_sk) REFERENCES dim_campaigns(campaign_sk)
	);



	-- Q1.High-level performance

	SELECT SUM(total_amount) AS total_revenue FROM fact_sales;

	-- Q2.Average Order Value
	select round(AVG(total_amount),2) as Avg_Revenue from fact_sales;

	-- Q3.No of Customer by Customer Segmentation

	select customer_segment,count(*) As Count_of_Customer
	from dim_customers
	group by customer_segment
	order by Count_of_Customer DESC;

	-- Q4.Customer Geography

	SELECT residential_location, COUNT(*) As No_of_Customers
	FROM dim_customers
	GROUP BY residential_location
	ORDER BY No_of_Customers DESC limit 10;

	-- Q5.Top Customers by Spending
	SELECT 
		c.first_name,
		c.last_name,
		SUM(f.total_amount) AS total_spending
	FROM fact_sales f
	JOIN dim_customers c
		ON f.customer_sk = c.customer_sk
	GROUP BY c.customer_sk, c.first_name, c.last_name
	order by total_spending DESC limit 10;

	-- Q6.Purchase Frequency

	SELECT c.first_name, COUNT(*) AS purchases
	FROM fact_sales f
	JOIN dim_customers c
	ON f.customer_sk = c.customer_sk
	GROUP BY f.customer_sk
	ORDER BY purchases DESC limit 10;


	-- Q7.Store Distribution
	SELECT store_type, COUNT(*)  As Count_of_Stores
	FROM dim_stores
	GROUP BY store_type
	order by Count_of_Stores DESC;

	-- Q8.Store Revenue

	Select store_name,round(AVG(total_amount),2) As Revenue 
	from fact_sales
	join dim_stores 
	on fact_sales.store_sk = dim_stores.store_sk
	group by store_name
	order by Revenue DESC limit 10;

	-- Q9.Store-wise transactions
	Select s.store_name,count(*) As transactions
	from fact_sales f
	join dim_stores s
	on f.store_sk = s.store_sk
	group by s.store_name
	order by transactions DESC limit 10;

	-- Q10.Customers per Store
	SELECT store_name, COUNT(DISTINCT customer_sk) No_of_Customers
	FROM fact_sales f
	JOIN dim_stores s
	ON f.store_sk = s.store_sk
	GROUP BY store_name 
	order by No_of_Customers DESC limit 10;

	-- Q11.Highest selling store per product category.
	Select p.category,s.store_name,SUM(f.total_amount) as Revenue
	from fact_sales as f
	join dim_products as p
	on f.product_sk = p.product_sk
	join dim_stores as s
	on f.store_sk = s.store_sk
	group by p.category,s.store_name
	order by Revenue desc limit 10;


	-- Q12.Product count by category.

	Select category,count(*) as Product_count_by_category
	from dim_products
	group by category
	order by Product_count_by_category DESC ;

	-- Q13.Product count by BRAND 
	Select brand,count(*) as Product_count_by_brand
	from dim_products
	group by brand
	order by Product_count_by_brand DESC limit 10;

	-- Q14. Revenue Generate By Store Type
	Select s.store_type , Sum(f.total_amount) AS Revenue_Contribution
	from fact_sales as f
	join dim_stores as s
	on f.store_sk = s.store_sk
	group by s.store_type
	order by Revenue_Contribution DESC;

	-- Q15.Total revenue by product category.
	Select p.category,SUM(f.total_amount) As Revenue
	from fact_sales AS f
	join dim_products as p
	on f.product_sk = p.product_sk
	group by p.category
	order by Revenue desc limit 10;

	-- Q16.Total revenue by product brand.

	Select p.brand,SUM(f.total_amount) As Revenue
	from fact_sales AS f
	join dim_products as p
	on f.product_sk = p.product_sk
	group by p.brand
	order by Revenue desc limit 10;

	-- Q17.Total Revenue by the Customer Segments

	Select c.customer_segment,Sum(f.total_amount) As Revenue 
	from fact_sales as f
	join dim_customers as c
	on f.customer_sk = c.customer_sk
	group by c.customer_segment
	order by Revenue DESC ;

	-- Q18.Total revenue by customer_residential_location:

	select c.residential_location, Sum(f.total_amount) AS Revenue
	From fact_sales as f
	Join dim_customers as c
	on f.customer_sk = c.customer_sk
	group by c.residential_location
	order by Revenue  limit 10;

	-- Q19. Revenue by Location

	Select s.store_location , SUM(f.total_amount) As Revenue
	from fact_sales as f
	join dim_stores as s
	on f.store_sk = s.store_sk
	group by s.store_location
	order by Revenue desc LIMIT 10;

	-- Q20.Revenue contribution by customer segment.

	select c.customer_segment , sum(f.total_amount) as Revenue
	from fact_sales as f
	join dim_customers as c
	on f.customer_sk = c.customer_sk
	group by c.customer_segment
	order by Revenue desc ;

	-- Q21.Customer distribution by residential location.

	select residential_location,count(*) as customers 
	from dim_customers
	group by residential_location
	order by customers desC limit 5;

	-- Q.22 Top 10 best-selling products by revenue.

	select p.product_name,sum(f.total_amount) as Revenue
	from fact_sales as f 
	join dim_products as p
	on f.product_sk = p.product_sk
	group by p.product_name
	order by Revenue DESC Limit 10;

	-- Q23.Least 10 products selling by revenue.
	select p.product_name,sum(f.total_amount) as Revenue
	from fact_sales as f 
	join dim_products as p
	on f.product_sk = p.product_sk
	group by p.product_name
	order by Revenue Limit 10;

	-- Q24 Top products by sales count

	select p.product_name,Count(*) as Sales
	from fact_sales as f 
	join dim_products as p
	on f.product_sk = p.product_sk
	group by p.product_name
	order by Sales DESC Limit 10;

	-- Q25.Category-wise average product revenue.
	Select p.category,round(AVG(f.total_amount),2) AS Avg_revenue
	from fact_sales as f
	join dim_products as p
	on f.product_sk = p.product_sk
	group by p.category
	order by Avg_revenue DESC;

	-- Q26. Product performance by store type.
	Select p.product_name,s.store_type,SUM(f.total_amount) as Revenue
	from fact_sales as f
	join dim_products as p
	on f.product_sk = p.product_sk
	join dim_stores as s
	on f.product_sk = s.store_sk
	group by p.product_name,s.store_type
	order by Revenue DESC limit 10;

	-- Q27.Category WISE ranking
	SELECT 
		category,
		product_name,
		revenue,
		RANK() OVER (
			PARTITION BY category 
			ORDER BY revenue DESC
		) AS rank_in_category
	FROM (
		SELECT 
			p.category,
			p.product_name,
			SUM(f.total_amount) AS revenue
		FROM fact_sales f
		JOIN dim_products p
			ON f.product_sk = p.product_sk
		GROUP BY 
			p.category,
			p.product_name
	) t;

	-- Q28.Month-over-Month Revenue Growth (dim_dates)

	WITH monthly_sales AS (
		SELECT 
			d.year,
			d.month,
			SUM(f.total_amount) AS revenue
		FROM fact_sales f
		JOIN dim_dates d 
			ON DATE(f.sales_date) = d.full_date
		GROUP BY d.year, d.month
	),
	growth_calc AS (
		SELECT *,
			LAG(revenue) OVER (ORDER BY year, month) AS prev_month_revenue
		FROM monthly_sales
	)
	SELECT *,
		   ROUND((revenue - prev_month_revenue) / prev_month_revenue * 100, 2) 
		   AS growth_percentage
	FROM growth_calc;

	-- Q29.Does revenue depend on weekends?
	Select CASE
		WHEN weekday IN(6,7) THEN "Weekend"
		ELSE "Weekday"
		END AS day_type,
		Sum(f.total_amount) as Revenue
	from fact_sales as f
	join dim_dates as d
	on date(f.sales_date) = d.full_date
	group by day_type;


	-- Q3O.DAY WISE REVENUE 
	Select CASE
		WHEN weekday=1 THEN "Monday"
		WHEN weekday=2 THEN "Tuesday"
		WHEN weekday=3 THEN "Wednesday"
		WHEN weekday=4 THEN "Thursday"
		WHEN weekday=5 THEN "Friday"
		WHEN weekday=6 THEN "Saturday"
		WHEN weekday=7 THEN "Sunday"
		END AS day_type,
		Sum(f.total_amount) as Revenue
	from fact_sales as f
	join dim_dates as d
	on date(f.sales_date) = d.full_date
	group by day_type
	order by Revenue DESC;

	-- Q31.Which campaigns actually deserve budget?

	with campaings_revenue AS(
		select 	c.campaign_name,c.campaign_budget, Sum(f.total_amount) as Revenue
		from fact_sales as f
		join dim_campaigns as c
		on f.campaign_sk = c.campaign_sk
		group by c.campaign_name,c.campaign_budget
	)
	Select *,ROUND((Revenue-campaign_budget)/campaign_budget*100,2)
		as ROI
		from campaings_revenue
		order by ROI desc;


	-- Q32.campaings How many day work and Which campaings is large and How Much Revenue Generate


	Select c.campaign_name,
		d1.full_date As campaign_start_date,d2.full_date as campaign_end_date,
		datediff(d2.full_date,d1.full_date) + 1 AS campaign_days,
		SUM(F.total_amount) AS REVENUE
	from dim_campaigns as c
		join fact_sales as f
		on c.campaign_sk = f.campaign_sk
		join dim_dates as d1
		on c.start_date_sk = d1.date_sk
		join dim_dates as d2
		on c.end_date_sk = d2.date_sk
	group by c.campaign_name,d1.full_date,d2.full_date
	order by REVENUE desc limit 10;

	-- Q33.Are we over-dependent on 1 salesperson
	WITH salesperson_sales AS (
		SELECT 
			salesperson_sk,
			SUM(total_amount) AS revenue
		FROM fact_sales
		GROUP BY salesperson_sk
	)
	SELECT 
		salesperson_sk,
		revenue,
		ROUND(
			revenue / SUM(revenue) OVER () * 100, 2
		) AS contribution_percentage
	FROM salesperson_sales
	ORDER BY contribution_percentage  DESC LIMIT 10;

	-- Q34.Which salesperson_role helped generate the most revenue

	Select s.salesperson_role , Sum(f.total_amount) as Revenue 
	from fact_sales as f
	join dim_salespersons as s
	on f.salesperson_sk = s.salesperson_sk
	group by s.salesperson_role
	order by Revenue DESC;

	-- Q35.Which salesperson_role helped generate the most revenue WHERE ROLE SALESPERSON
	Select s.salesperson_name,s.salesperson_role , Sum(f.total_amount) as Revenue 
	from fact_sales as f
	join dim_salespersons as s
	on f.salesperson_sk = s.salesperson_sk
	group by s.salesperson_name,s.salesperson_role
	having s.salesperson_role = "Salesperson"
	order by Revenue DESC LIMIT 10;

	Select s.salesperson_name,s.salesperson_role , Sum(f.total_amount) as Revenue 
	from fact_sales as f
	join dim_salespersons as s
	on f.salesperson_sk = s.salesperson_sk
	group by s.salesperson_name,s.salesperson_role
	having s.salesperson_role = "senior Salesperson"
	order by Revenue DESC LIMIT 10;

