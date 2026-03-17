E-commerce SQL Analytics (Olist)



This project explores an e-commerce dataset (Olist) using SQL to analyze business performance, customer behavior, and retention.







Project Overview



The goal of this project is to extract insights from transactional data and simulate real-world analytics tasks such as:



\-KPI analysis

\-Customer behavior analysis

\-Product performance analysis

\-Cohort retention analysis







Tools Used



\-PostgreSQL

\-SQL (CTEs, joins, window functions)

\-DBeaver

\-Power BI (planned)







&#x20;Project Structure



\-schema.sql→ database schema

\-import.sql→ data loading

* 01\_data\_checks.sql → data validation
* 02\_kpi\_analysis.sql → revenue, AOV, orders
* 03\_product\_analysis.sql → category \& product insights
* 04\_customer\_analysis.sql → repeat customers \& behavior
* 05\_cohort\_analysis.sql → retention analysis
* 06\_payments\_analysis.sql → payment insights







Key Insights



\- Most customers make only one purchase

\- Repeat purchase rate is low (\~3%)

\- Retention drops significantly after the first month

\- Revenue is concentrated in a few product categories





Cohort Analysis



Customers are grouped by the month of their first purchase, and their activity is tracked over time to measure retention.





Next Steps



\- Build Power BI dashboard

\- Add visualizations

\- Improve business insights

