-- 
-- RETAIL BANKING ANALYTICS
-- 
-- 03_data_quality_checks.sql
--
-- Description:
-- Validates the completeness, uniqueness, integrity, and
-- consistency of the loaded banking data before analysis.
-- 
-- 1. Row Count Validation
--
-- Verifies that all expected records were successfully loaded
-- into the five source tables.
-- 
USE retail_banking_analytics;

SELECT 'branches' AS table_name, COUNT(*) AS row_count FROM branches
UNION ALL
SELECT 'merchants', COUNT(*) FROM merchants
UNION ALL
SELECT 'customers', COUNT(*) FROM customers
UNION ALL
SELECT 'accounts', COUNT(*) FROM accounts
UNION ALL
SELECT 'transactions', COUNT(*) FROM transactions;

-- 
-- 2. PRIMARY KEY DUPLICATE CHECK
-- 
-- Checks whether any transaction_id appears more than once.
-- 
-- Check duplicate branch IDs
SELECT branch_id, COUNT(*) AS occurrence_count
FROM branches
GROUP BY branch_id
HAVING COUNT(*) > 1;
--
-- Check duplicate merchant IDs
SELECT merchant_id, COUNT(*) AS occurrence_count
FROM merchants
GROUP BY merchant_id
HAVING COUNT(*) > 1;
--
-- Check duplicate customer IDs
SELECT customer_id, COUNT(*) AS occurrence_count
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;
--
-- Check duplicate account IDs
SELECT account_id, COUNT(*) AS occurrence_count
FROM accounts
GROUP BY account_id
HAVING COUNT(*) > 1;
-- 
-- 3. NULL VALUE CHECK
-- 
-- Checks how many accounts do not have a closure date.
-- 
SELECT COUNT(*) AS opened_accounts FROM accounts
WHERE closed_on IS NULL;
-- 
-- 4. NULL VALUE CHECK - MERCHANT
-- 
-- Checks how many transactions are not associated with a merchant.
-- 
SELECT COUNT(*) AS transactions_without_merchants FROM transactions
WHERE merchant_id IS NULL;
--
-- 5. MISSING MERCHANTS BY TRANSACTION TYPE
-- 
-- Checks whether transactions without merchants are
-- concentrated in particular transaction types.
--
SELECT transaction_type, COUNT(*) AS transactions_without_merchant FROM transactions
WHERE merchant_id IS NULL
GROUP BY transaction_type
ORDER BY transactions_without_merchant DESC;
--
-- 6. FOREIGN KEY INTEGRITY - TRANSACTIONS TO ACCOUNTS
--
-- Checks whether every transaction is linked to an existing
-- account.
SELECT COUNT(*) AS invalid_account_references FROM transactions AS t
LEFT JOIN accounts AS a
ON t.account_id = a.account_id
WHERE a.account_id IS NULL;
-- 
-- 7. FOREIGN KEY INTEGRITY - ACCOUNTS TO CUSTOMERS
-- 
-- Checks whether every account is linked to an existing
-- customer.
SELECT COUNT(*) AS invalid_customer_references FROM accounts AS a
LEFT JOIN customers AS c
ON c.customer_id = a.customer_id
WHERE c.customer_id IS NULL;
-- 
-- 8. FOREIGN KEY INTEGRITY - CUSTOMERS TO BRANCHES
-- 
-- Checks whether every customer is linked to an existing
-- branch.
-- 
SELECT COUNT(*) AS invalid_branch_references FROM customers AS c
LEFT JOIN branches AS b
ON c.home_branch_id = b.branch_id
WHERE b.branch_id IS NULL;
-- 
-- 9. FOREIGN KEY INTEGRITY - TRANSACTIONS TO MERCHANTS
-- 
-- Checks whether every non-null merchant_id in transactions
-- corresponds to an existing merchant.
-- 
SELECT COUNT(*) AS invalid_merchant_references FROM transactions AS t
LEFT JOIN merchants AS m
ON m.merchant_id = t.merchant_id 
WHERE t.merchant_id IS NOT NULL AND m.merchant_id IS NULL;
-- 
-- 10. TRANSACTION TYPE CONSISTENCY
-- 
-- Reviews the distinct transaction types and their frequency.
--
SELECT transaction_type, COUNT(*) AS transaction_count FROM transactions
GROUP BY transaction_type
ORDER BY transaction_count DESC;
--
-- 11. TRANSACTION DIRECTION CONSISTENCY
-- 
-- Reviews the distinct transaction directions and their frequency.
-- 
SELECT direction,COUNT(*) AS transaction_count FROM transactions
GROUP BY direction
ORDER BY transaction_count DESC;
--
-- 12. TRANSACTION CHANNEL CONSISTENCY
-- 
-- Reviews the distinct transaction channels and their frequency.
--
SELECT channel,COUNT(*) AS channel_count FROM transactions
GROUP BY channel
ORDER BY channel_count DESC;
-- 
-- 13. ACCOUNT TYPE CONSISTENCY
-- 
-- Reviews the distinct account types and their frequency.
--
SELECT account_type, COUNT(*) AS account_type_count FROM accounts
GROUP BY account_type
ORDER BY account_type_count DESC;
-- 
-- 14. RISK BAND CONSISTENCY
-- 
-- Reviews the distinct customer risk bands and their frequency.
--
SELECT risk_band,COUNT(*) AS risk_band_count FROM customers
GROUP BY risk_band
ORDER BY risk_band_count DESC;
--
-- 15. MISSING RISK BAND VALUES
--
-- Checks whether customers have a missing risk classification.
--
SELECT COUNT(*) AS missing_risk_band
FROM customers
WHERE risk_band IS NULL
   OR TRIM(risk_band) = '';
