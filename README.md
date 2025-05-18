# DataAnalytics-Assessment

This repository contains my solutions to the Cowrywise SQL technical assessment. Below is a detailed breakdown of my approach for each question, along with the challenges encountered and how I resolved them.


Question 1. Customers with Funded Savings and Investment Plans
1. Identifying Funded Users:
•	To find customers with both funded savings and investment plans, I used Common Table Expressions (CTEs) to separately aggregate savings and investment data.
•	The SavingsCTE captured users with at least one funded savings plan, identified by is_regular_savings = 1 and positive confirmed_amount.
•	The InvestmentCTE focused on users with at least one funded investment plan, identified by is_a_fund = 1 and positive amount.
•	I then joined these CTEs with the users_customuser table to include only users with both funded savings and investments.
2. Data Aggregation and Formatting:
•	I used the SUM() function to calculate the total funded amounts, converting from kobo to naira by dividing by 100.
•	The COALESCE() function ensured that users without certain data (e.g., no deductions) still returned valid results, preventing NULL values from disrupting the final output.
•	For the final display, I combined first_name and last_name to match the required output format.
3. Sorting and Presentation:
•	I sorted the results by total_deposits in descending order to prioritize users with the highest total contributions.
•	Used ROUND() to ensure consistent formatting of the total deposits with two decimal places, aligning with the output specification.

Challenges:
1. Handling Missing Columns:
•	Initially, I was unable to find a 'amount_withdrawn' column.
•	This was resolved after identifying deduction_amount as the correct column for net savings calculations.
2. Data Consistency:
•	All amount fields were in kobo, requiring consistent conversion to naira to avoid misleading figures.
•	This required careful attention to ensure accurate financial reporting.
3. Joining Logic:
•	Using INNER JOINs was critical for filtering out unfunded users, but this also meant potentially excluding users with incomplete data.
•	This was a deliberate trade-off to meet the "at least one funded plan" requirement.
________________________________________
Question 2 Average Transactions per Customer per Month
1.	Aggregating Transaction Data:
o	Calculated the total number of confirmed transactions per customer from the savings transactions table.
o	Extracted the date component from the timestamp to ensure accurate month calculations, ignoring the time portion.
2.	Determining Active Months:
o	Computed the number of active months for each customer by finding the difference between the earliest and latest transaction dates, then adding one month to avoid zero-month cases.
3.	Calculating Average Transactions per Month:
o	Divided the total transactions by active months to get the average monthly transaction rate for each customer.
o	Used safeguards (such as NULLIF) to prevent division by zero errors.
4.	Categorizing Customers by Frequency:
o	Grouped customers into three categories based on their average monthly transactions:
	High Frequency: 10 or more transactions/month
	Medium Frequency: Between 3 and 9 transactions/month
	Low Frequency: 2 or fewer transactions/month
o	Ensured consistent categorization by applying the same case logic in grouping.
5.	Ordering Results:
o	Used a custom ordering function (FIELD) to display categories in the desired priority order (High → Medium → Low) rather than alphabetical order.

Challenges Encountered and Resolutions
1.	Handling Timestamp with Time Component:
o	The transaction dates included timestamps, which initially caused inaccurate month calculations.
o	Resolved by extracting only the date part using DATE() to focus solely on the day, month, and year.
2.	Calculating Active Months Accurately:
o	Initial attempts using DATEDIFF() failed due to incorrect usage or function limitations.
o	Switched to using TIMESTAMPDIFF(MONTH, start_date, end_date) to correctly compute the difference in months.
3.	Avoiding Division by Zero:
o	When a customer had transactions within a single month, the active month count could be zero or cause division errors.
o	Mitigated this by using NULLIF in the denominator to safely handle cases where the active months count might be zero.
4.	Ensuring Desired Output Ordering:
o	The default alphabetical ordering of categories did not match the required order.
o	Implemented the FIELD() function in the ORDER BY clause to explicitly control the category order in the final result.

