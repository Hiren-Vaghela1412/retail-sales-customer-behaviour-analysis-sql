#  🛒 Retail Sales & Customer Behavior Analysis (SQL Project)

## 📌 Project Overview

This project focuses on analyzing **retail sales performance and customer behavior** using a **star schema–based dataset** from Kaggle.
The analysis is performed entirely using __MySQL, covering data cleaning, descriptive analysis, customer segmentation, product performance, store insights, and time-based trends__.

## 📂 Dataset Information
- **Source:** Kaggle
- **Dataset Name:** Retail Store Star Schema Dataset
- **Link:**
  **[https://www.kaggle.com/datasets/shrinivasv/retail-store-star-schema-dataset](https://www.kaggle.com/datasets/shrinivasv/retail-store-star-schema-dataset)**

### 🔹 Fact Table
- fact_sales – transactional sales data (revenue, quantity, customer, product, store, date references)

### 🔹 Dimension Tables

- dim_customers
- dim_products
- dim_stores
- dim_dates
- dim_salesperson
- dim_campaigns

This structure enables **efficient analytical querying** and is widely used in **data warehousing & BI systems**.

## 📊 Key Business Insights

### 💰 Overall Sales Performance

- **Total Revenue:** ₹138.02 Million
- **Average Order Value (AOV):** ₹2,760.44

👉 Indicates strong sales performance with **stable customer purchasing behavior**.

---

### 👥 Customer Behavior Insights

- High-value customers contribute a **major share of revenue**
- Repeat purchases dominate transactions, showing **strong customer retention**
- Certain customer segments outperform others and are ideal for **targeted loyalty programs**

---

### 🧩 Customer Segment Revenue (Top 3)

- **Loyal Customers:** ₹14.16
- **Budget Shoppers:** ₹14.06M
- **Regular Customers:** ₹13.85M

👉 Revenue is driven primarily by **loyal and value-focused customers**.

---

### 📦 Product & Category Insights

- Certain product categories consistently outperform others
- A small group of products contributes a large share of total revenue
- Opportunity to optimize inventory by focusing on **high-margin products**.

---

### 🏬 Store Performance Insights

- Revenue varies significantly across stores
- Some stores consistently outperform others
- Store-type analysis helps identify **high-performing retail formats**

---

### 📅 Time-Based Trends

- Clear month-wise and year-wise revenue patterns
- Seasonal trends observed during specific quarters
- Useful for **forecasting and promotional planning**

---

## 🛠️ Tools & Technologies Used

- **Database:** MySQL
- **Query Techniques:**

  * Joins
  * Group By & Having
  * Subqueries
  * Common Table Expressions (CTEs)
  * Window Functions (RANK, DENSE_RANK)
* *Visualization:* Microsoft Excel (Pivot Tables, Charts, Slicers)
* *Presentation:* Insight-driven single-slide dashboard
  
# 👤 Author
- __HIREN VAGHELA__
- __Data Science | SQL | Student Project__