--
-- Finding:
-- 6,479 customers have blank/whitespace risk_band values.
-- These values do not provide a meaningful risk classification
-- and will be treated as missing during the cleaning stage.
--
SELECT
    SUM(risk_band IS NULL) AS null_values,
    SUM(TRIM(risk_band) = '') AS blank_values
FROM customers;
-- 
-- 16. MISSING CUSTOMER EMAILS
-- 
-- Checks whether customer email addresses are missing or blank.
--
SELECT COUNT(*) AS missing_emails FROM customers
WHERE email IS NULL OR TRIM(email) ='';
-- 
-- 17. MISSING CUSTOMER NAMES
--
SELECT COUNT(*) AS missing_names FROM customers
WHERE first_name IS NULL OR last_name IS NULL
OR TRIM(first_name) = ''OR TRIM(last_name) = '';
-- 
-- 18. MISSING ACCOUNT DETAILS
-- 
-- Checks for missing account IDs, customer IDs, and account types.
-- 
SELECT 
	SUM(customer_id IS NULL) AS missing_customer_id,
    SUM(account_id IS NULL) AS missing_account_id,
    SUM(TRIM(account_type) = '' OR account_type IS NULL) AS missing_account_type 
FROM accounts;
-- 
-- 19. MISSING ACCOUNT OPENING DATES
-- 
-- Checks whether any accounts have a missing opening date.
-- 
SELECT COUNT(*) AS missing_opened_dates FROM accounts
WHERE opened_on IS NULL;
-- 
-- 20. MISSING TRANSACTION DETAILS
-- 
-- Checks whether transactions have missing posting dates
-- or transaction amounts.
-- 
SELECT
    SUM(posted_at IS NULL) AS missing_posted_at,
    SUM(amount IS NULL) AS missing_amount
FROM transactions;
-- 
-- 21. TRANSACTION AMOUNT VALIDATION
-- 
-- Checks for zero or negative transaction amounts.
-- Negative amounts may be valid depending on the transaction
-- design, so this check is used for profiling rather than
-- automatically treating them as errors.
-- 
SELECT
    SUM(amount = 0) AS zero_amounts,
    SUM(amount < 0) AS negative_amounts
FROM transactions;
-- 
-- 22. OVERDRAFT LIMIT VALIDATION
-- 
-- Checks for negative or NULL overdraft limits.
-- 
SELECT
    SUM(overdraft_limit IS NULL) AS missing_overdraft_limit,
    SUM(overdraft_limit < 0) AS negative_overdraft_limit
FROM accounts;
--
-- 23. ACCOUNT DATE VALIDATION
--
-- Checks whether any account has a closure date earlier
-- than its opening date.
-- 
SELECT COUNT(*) AS invalid_account_dates FROM accounts 
WHERE closed_on IS NOT NULL AND closed_on < opened_on;
-- 
-- 24. CUSTOMER JOIN DATE VALIDATION
--
-- Checks whether any customer has a missing join date.
-- 
SELECT COUNT(*) AS missing_joined_on FROM customers 
WHERE joined_on IS NULL;
-- 
-- 25. CUSTOMER EMAIL FORMAT VALIDATION
-- 
-- Checks whether customer email addresses contain the basic
-- '@' character required in an email address.
-- 
SELECT COUNT(*) AS invalid_email_format FROM customers
WHERE email NOT LIKE '%@%';
-- 
-- 26. DUPLICATE CUSTOMER EMAILS
-- 
-- Checks whether the same email address is associated with
-- multiple customer records.
-- 
SELECT email,COUNT(*) AS email_count FROM customers
GROUP BY email
HAVING email_count > 1;
-- 
-- DATA CLEANING
-- 
-- Converts blank or whitespace-only risk_band values to NULL.
-- NULL indicates that the customer's risk classification
-- is currently unavailable or not provided.
-- 
UPDATE customers 
SET risk_band = null
WHERE TRIM(risk_band) = '';
--
-- Verifies that no blank risk_band values remain after cleaning.
--
SELECT COUNT(*) AS remaining_blank_risk_band FROM customers
WHERE TRIM(risk_band) = '';
--
-- CURRENCY DISTRIBUTION
-- Checks the currencies associated with bank accounts.
--
SELECT
    currency,
    COUNT(*) AS account_count
FROM accounts
GROUP BY currency
ORDER BY account_count DESC;
--
-- TRANSACTION AMOUNTS BY ACCOUNT CURRENCY
-- Compares transaction counts and amounts across account currencies.

SELECT
    a.currency,
    COUNT(t.transaction_id) AS transaction_count,
    ROUND(SUM(t.amount), 2) AS total_transaction_amount
FROM accounts a
JOIN transactions t
    ON a.account_id = t.account_id
GROUP BY a.currency
ORDER BY total_transaction_amount DESC;



