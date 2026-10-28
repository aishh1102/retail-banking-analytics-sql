-- RETAIL BANKING ANALYTICS

-- 02_data_loading.sql
--
-- Description:
-- Loads the source CSV files into the corresponding MySQL
-- tables using bulk data loading.
--
-- Data Preparation:
-- The source data is stored in CSV format and loaded into
-- the corresponding MySQL tables.
--
-- Loading Method:
-- LOAD DATA LOCAL INFILE
--
-- Special Handling:
-- Blank closed_on values in accounts are converted to NULL.
-- Blank merchant_id values in transactions are converted to NULL.
-- 
--
--
USE retail_banking_analytics;
-- 
-- LOAD BRANCHES
-- 
LOAD DATA LOCAL INFILE 'C:/SQL project/branches.csv'
INTO TABLE branches
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
-- 
-- LOAD MERCHANTS
-- 
LOAD DATA LOCAL INFILE 'C:/SQL project/merchants.csv'
INTO TABLE merchants
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
-- 
-- LOAD CUSTOMERS
--
LOAD DATA LOCAL INFILE 'C:/SQL project/customers.csv'
INTO TABLE customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
-- 
--  LOAD ACCOUNTS
--
LOAD DATA LOCAL INFILE 'C:/SQL project/accounts.csv'
INTO TABLE accounts
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    account_id,
    customer_id,
    account_type,
    currency,
    opened_on,
    @closed_on,
    overdraft_limit
)
SET closed_on = NULLIF(@closed_on, '');
-- 
-- LOAD TRANSACTIONS
--
LOAD DATA LOCAL INFILE 'C:/SQL project/transactions.csv'
INTO TABLE transactions
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    transaction_id,
    account_id,
    @merchant_id,
    posted_at,
    transaction_type,
    direction,
    amount,
    channel,
    description
)
SET merchant_id = NULLIF(@merchant_id, '');

