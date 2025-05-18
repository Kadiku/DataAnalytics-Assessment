WITH CustomerStats AS (
    SELECT
        u.id AS customer_id,
        CONCAT(u.first_name, ' ', u.last_name) AS name,
         -- Calculating the number of full months since the account was created
        TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,
         -- Count of total successful transactions per customer
        COUNT(s.id) AS total_transactions,
        -- Calculating the average confirmed transaction amount (in kobo)
        AVG(s.confirmed_amount) AS avg_transaction_value_kobo
    FROM users_customuser u
    LEFT JOIN savings_savingsaccount s
        ON u.id = s.owner_id
        AND s.transaction_status = 'success'
    GROUP BY u.id, u.first_name, u.last_name, u.date_joined
)

SELECT
    customer_id,
    name,
    tenure_months,
    total_transactions,
     -- Estimated CLV calculation = (total transactions / tenure) * 12 * avg profit per transaction
    ROUND( 
        (total_transactions / NULLIF(tenure_months, 0)) * 12 * 
        ((COALESCE(avg_transaction_value_kobo, 0) / 100) * 0.001),
        2
    ) AS estimated_clv
FROM CustomerStats
WHERE tenure_months > 0
ORDER BY estimated_clv DESC;

