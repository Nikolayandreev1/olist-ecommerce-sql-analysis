# E-commerce Analytics Dashboard (Olist)

This project presents an end-to-end e-commerce analytics solution using SQL and Power BI.
The goal is to analyze business performance, customer behavior, and retention patterns using real-world transactional data.

---

## Project Overview

The project simulates real-world analytics tasks, including:

* KPI analysis (GMV, AOV, total orders)
* Customer behavior analysis
* Product and category performance
* Cohort-based retention analysis

---

## Tools & Technologies

* PostgreSQL
* SQL (CTEs, joins, window functions)
* DBeaver
* Power BI

---

## Project Structure


 sql/
   schema.sql               # Database schema
   import.sql               # Data loading
   01_data_checks.sql       # Data validation
   02_kpi_analysis.sql      # Revenue, AOV, orders
   03_product_analysis.sql  # Category & product insights
   04_customer_analysis.sql # Customer behavior
   05_cohort_analysis.sql   # Retention analysis
   06_payments_analysis.sql # Payment insights
 
  dashboard/
        ecommerce_dashboard.pbix
 
  images/
        overview.png
        categories.png
        cohort.png

  data/
    cohort_long_table.csv
 
  README.md


---

## Key Insights

* Most customers make only one purchase
* Repeat purchase rate is extremely low (~3%)
* Retention drops sharply after the first month (<1%)
* No improvement in retention across cohorts over time
* Revenue is concentrated in a few product categories

---

## Cohort Analysis

Customers are grouped by the month of their first purchase, and their activity is tracked over time.

Key findings:

* Retention drops significantly after the first month
* Long-term retention is nearly zero
* Customers rarely return after their first purchase

This suggests that the business relies heavily on customer acquisition rather than retention.

---

## Business Interpretation

The analysis indicates a transactional business model with low customer loyalty.
This opens opportunities for:

* Loyalty programs
* Personalized marketing
* Retention-focused strategies

---

## Next Steps

* Enhance dashboard with additional KPIs
* Add retention curve visualization
* Implement customer segmentation (RFM analysis)
* Improve storytelling and business recommendations

---

## Project Goal

This project demonstrates the ability to:

* Write analytical SQL queries
* Build end-to-end data analysis workflows
* Translate data into business insights
* Create interactive dashboards in Power BI

---

