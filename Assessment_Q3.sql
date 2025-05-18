WITH LastTransactionDates AS (
-- -- Finding the most recent successful transaction date for each plan-user
    SELECT
        s.plan_id,
        s.owner_id,
        MAX(DATE(s.transaction_date)) AS last_transaction_date
    FROM savings_savingsaccount s
    WHERE s.transaction_status = 'success'
    GROUP BY s.plan_id, s.owner_id
),

ActivePlans AS (
    SELECT
        p.id AS plan_id,
        p.owner_id,
        CASE 
            WHEN p.is_regular_savings = 1 THEN 'Savings'
            WHEN p.is_a_fund = 1 THEN 'Investment'
            ELSE 'Other'
        END AS type
    FROM plans_plan p
    WHERE p.status_id = 1  -- Active plans only
      AND (p.is_regular_savings = 1 OR p.is_a_fund = 1) -- Filtering for either savings or investment plans
)

SELECT
    ap.plan_id,
    ap.owner_id,
    ap.type,
    l.last_transaction_date,
    DATEDIFF(CURDATE(), l.last_transaction_date) AS inactivity_days
FROM ActivePlans ap
LEFT JOIN LastTransactionDates l 
	ON ap.plan_id = l.plan_id AND ap.owner_id = l.owner_id
    -- Only showing accounts with no transactions in the last 365 days
WHERE (l.last_transaction_date IS NULL OR l.last_transaction_date <= DATE_SUB(CURDATE(), INTERVAL 365 DAY))
ORDER BY inactivity_days DESC;
