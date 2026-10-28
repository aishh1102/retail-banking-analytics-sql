Retail Banking Analytics — Data Dictionary

 1. Overview

This document describes the tables, columns, and relationships
in the Retail Banking Analytics database.

- Database: retail banking analytics
- Tool: MySQL
- Tables: 5

 2. Database Tables

 2.1 Branches

Stores information about bank branches.

| Column | Description |
|---|---|
| branch id | Unique identifier for each branch |
| branch name | Name of the branch |
| city | City where the branch is located |
| country | Country where the branch is located |
| opened on | Date the branch opened |

 2.2 Merchants

Stores information about merchants.

| Column | Description |
|---|---|
| merchant id | Unique identifier for each merchant |
| merchant name | Name of the merchant |
| category | Merchant business category |
| country | Country where the merchant is located |

 2.3 Customers

Stores customer information.

| Column | Description |
|---|---|
| customer id | Unique identifier for each customer |
| first name | Customer's first name |
| last name | Customer's last name |
| email | Customer's email address |
| city | Customer's city |
| country | Customer's country |
| home branch id | Customer's home branch identifier |
| joined on | Date the customer joined the bank |
| risk band | Customer risk classification; may be NULL |

 2.4 Accounts

Stores bank account details.

| Column | Description |
|---|---|
| account id | Unique identifier for each account |
| customer id | Identifier of the account owner |
| account type | Type of account |
| currency | Account currency |
| opened on | Date the account was opened |
| closed on | Account closure date; may be NULL |
| overdraft limit | Overdraft limit associated with the account |

 2.5 Transactions

Stores banking transaction records.

| Column | Description |
|---|---|
| transaction id | Unique identifier for each transaction |
| account id | Identifier of the associated account |
| merchant id | Associated merchant identifier; may be NULL |
| posted at | Date and time the transaction was posted |
| transaction type | Type of transaction |
| direction | Debit or credit |
| amount | Transaction amount |
| channel | Channel used for the transaction |
| description | Transaction description |

 3. Table Relationships

- Customers reference branches through `home branch id`.
- Accounts reference customers through `customer id`.
- Transactions reference accounts through `account id`.
- Transactions may reference merchants through `merchant id`.

 4. Data Quality Note

Blank or whitespace-only values in `customers risk band`
were converted to SQL NULL during data cleaning.