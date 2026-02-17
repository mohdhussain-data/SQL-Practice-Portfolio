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


/*QUESTION:
Which customers have an average order value greater than the overall average order value?

REWRITE:
1) Final Output: Multiple rows - account_id or name.
2) Group/Scope: Group orders by account.
3) Selection Logic: Keep only customers whose average order value is greater than the overall average order value.
4) Final Calculation: AVG(total_amt_usd) for each account compared against the overall average order value.

LOGIC:
First calculate AVG(total_amt_usd) for each account. Calculate the average of the per-account average order values.
Keep only accounts whose AVG(total_amt_usd) is greater than that overall average order value.*/

WITH t1 AS (SELECT account_id,
                   AVG(total_amt_usd) AS avg_order_value
            FROM orders
            GROUP BY account_id),

     t2 AS (SELECT AVG(avg_order_value) AS overall_avg_order_value
            FROM t1)

SELECT account_id
FROM t1
CROSS JOIN t2
WHERE t1.avg_order_value > t2.overall_avg_order_value;


/*QUESTION:
Which accounts have placed more orders than the average number of orders per account?

REWRITE:
1) Final Output: Multiple rows - account_id or name.
2) Group/Scope: Group orders by account.
3) Selection Logic: First calculate COUNT(*) for each account. Then calculate the average of these counts.
                    Keep only accounts whose total order count is greater than the average order count.
4) Final Calculation: COUNT(*) for each account compared against AVG of those counts.

LOGIC:
First COUNT(*) for each account. Then calculate the average of these counts.
Return only accounts whose COUNT(*) is more than that average.*/

WITH t1 AS (SELECT account_id,
                   COUNT(*) AS total_orders
            FROM orders
            GROUP BY account_id),

     t2 AS (SELECT AVG(total_orders) AS avg_orders
            FROM t1)

SELECT t1.account_id
FROM t1
CROSS JOIN t2
WHERE t1.total_orders > t2.avg_orders;


/*QUESTION:
Which sales reps manage more accounts than the average number of accounts per sales rep?

REWRITE:
1) Final Output: Multiple rows - sales rep id.
2) Group/Scope: Group accounts by sales rep id.
3) Selection Logic: Calculate number of accounts managed by each sales rep. Calculate the average of those counts.
                    Keep only sales reps whose count is greater than the average.
4) Final Calculation: COUNT(*) per sales rep compared against AVG of those counts.

LOGIC:
First calculate COUNT(*) of accounts for each sales rep. Then calculate the average of these counts.
Return only sales reps whose count is greater than that average.*/

WITH t1 AS (SELECT sales_rep_id,
                   COUNT(*) AS total_accounts
            FROM accounts
            GROUP BY sales_rep_id),

     t2 AS (SELECT AVG(total_accounts) AS avg_accounts
            FROM t1)

SELECT t1.sales_rep_id
FROM t1
CROSS JOIN t2
WHERE t1.total_accounts > t2.avg_accounts;  