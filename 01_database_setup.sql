-- RETAIL BANKING ANALYTICS
--
-- Project      : Retail Banking Analytics
-- Database     : retail_banking_analytics
-- Tool         : MySQL
--
-- Description:
-- This project analyzes retail banking data across customers,
-- accounts, transactions, merchants, and branches.
--
-- Database Structure:
-- 1. branches
-- 2. merchants
-- 3. customers
-- 4. accounts
-- 5. transactions
--
-- DATABASE SETUP
CREATE DATABASE IF NOT EXISTS retail_banking_analytics;
USE retail_banking_analytics;
--
--  TABLE CREATION
--
-- BRANCHES
-- Stores information about bank branches.
--
CREATE TABLE branches (
    branch_id INT NOT NULL,
    branch_name VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    opened_on DATE NOT NULL,
    PRIMARY KEY (branch_id)
);
-- 
-- MERCHANTS
-- Stores merchant information associated with transactions.
--
CREATE TABLE merchants (
    merchant_id INT NOT NULL,
    merchant_name VARCHAR(100) NOT NULL,
    category VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    PRIMARY KEY (merchant_id)
);
--
-- CUSTOMERS
-- Stores customer information and risk classification.
-- home_branch_id links each customer to their home branch.
--
CREATE TABLE customers (
    customer_id INT NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    home_branch_id INT NOT NULL,
    joined_on DATE NOT NULL,
    risk_band VARCHAR(50),
    PRIMARY KEY (customer_id),
    FOREIGN KEY (home_branch_id)
        REFERENCES branches(branch_id)
);
--
-- ACCOUNTS
-- Stores bank account information for customers.
-- closed_on is nullable because an account may still be open.
--
CREATE TABLE accounts (
    account_id INT NOT NULL,
    customer_id INT NOT NULL,
    account_type VARCHAR(50) NOT NULL,
    currency VARCHAR(10) NOT NULL,
    opened_on DATE NOT NULL,
    closed_on DATE NULL,
    overdraft_limit DECIMAL(12,2) NOT NULL,
    PRIMARY KEY (account_id),
    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);
--
-- TRANSACTIONS
-- Stores individual banking transactions.
-- merchant_id is nullable because some transactions may not
-- be associated with a merchant.
--
CREATE TABLE transactions (
    transaction_id INT NOT NULL,
    account_id INT NOT NULL,
    merchant_id INT NULL,
    posted_at DATETIME NOT NULL,
    transaction_type VARCHAR(50) NOT NULL,
    direction VARCHAR(20) NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    channel VARCHAR(50) NOT NULL,
    description VARCHAR(255) NOT NULL,
    PRIMARY KEY (transaction_id),
    FOREIGN KEY (account_id)
        REFERENCES accounts(account_id),
    FOREIGN KEY (merchant_id)
        REFERENCES merchants(merchant_id)
);




  





    
    
    

    
    
	






