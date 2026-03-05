/*QUESTION:
Create a running total of standard_amt_usd over order time. 
Return the amount for each row and the cumulative running total.

REWRITE:
1) Final Output: Multiple rows - standard_amt_usd and running_total.
2) Group/Scope: No grouping required.
3) Selection Logic: Order rows by occurred_at and calculate cumulative sum.
4) Final Calculation: SUM(standard_amt_usd) using window function.

LOGIC:
Order the dataset by occurred_at, Use SUM() as a window function to continuously add standard_amt_usd values row by row.*/

SELECT standard_amt_usd,
       SUM(standard_amt_usd)
       OVER (ORDER BY occurred_at) AS running_total
FROM orders;


/*QUESTION:
Create a running total of standard_amt_usd for each account over time.
Return the account_id, order time, order amount, and running total.

REWRITE:
1) Final Output: Multiple rows - account_id, occurred_at, standard_amt_usd, and running_total.
2) Group/Scope: Partition rows by account_id.
3) Selection Logic: Within each account partition, order rows by occurred_at so the running calculation follows chronological order.
4) Final Calculation: Running SUM of standard_amt_usd using window function.

LOGIC:
Split the dataset into account groups using PARTITION BY account_id.
Within each account, order the rows by occurred_at.
Calculate a cumulative SUM of standard_amt_usd that resets when a new account begins.*/

SELECT account_id,
       occurred_at,
       standard_amt_usd,
       SUM(standard_amt_usd)
       OVER (PARTITION BY account_id ORDER BY occurred_at) AS running_total
FROM orders;


/*QUESTION:
Create a running total of standard_amt_usd over order time, but partition the calculation by year.
Return the amount for each row, the truncated year, and the running total within that year.

REWRITE:
1) Final Output: Multiple rows - standard_amt_usd, year, and running_total.
2) Group/Scope: Partition rows by year using DATE_TRUNC.
3) Selection Logic: Order rows by occurred_at within each year.
4) Final Calculation: Running SUM of standard_amt_usd within each year.

LOGIC:
Extract the year from occurred_at using DATE_TRUNC.
Partition the dataset by this year value so each year forms its own window.
Within each year, order rows by occurred_at.
Calculate a cumulative SUM() of standard_amt_usd that resets when the year changes.*/


SELECT standard_amt_usd,
       DATE_TRUNC('year', occurred_at) AS year,
       SUM(standard_amt_usd)
       OVER (PARTITION BY DATE_TRUNC('year', occurred_at) ORDER BY occurred_at) AS running_total
FROM orders;


/*QUESTION:
Number the orders for each account based on order time.

REWRITE:
1) Final Output: Multiple rows - id, account_id, occurred_at, order_number.
2) Group/Scope: Partition the dataset by account_id so numbering restarts for each account.
3) Selection Logic: Order rows by occurred_at within each account.
4) Final Calculation: Use ROW_NUMBER() window function.

LOGIC:
Split the dataset into groups based on account_id using PARTITION BY.
Within each account group, order rows by occurred_at.
Use ROW_NUMBER() to assign sequential numbers to each order. The numbering restarts when a new account begins.*/

SELECT id,
       account_id,
       occurred_at,
       ROW_NUMBER() OVER (PARTITION BY account_id ORDER BY occurred_at) AS order_number
FROM orders;


/*QUESTION:
Rank the total paper ordered for each account from highest to lowest.
Return the id, account_id, total, and the rank of each order within its account.

REWRITE:
1) Final Output: Multiple rows - id, account_id, total, total_rank.
2) Group/Scope: Partition rows by account_id.
3) Selection Logic: Order rows by total in descending order within each account.
4) Final Calculation: Use RANK() window function to assign rankings.

LOGIC:
Split the dataset into account groups using PARTITION BY account_id.
Within each row, order rows by total in descending order.
Apply the RANK() window function to assign a ranking to each order based on total paper ordered.*/


SELECT id,
       account_id,
       total,
       RANK() OVER (PARTITION BY account_id ORDER BY total DESC) AS total_rank
FROM orders;


/*QUESTION:
Rank the total paper ordered for each account using DENSE_RANK, from highest to lowest.
Return id, account_id, total, and the dense rank.

REWRITE:
1) Final Output: Multiple rows - id, account_id, total, desne_rank.
2) Group/Scope: Partition the dataset by account_id.
3) Selection Logic: Order rows by total in descending order within each account.
4) Final Calculation: Use DENSE_RANK() window function.

LOGIC:
Split the dataset into groups using PARTITION BY account_id.
Within each account, order rows by total in descending order.
Apply DENSE_RANK() to assign rankings without skipping numbers when ties occur.*/

SELECT id,
       account_id,
       total,
       DENSE_RANK()
       OVER (PARTITION BY account_id ORDER BY total DESC) AS desne_rank
FROM orders;