-- CTEs to aggregate funded savings plans and funded investment plans per user
WITH Savings AS (
    SELECT 
        s.owner_id,
        COUNT(*) AS savings_count,
        SUM((s.confirmed_amount - COALESCE(s.deduction_amount, 0))/100.0) AS total_savings -- Total net amount funded in savings (converted from kobo to naira)
    FROM savings_savingsaccount AS s
    JOIN plans_plan AS p 
    ON s.plan_id = p.id      
    WHERE p.is_regular_savings = 1 -- Filtering for plans that are marked as savings and are also funded
    AND s.confirmed_amount > 0
    GROUP BY s.owner_id
),
Investments AS (
    SELECT 
        p.owner_id,
        COUNT(*) AS investment_count,
        SUM(p.amount/100.0) AS total_investments 
    FROM plans_plan AS p
    WHERE p.is_a_fund = 1  -- Filtering for plans that are marked as investments and are also funded
      AND p.amount > 0
    GROUP BY p.owner_id
)
-- Final query to bring out the users who have both plans and are funded
SELECT 
    u.id AS owner_id,
     CONCAT(u.first_name, ' ', u.last_name) AS name, -- Combining the first and last name that are in different columns in one
    COALESCE(s.savings_count, 0) AS savings_count, -- Number of savings plans, uses 0 instead of NULL if none, same for the investment plans
    COALESCE(i.investment_count, 0) AS investment_count,
    ROUND(COALESCE(s.total_savings, 0) + COALESCE(i.total_investments, 0), 2) AS total_deposits 
FROM users_customuser u
INNER JOIN Savings AS s 
ON u.id = s.owner_id  -- Extracting only users that have funded savings plan
INNER JOIN InvestmentS AS i 
ON u.id = i.owner_id -- Extracting users that have funded investment plan
ORDER BY total_deposits DESC;










