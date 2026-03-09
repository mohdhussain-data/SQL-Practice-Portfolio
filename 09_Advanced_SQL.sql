/*QUESTION:
Identify relationship gaps between accounts and sales representatives.
Return all accounts and sales reps, including:
- accounts that do not currently have a sales representative assigned.
- sales representatives who do not manage any accounts.
This helps management detect underutilized sales reps and accounts without coverage.

REWRITE:
1) Final Output: Multiple rows showing accounts and sales rep relationships.
2) Group/Scope: No grouping required. Row-level relationship comparison.
3) Selection Logic: Perform a FULL OUTER JOIN between accounts and sales_reps using sales_rep_id.
4) Final Calculation: Return account_id, account_name, sales_rep_id, and sales_rep_name.
                      Unmatched rows reveal accounts without reps and reps without accounts.

LOGIC:
Accounts and sales reps are connected through sales_rep_id. However, some accounts may not yet have an assigned sales rep.
Similarly, some sales reps may not currently manage any accounts. A FULL OUTER JOIN allows us to keep:
- all accounts
- all sales reps
Matched rows show valid relationships. Unmatched rows expose coverage gaps in the sales organization.*/

SELECT a.id AS account_id,
       a.name AS account_name,
       sr.id AS sales_rep_id,
       sr.name AS sales_rep_name
FROM accounts a
FULL OUTER JOIN sales_reps sr
ON a.sales_rep_id = sr.id
WHERE a.id IS NULL OR sr.id IS NULL;

-- Note: In the Parch & Posey dataset this query returns no rows because the data is clean.
-- However, this pattern is useful for detecting orphan records in real production datasets.


/*QUESTION:
Identify high-value orders compared to the average order value of the entire dataset.
Return all orders where the order amount is greater than the overall average order amount.
Show the order id, account id, order amount, and the overall average for comparison.

REWRITE:
1) Final Output: Multiple rows - order_id, account_id, total_amt_usd, and avg_order_value.
2) Group/Scope: No grouping in the final result. Each order is evaluated individually.
3) Selection Logic: Compute the overall average order value using a subquery.
                    Join each order to this average using a comparison operator (>).
4) Final Calculation: Compare orders.total_amt_usd against the calculated average order value.

LOGIC:
First calculate the overall average order value from the orders table.
Then compare each individual order to the value.*/

SELECT o.id AS order_id,
       o.account_id,
       o.total_amt_usd,
       avg_table.avg_order_value
FROM orders o
CROSS JOIN
       (SELECT AVG(total_amt_usd) AS avg_order_value
       FROM orders
       ) avg_table
ON o.total_amt_usd > avg_table.avg_order_value;