/*QUESTION:
Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.

REWRITE:
1) Final Output: Multiple rows - region, sales_rep, total_sales.
2) Group/Scope: Group orders by region and sales_rep.
3) Selection Logic: For each region, identify the sales_rep with the highest total sales.
4) Final Calculation: SUM(total_amt_usd).

LOGIC:
First calculate total sales for each sales rep in each region.
Then find the maximum total sales inside each region.
Finally return the sales_rep whose total sales equals that maximum.*/

WITH t1 AS (SELECT sr.name AS sales_rep, r.name AS region, SUM(o.total_amt_usd) AS total_sales
            FROM sales_reps sr
            JOIN region r ON r.id = sr.region_id
            JOIN accounts a ON a.sales_rep_id = sr.id
            JOIN orders o ON o.account_id = a.id
            GROUP BY sr.name, r.name),
     t2 AS (SELECT region, MAX(total_sales) AS max_sales
            FROM t1
            GROUP BY region)
SELECT t1.sales_rep, t1.region, t1.total_sales
FROM t1
JOIN t2
ON t1.region = t2.region AND t1.total_sales = t2.max_sales;


/*QUESTION:
Which accounts have total revenue greater than the average total revenue per account?

REWRITE:
1) Final Output: Multiple rows - account_id or name.
2) Group/Scope: Group by account.
3) Selection Logic: Keep only accounts whose total revenue is greater than the average total revenue per account.
4) Final Calculation: SUM(total_amt_usd) for each account compared against AVG of those totals.

LOGIC:
First calculate SUM(total_amt_usd) for each account. Then calculate the average of these totals.
Return only accounts whose total revenue is greater than that average.*/

WITH t1 AS (SELECT account_id,
                   SUM(total_amt_usd) AS total_revenue
            FROM orders
            GROUP BY account_id),

     t2 AS (SELECT AVG(total_revenue) AS avg_revenue
            FROM t1)

SELECT a.name
FROM accounts a
JOIN t1
ON a.id = t1.account_id
WHERE t1.total_revenue >
              (SELECT avg_revenue
               FROM t2);


/*QUESTION:
For each region, how many sales reps have total revenue greater than the average sales rep revenue in that same region?

REWRITE:
1) Final Output: Multiple rows - region_name and number of sales reps.
2) Group/Scope: Group by region and sales rep.
3) Selection Logic: For each region:
                    Calculate total revenue for each sales rep.
                    Calculate the average of these total revenues per region.
                    Keep only sales reps whose total revenue is greater than their region's average.
4) Final Calculation: COUNT of sales rep per region after filtering.*/

WITH t1 AS (SELECT r.name AS region,
                   sr.id AS sales_rep_id,
                   SUM(o.total_amt_usd) AS revenue_per_rep_per_region
            FROM region r
            JOIN sales_reps sr
            ON r.id = sr.region_id
            JOIN accounts a
            ON a.sales_rep_id = sr.id
            JOIN orders o
            ON o.account_id = a.id
            GROUP BY r.name, sr.id),

     t2 AS (SELECT region,
                   AVG(revenue_per_rep_per_region) AS avg_revenue_per_region
            FROM t1
            GROUP BY region),

     t3 AS (SELECT t1.region,
                   t1.sales_rep_id
            FROM t1
            JOIN t2
            ON t1.region = t2.region
            WHERE t1.revenue_per_rep_per_region > t2.avg_revenue_per_region)

SELECT t3.region,
       COUNT(*) AS rep_count
FROM t3
GROUP BY t3.region;