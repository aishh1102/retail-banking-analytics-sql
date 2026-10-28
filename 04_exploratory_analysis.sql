-- 
-- 1. CUSTOMER & ACCOUNT ANALYSIS
-- 
--
-- 
-- 1.1 Total Customers
-- 
-- Calculates the total number of customers in the bank.
SELECT COUNT(customer_id) AS total_customers FROM customers;
-- 
-- 1.2 Account Status
-- 
-- Shows the number of active and closed accounts.
--
SELECT
	CASE
		WHEN closed_on IS NULL THEN 'Active'
        ELSE 'Closed'
	END AS account_status,
    COUNT(account_id) AS account_count
FROM accounts
GROUP BY account_status
ORDER BY account_count DESC;
-- 
-- 1.3 Account Type Distribution
-- 
-- Shows the number of accounts by account type.
--
SELECT account_type,COUNT(account_id) AS account_count
FROM accounts
GROUP BY account_type
ORDER BY account_count DESC;
-- 
-- 1.4 Risk Band Distribution
-- 
-- Shows the number of customers in each risk band.
-- Customers with an unavailable risk band are included as NULL.
--
SELECT 
	COALESCE(risk_band,'UNKNOWN') AS risk_band,
    COUNT(customer_id) AS customer_count
FROM customers
GROUP BY COALESCE(risk_band,'UNKNOWN')
ORDER BY customer_count DESC;
-- 
-- 1.5 Customer Distribution by Country
--
-- Shows the number of customers in each country.
--
SELECT country,COUNT(customer_id) AS customer_count FROM customers
GROUP BY country
ORDER BY customer_count DESC;
-- 
-- 1.6 Customer Distribution by Branch
-- 
-- Shows the number of customers assigned to each home branch
--
SELECT b.branch_name,b.city,COUNT(c.customer_id) AS customer_count
FROM customers c
JOIN branches b
ON c.home_branch_id = b.branch_id
GROUP BY b.branch_id,b.branch_name,b.city
ORDER BY customer_count DESC;
-- 
-- 1.7 Customer Distribution by City
-- 
-- Shows the number of customers in each city.
SELECT
    city,
    COUNT(customer_id) AS customer_count
FROM customers
GROUP BY city
ORDER BY customer_count DESC;
-- 
-- 1.8 Average Accounts per Customer
-- 
-- Calculates the average number of accounts held per customer.
--
SELECT 
	ROUND(COUNT(a.account_id ) / COUNT(DISTINCT c.customer_id),2) 
		AS avg_accounts_per_customer
FROM customers AS c
LEFT JOIN accounts AS a
ON a.customer_id = c.customer_id;
--
-- 2.1 Total Transactions
-- 
-- Calculates the total number of transactions recorded.
--
SELECT COUNT(transaction_id) AS total_transactions
FROM transactions;
-- 
-- 2.2 Total Transaction Amount
-- 
-- Calculates the sum of all transaction amounts.
--
SELECT
    SUM(amount) AS total_transaction_amount
FROM transactions;
--
--
-- 
-- 2.3 Transaction Amount by Transaction Type
-- 
-- Calculates transaction count and total amount for each type.
SELECT
    transaction_type,
    COUNT(transaction_id) AS transaction_count,
    SUM(amount) AS total_amount
FROM transactions
GROUP BY transaction_type
ORDER BY total_amount DESC;
--
--
-- 2.4 Monthly Transaction Activity
-- 
-- Shows the number and total amount of transactions per month.
--
SELECT
    DATE_FORMAT(posted_at, '%Y-%m') AS transaction_month,
    COUNT(transaction_id) AS transaction_count,
    SUM(amount) AS total_amount
FROM transactions
GROUP BY DATE_FORMAT(posted_at, '%Y-%m')
ORDER BY transaction_month;
--
-- 
-- 2.5 Transaction Activity by Channel
-- 
-- Shows the number and total amount of transactions
-- processed through each channel.
--
SELECT
    channel,
    COUNT(transaction_id) AS transaction_count,
    SUM(amount) AS total_amount
