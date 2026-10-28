-- 
-- RETAIL BANKING ANALYTICS
-- 
-- Project  : Retail Banking Analytics
-- Database : retail_banking_analytics
-- Tool     : MySQL
--
-- Description:
-- Analyses banking performance and customer activity
-- to support business decision-making.
-- 
--
-- 
-- 1. TRANSACTION PERFORMANCE
-- 
-- 
-- 1.1 Transaction Type Contribution to Total Amount
-- 
-- Calculates each transaction type's share of the total
-- transaction amount as a percentage.
--
SELECT
    transaction_type,
    SUM(amount) AS total_amount,
    ROUND(
        SUM(amount) * 100.0 / (SELECT SUM(amount) FROM transactions),
        2
    ) AS contribution_percentage
FROM transactions
GROUP BY transaction_type
ORDER BY contribution_percentage DESC;
-- 
-- 1.2 Transaction Value by Channel
-- 
-- Compares transaction count, total amount, and average amount
-- across transaction channels.
--
SELECT
    channel,
    COUNT(transaction_id) AS transaction_count,
    SUM(amount) AS total_amount,
    ROUND(AVG(amount), 2) AS average_amount
FROM transactions
GROUP BY channel
ORDER BY total_amount DESC;
-- 
-- 1.3 Transaction Direction by Transaction Type
-- 
-- Compares debit and credit transaction counts and amounts
-- for each transaction type.
--
SELECT
    transaction_type,
    direction,
    COUNT(transaction_id) AS transaction_count,
    SUM(amount) AS total_amount
FROM transactions
GROUP BY
    transaction_type,
    direction
ORDER BY
    transaction_type,
    direction;
-- 
-- 2. CUSTOMER & ACCOUNT INSIGHTS
-- 
--
-- 
-- 2.1 Transaction Value by Account Type
-- 
-- Compares transaction count, total amount, and average
-- transaction amount across account types.
--
SELECT
    a.account_type,
    COUNT(t.transaction_id) AS transaction_count,
    SUM(t.amount) AS total_transaction_amount,
    ROUND(AVG(t.amount), 2) AS average_transaction_amount
FROM accounts a
JOIN transactions t
    ON a.account_id = t.account_id
GROUP BY a.account_type
ORDER BY total_transaction_amount DESC;
-- 
-- 2.2 Top Customers by Transaction Amount
-- 
-- Identifies the 10 customers associated with the highest
-- total transaction amounts across their accounts.
--
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(t.transaction_id) AS transaction_count,
    SUM(t.amount) AS total_transaction_amount
FROM customers c
JOIN accounts a
    ON c.customer_id = a.customer_id
JOIN transactions t
    ON a.account_id = t.account_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY total_transaction_amount DESC
LIMIT 10;
-- 
-- 3. MERCHANT INSIGHTS
-- 
--
-- 
-- 3.1 Average Transaction Value by Merchant Category
-- 
-- Compares transaction count, total amount, and average
-- transaction value across merchant categories.
--
SELECT
    m.category,
    COUNT(t.transaction_id) AS transaction_count,
    SUM(t.amount) AS total_transaction_amount,
    ROUND(AVG(t.amount), 2) AS average_transaction_amount
FROM merchants m
JOIN transactions t
    ON m.merchant_id = t.merchant_id
GROUP BY m.category
ORDER BY total_transaction_amount DESC;
-- 
-- 3.2 Transaction Value by Merchant Country
-- 
-- Compares transaction count and total transaction amount
-- across merchant countries.
--
SELECT
    m.country,
    COUNT(t.transaction_id) AS transaction_count,
    SUM(t.amount) AS total_transaction_amount
FROM merchants m
JOIN transactions t
    ON m.merchant_id = t.merchant_id
GROUP BY m.country
ORDER BY total_transaction_amount DESC;
