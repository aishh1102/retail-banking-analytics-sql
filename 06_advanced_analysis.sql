--
-- Advanced Analysis: Identifying High-Activity Customers
--

-- Business Objective:
-- Identify customers whose transaction counts are unusually
-- high compared with the overall customer activity distribution.
-- Note:
-- High transaction counts alone do not prove fraudulent activity.
-- Flagged customers require further investigation.
--
WITH customer_activity AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        COUNT(t.transaction_id) AS transaction_count
    FROM customers c
    JOIN accounts a
        ON c.customer_id = a.customer_id
    JOIN transactions t
        ON a.account_id = t.account_id
    GROUP BY
        c.customer_id,
        c.first_name,
        c.last_name
),
activity_stats AS (
    SELECT
        AVG(transaction_count) AS avg_transaction_count,
        STDDEV_POP(transaction_count) AS stddev_transaction_count
    FROM customer_activity
)
SELECT
    ca.customer_id,
    ca.first_name,
    ca.last_name,
    ca.transaction_count
FROM customer_activity ca
CROSS JOIN activity_stats s
WHERE ca.transaction_count >
      s.avg_transaction_count + (2 * s.stddev_transaction_count)
ORDER BY ca.transaction_count DESC;
--
-- 2. TOP 1% OF CUSTOMERS BY TRANSACTION COUNT
-- Identifies customers in the highest 1% of transaction activity.
-- This is a screening method, not proof of fraudulent activity.
--
WITH customer_activity AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        COUNT(t.transaction_id) AS transaction_count
    FROM customers c
    JOIN accounts a
        ON c.customer_id = a.customer_id
    JOIN transactions t
        ON a.account_id = t.account_id
    GROUP BY
        c.customer_id,
        c.first_name,
        c.last_name
),
ranked_customers AS (
    SELECT
        *,
        CUME_DIST() OVER (
            ORDER BY transaction_count
        ) AS activity_percentile
    FROM customer_activity
)
SELECT
    customer_id,
    first_name,
    last_name,
    transaction_count,
    ROUND(activity_percentile * 100, 2) AS activity_percentile
FROM ranked_customers
WHERE activity_percentile >= 0.99
ORDER BY transaction_count DESC;