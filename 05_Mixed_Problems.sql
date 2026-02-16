/*QUESTION:
Which accounts have total revenue greater than the average total revenue per account?

REWRITE:
1) Final Output: Multiple rows - account_id or name.
2) Group/Scope: Group by account.
3) Selection Logic: Keep only accounts whose total revenue is greater than the average total revenue per account.
4) Final Calculation: SUM(total_amt_usd) for each account compared against compared against AVG of those totals.

LOGIC: 
First calculate SUM(total_amt_usd) for each account. Then calculate the average of those totals.
Return only accounts whose total revenue is greater than the average value.*/

SELECT account_id
FROM
       (SELECT account_id,
              SUM(total_amt_usd) AS total_revenue
       FROM orders
       GROUP BY account_id
       ) t
WHERE total_revenue >
              (SELECT AVG(total_revenue)
              FROM
                     (SELECT account_id,
                            SUM(total_amt_usd) AS total_revenue
                     FROM orders
                     GROUP BY account_id
                     ) x
              );


/*QUESTION:
For each region, how many sales reps have total revenue greater than the average sales rep revenue in that same region?

REWRITE:
1) Final Output: Multiple rows - region and count of sales reps.
2) Group/Scope: Group by region and sales rep.
3) Selection Logic: For each region:
                    Calculate total revenue for each sales rep.
                    Calculate the average of these total revenues.
                    Keep only sales reps whose total revenue is greater than their region's average.
4) Final Calculation: COUNT of sales_rep per region after filtering.

LOGIC:
First calculate total revenue for each sales rep inside each region.
Then calculate the average of those revenues for each region.
Keep only the sales reps whose total revenue is greater than their region's average.
Finally, count how many such sales reps exist in each region.*/

WITH t1 AS (SELECT r.name AS region,
                   sr.id AS sales_rep_id,
                   SUM(o.total_amt_usd) AS total_revenue
            FROM region r
            JOIN sales_reps sr ON r.id = sr.region_id
            JOIN accounts a ON a.sales_rep_id = sr.id
            JOIN orders o ON o.account_id = a.id
            GROUP BY r.name, sr.id
            ),
     t2 AS (SELECT region,
                   AVG(total_revenue) AS avg_revenue
            FROM t1
            GROUP BY region
            )
SELECT t1.region,
       COUNT(t1.sales_rep_id) AS num_sales_reps
FROM t1
JOIN t2
ON t1.region = t2.region
WHERE t1.total_revenue > t2.avg_revenue
GROUP BY t1.region;


/*QUESTION:
Which customers placed more orders than the average number of orders per customer?

REWRITE:
1) Final Output: Multiple rows - account_id or name.
2) Group/Scope: Group orders by account.
3) Selection Logic: Calculate count of orders for each customer. Calculate the average of those counts.
                    Keep only customers whose total number of orders is greater than the average number of orders per customer.
4) Final Calculation: COUNT(*) per customer compared against AVG of those counts.

LOGIC:
First calculate number of orders for each customer. Then calculate AVG of those order counts.
Return only customers whose order count is greater than that average.*/

WITH t1 AS (SELECT a.id AS account_id,
                   a.name AS account_name,
                   COUNT(*) AS total_orders
            FROM accounts a
            JOIN orders o
            ON a.id = o.account_id
            GROUP BY a.id, a.name),

     t2 AS (SELECT AVG(total_orders) AS avg_order
            FROM t1)

SELECT t1.account_name
FROM t1
WHERE total_orders >
              (SELECT avg_order
               FROM t2);


/*QUESTION:
Which sales reps manage more accounts than the average number of accounts per sales rep?

REWRITE:
1) Final Output: Multiple rows - sales_rep_id or name.
2) Group/Scope: Group by sales rep.
3) Selection Logic: Calculate count of accounts for each sales rep. Calculate the average of those counts.
                    Keep only sales reps whose total number of accounts is greater than the average number of accounts per sales rep.
4) Final Calculation: COUNT(*) per sales rep compared against AVG of those counts.

LOGIC:
First calculate number of accounts for each sales rep. Then calculate the AVG of those count of accounts.
Return only sales reps whose account count is greater than that average.*/

WITH t1 AS (SELECT sales_rep_id,
                   COUNT(*) AS account_count
            FROM accounts
            GROUP BY sales_rep_id),

     t2 AS (SELECT AVG(account_count) AS avg_account_count
            FROM t1)

SELECT sr.name AS sales_rep_name
FROM t1
JOIN sales_reps sr
ON t1.sales_rep_id = sr.id
WHERE account_count >
              (SELECT avg_account_count

               FROM t2);
