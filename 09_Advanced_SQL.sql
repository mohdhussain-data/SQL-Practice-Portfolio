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


/*QUESTION:
Analyze short term user engagement by identifying web events that occur shortly after another event from the same account.
Return pairs of web events where the second event occurs within 1 day after the first event for the same account.
Include the account_id, timestamps of both events, and the marketing channel used for each event.

REWRITE:
1) Final Output: Multiple rows - account_id, first_event_time, first_channel, second_event_time, and second_channel.
2) Group/Scope: Compare web events within the same account.
3) Selection Logic: Perform a SELF JOIN on the web_events table so that each event can be compared with later events from the same account.
4) Final Calculation: Filter the results so that the second event occurs:
                      after the first event.
                      within 1 day of the first event.

LOGIC:
The web_events table records multiple interactions for each account over time.
To analyze quick follow-up engagement:
1. Create two instances of the web_events table.
       One instance represents the first event.
       The other represents the second event occurring shortly after.
2. Match rows where:
       same account
       second event happened later
       second event occurred within 1 day.
3. This reveals sequential web interactions that occur close together, which may indicate strong engagement or
strong marketing channle engagement.*/

SELECT w1.account_id,
       w1.occurred_at AS first_event_time,
       w1.channel AS first_channel,
       w2.occurred_at AS second_event_time,
       w2.channel AS second_channel
FROM web_events w1
LEFT JOIN web_events w2
ON w1.account_id = w2.account_id
AND w2.occurred_at > w1.occurred_at
AND w2.occurred_at <= w1.occurred_at + INTERVAL '1 day'
AND w2.id <> w1.id
ORDER BY w1.account_id, w1.occurred_at;