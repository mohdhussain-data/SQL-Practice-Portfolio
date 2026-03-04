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