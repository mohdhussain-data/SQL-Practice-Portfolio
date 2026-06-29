# SQL Data Analysis Portfolio

This repository contains SQL-based data analysis projects focused on solving real-world business problems using PostgreSQL.

---

## 📂 Projects

### 1. Sales Performance Analysis | SQL

**Dataset:** Parch & Posey B2B Sales Dataset (5 tables: accounts, orders, sales_reps, region, web_events)

**Business Questions Answered:**
- Which customers generate the most revenue?
- Which regions and sales reps are top performers?
- How has revenue grown year-over-year?
- Which marketing channels drive the most engagement?
- How can customers be segmented by revenue tier?

**Key Analysis Performed:**
- Customer revenue contribution and revenue share %
- Regional performance comparison across 4 regions
- Sales rep ranking by revenue contribution
- Year-over-year growth using LAG window function
- Customer segmentation using NTILE(4) quartiles
- Repeat vs one-time customer classification
- Marketing channel engagement analysis

**📊 Key Findings:**
1. **Top 25% of customers contribute ~64% of total revenue** — strong Pareto distribution
2. **~95% repeat customer rate** — high retention in B2B sales model
3. **Northeast + Southeast drive 60%+ of total revenue** — dominant regional markets
4. **Direct channel accounts for ~58% of web engagement** — brand recognition driving traffic
5. **Strong YoY growth 2014–2016** — consistent business expansion period
6. **Low revenue concentration at customer level** — top accounts contribute only 1–1.6% each

**🛠️ SQL Techniques Used:**
- Complex multi-table JOINs (4-table joins)
- Aggregations and GROUP BY
- Window Functions: RANK, LAG, NTILE, SUM OVER
- Common Table Expressions (CTEs)
- Subqueries and nested aggregations
- NULLIF for division safety
- DATE_TRUNC for time-series analysis

📁 Location: `project/`

---

## 🛠️ Skills

- SQL (PostgreSQL)
- Joins, Aggregations
- Window Functions (LAG, NTILE, RANK, ROW_NUMBER)
- CTEs & Subqueries
- Data Cleaning (COALESCE, CAST, SUBSTR)
- Business Data Analysis

---

## 📦 Dataset

- Parch & Posey (B2B sales dataset simulation)
- Tables: accounts, orders, sales_reps, region, web_events

---

## 🎯 Purpose

Demonstrates practical SQL skills required for Data Analyst roles by solving real business problems and generating actionable insights from relational data.

---

## 📬 Connect

- **LinkedIn:** https://linkedin.com/in/mohd-hussain-
- **GitHub:** https://github.com/mohdhussain-data
