# DataAnalytics-Assessment

This repository contains my solutions to the Cowrywise SQL technical assessment. Below is a breakdown of my approach for each question, along with the challenges encountered and how I resolved them.

## Question 1. Customers with Funded Savings and Investment Plans

Approach:

To identify customers with at least one funded savings plan and one funded investment plan, I took the following steps:

Filtering Funded Savings Plans: Extracted customers with at least one funded savings plan by checking for positive confirmed amounts.

Filtering Funded Investment Plans: Extracted customers with at least one funded investment plan using the is_a_fund flag.

Combining Savings and Investments: Joined these results to find customers with both funded savings and investments.

Calculating Total Deposits: Summed confirmed amounts for each customer to get their total deposits.

Sorting by Total Deposits: Ordered the final results by total deposits in descending order.

Challenges:

Handling users with multiple funded plans without double-counting.

Correctly accounting for deductions to avoid inflated deposit totals.

Properly aligning transaction status filtering for accurate results.

## Question 2. Average Transactions per Customer per Month

Approach:

To calculate the average number of transactions per customer per month and categorize them by frequency, I followed these steps:

Calculating Active Months: Used the earliest and latest transaction dates to calculate active months for each customer.

Calculating Average Transactions per Month: Divided total transactions by active months to get average monthly transaction rates.

Categorizing Customers: Used a case statement to classify customers into High, Medium, and Low frequency groups.

Ordering by Frequency: Ensured the final results were ordered with High frequency first, followed by Medium and Low.

Challenges:

Handling zero active months to avoid division errors.

Properly aligning transaction counts to customer active periods.

Ensuring consistent categorization across customer groups.

## Question 3. Inactive Accounts in the Last Year

Approach:

To identify accounts (both savings and investments) with no transactions in the past 365 days, I took the following approach:

Finding Last Transaction Date: Extracted the most recent transaction date for each account.

Calculating Inactivity Days: Subtracted the last transaction date from the current date to calculate inactivity.

Filtering Active Accounts: Excluded accounts that had recent transactions to focus only on genuinely inactive accounts.

Combining Savings and Investment Data: Used a UNION to combine savings and investment accounts into a single result set.

Challenges:

Handling accounts with no transactions at all, which could result in null values.

Correctly calculating inactivity days to avoid false positives.

Efficiently joining across multiple account types.

## Question 4. Estimated CLV Calculation

Approach:

For this task, I estimated customer lifetime value (CLV) using account tenure and transaction volume as follows:

Calculating Tenure: Measured the time since the customer's signup date in months.

Counting Transactions: Counted all successful transactions for each customer.

Estimating CLV: Used a simplified model to estimate CLV based on average transaction value and transaction frequency.

Filtering Inactive Customers: Excluded customers with zero transactions to avoid skewed results.

Challenges:

Correctly calculating tenure in months for accurate CLV estimates.

Avoiding division by zero for new accounts.

Properly converting kobo to naira for accurate profit calculations.

## Conclusion

This assessment covered a range of SQL skills including CTEs, complex joins, aggregation, and data filtering. The main challenges involved managing null values, division by zero, and accurately grouping data to avoid double counting or miscategorization.

