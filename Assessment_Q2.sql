-- Using CTEs to calculate transactions and average monthly transactions per customer and categorize based on the average transactions per month
WITH CustomerTransactions AS (
    SELECT 
        s.owner_id,
        COUNT(*) AS total_transactions,
        TIMESTAMPDIFF(MONTH, MIN(DATE(s.transaction_date)), MAX(DATE(s.transaction_date))) + 1 AS active_months,  -- Extracting only the date
         -- Calculating the average number of transactions per month, avoiding division by zero
        ROUND(COUNT(*) * 1.0 / NULLIF(TIMESTAMPDIFF(MONTH, MIN(DATE(s.transaction_date)), MAX(DATE(s.transaction_date))) + 1, 0), 2) AS avg_transactions_per_month
    FROM savings_savingsaccount s
    WHERE s.transaction_status = 'success'  -- Filtering based on only successful transactions
    GROUP BY s.owner_id
),
CategorizedCustomers AS (
    SELECT
        CASE  -- Defining frequency categories based on average transactions per month
            WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
            WHEN avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,
        COUNT(owner_id) AS customer_count,
        ROUND(AVG(avg_transactions_per_month), 2) AS avg_transactions_per_month
    FROM CustomerTransactions
    GROUP BY 
        CASE 
            WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
            WHEN avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END
)
SELECT * 
FROM CategorizedCustomers
ORDER BY FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');