FROM transactions
GROUP BY channel
ORDER BY transaction_count DESC;
--
-- 
-- 2.6 Largest Transactions
-- 
-- Displays the 10 transactions with the highest amounts.
--
SELECT transaction_id,account_id,transaction_type,direction,amount,posted_at,channel
FROM transactions
ORDER BY amount DESC
LIMIT 10;
-- 
-- 2.7 Transaction Activity by Direction
--
-- Shows the number and total amount of debit and credit
-- transactions.
--
SELECT direction,COUNT(transaction_id) AS transaction_count,SUM(amount) AS total_amount
FROM transactions
GROUP BY direction
ORDER BY transaction_count DESC;
-- 
-- 2.8 Transaction Activity by Merchant Country
-- 
-- Shows transaction counts and total amounts by merchant country.
-- Transactions without a merchant are excluded from this analysis.
--
SELECT m.country,COUNT(t.transaction_id) AS transaction_count,SUM(t.amount) AS total_amount
FROM merchants AS m
JOIN transactions AS t
ON t.merchant_id = m.merchant_id
GROUP BY m.country
ORDER BY transaction_count DESC;
-- 
-- 2.9 Average Transaction Amount by Transaction Type
-- 
-- Calculates the average transaction amount for each type.
--
SELECT transaction_type,COUNT(transaction_id) AS transaction_count,ROUND(AVG(amount), 2) AS average_amount
FROM transactions
GROUP BY transaction_type
ORDER BY average_amount DESC;
-- 
-- 2.10 Transaction Activity by Year
-- 
-- Shows the number and total amount of transactions per year.
--
SELECT YEAR(posted_at) AS transaction_year ,COUNT(transaction_id) AS transaction_count,SUM(amount) AS total_amount
FROM transactions
GROUP BY transaction_year
ORDER BY transaction_count DESC;
--
-- 3. MERCHANT ANALYSIS
-- 
--
-- 
-- 3.1 Transaction Activity by Merchant Category
--
-- Shows the number and total amount of transactions
-- for each merchant category.
--
SELECT m.category,COUNT(t.transaction_id) AS transaction_count,SUM(t.amount) AS total_amount
FROM transactions AS t
JOIN merchants AS m
ON t.merchant_id = m.merchant_id
GROUP BY m.category
ORDER BY transaction_count DESC;
-- 
-- 3.2 Top Merchants by Transaction Value
-- 
-- Identifies the merchants with the highest total transaction
-- amounts, showing the top 10 merchants.
--
SELECT
    m.merchant_id,
    m.merchant_name,
    m.category,
    COUNT(t.transaction_id) AS transaction_count,
    SUM(t.amount) AS total_transaction_amount
FROM merchants m
JOIN transactions t
    ON m.merchant_id = t.merchant_id
GROUP BY
    m.merchant_id,
    m.merchant_name,
    m.category
ORDER BY total_transaction_amount DESC
LIMIT 10;
-- 
-- 3.3 Merchant Activity by Country
-- 
-- Shows the number of transactions and total transaction
-- amount associated with merchants in each country.
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
-- 
-- 4. CUSTOMER BEHAVIOR ANALYSIS
-- 
-- 
-- 4.1 Top Customers by Transaction Count
--
-- Identifies the 10 customers with the highest number
-- of transactions across their accounts.
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
ORDER BY transaction_count DESC
LIMIT 10;
--
-- Largest Non-Salary Transactions
-- Identifies the 10 largest transactions excluding salary payments.
--
SELECT
    transaction_id,
    account_id,
    transaction_type,
    direction,
    amount,
    posted_at,
    channel
FROM transactions
WHERE transaction_type <> 'salary'
ORDER BY amount DESC
LIMIT 10;
