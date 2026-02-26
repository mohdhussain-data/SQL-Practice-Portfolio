/*QUESTION:
In the accounts table, how many companies use each website extension?

REWRITE:
1) Final Output: Multiple rows - website_extension and count.
2) Group/Scope: Group by website extension.
3) Seleciton Logic: Extract the last three characters from the website column.
4) Final Calculation: COUNT(*) for each extracted extension.

LOGIC:
First extract the last three characters from each website. Then group by those extracted values.
Finally count how many times each extension appears.*/

SELECT RIGHT(website, 3) AS domain,
       COUNT(*) AS num_companies
FROM accounts
GROUP BY RIGHT(website, 3)
ORDER BY num_companies DESC;


/*QUESTION:
From the accounts table, pull the first letter of each company name to see the distribution of each company names,
that begin with each letter or number.

REWRITE:
1) Final Output: Multiple rows - first_char and count.
2) Group/Scope: Group by first letter.
3) Selection Logic: Extract the first character from the name column.
4) Final Calculation: COUNT(*) for each extracted letter.

LOGIC:
First extract the first character from each name. Then group by those extracted values.
Finally count how many times each character appears*/

SELECT LEFT(UPPER(name), 1) AS first_char,
       COUNT(*) AS num_companies
FROM accounts
GROUP BY LEFT(UPPER(name), 1)
ORDER BY num_companies DESC;


/*QUESTION:
Use the accounts table and a CASE statement to create two groups:
one group of company names that start with a number.
And a second group of those company names that start with a letter. What proportion of company names start with a letter?

REWRITE:
1) Final Output: One row - showing proportion (percentage) of company names that starts with a letter.
2) Group/Scope: No grouping by rows. We classify rows using CASE.
3) Selection Logic: Use CASE to label each company as:
                    "number" if name starts with digit. "letter" otherwise.
4) Final Calculation: Count how many are letters/total companies.

LOGIC:
Extract first character of each company name. Use CASE to mark as number-start or letter-start.
Count letters and total rows. Divide letter count by total count.*/

SELECT SUM
              (CASE WHEN LEFT(name, 1) NOT BETWEEN '0' AND '9'
              THEN 1
              ELSE 0
              END) * 1.0 /
       COUNT(*) AS proportion_starting_with_letter
FROM accounts;


/*QUESTION:
Use the accounts table to create first and last name columns that hold the first and last names for the primary_poc.

REWRITE:
1) Final Output: Multiple rows - first_name and last_name.
2) Group/Scope: No grouping required.
3) Selection Logic: Use STRPOS to find the position of the space between first and last name.
                    Extract characters before the space for first_name.
                    Extract characters after the space for last_name.
4) Final Calculation: Use LEFT and RIGHT (or SUBSTR) with STRPOS to separate the name.

LOGIC:
Find the position of the space in primary_poc.
Extract everything before the space as first_name.
Extract everything after the space as last_name.*/

SELECT 
    SUBSTR(primary_poc, 1, STRPOS(primary_poc, ' ') - 1) AS first_name,
    SUBSTR(primary_poc, STRPOS(primary_poc, ' ') + 1) AS last_name
FROM accounts;