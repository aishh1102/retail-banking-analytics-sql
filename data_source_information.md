# Source Data Information

## Project Name

Retail Banking Analytics

## Database

`retail_banking_analytics`

## Source Data Format

CSV (Comma-Separated Values)

## Source File Location

The original CSV files are stored locally and were used to load the data into MySQL.

**Source directory:** `SQL project/`

The original CSV files are stored in the local `Downloads\SQL project` directory and are maintained separately from the project repository.

## Source Files

| File Name | Description | Records |
|---|---|---:|
| `branches.csv` | Branch details, including branch name, city, country, and opening date | 40 |
| `merchants.csv` | Merchant details, including merchant name, category, and country | 800 |
| `customers.csv` | Customer details, including contact information, home branch, joining date, and risk band | 9,000 |
| `accounts.csv` | Account details, including customer relationship, account type, currency, and account dates | 14,000 |
| `transactions.csv` | Banking transaction details, including amount, date, type, direction, channel, and merchant reference | 320,000 |

## Total Records

343,840 records across five source files.

## Data Preparation

The CSV files were loaded into MySQL tables. Blank values in the `closed_on` column were handled as SQL `NULL` values. Blank merchant references were also handled as `NULL` where applicable. Blank or whitespace-only values in the customer `risk_band` column were converted to SQL `NULL` during data cleaning.

## Notes

- The source CSV files are maintained separately from the project documentation.
- The database tables were validated using SQL data quality checks.
- The original source files are retained in their existing location.



