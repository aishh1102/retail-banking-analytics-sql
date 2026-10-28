Retail Banking Analytics

 Project Overview

Retail Banking Analytics is a SQL-based data analysis project built using MySQL. It explores customer information, bank accounts, transactions, merchants, and branches to understand banking activity and identify meaningful business insights.

 Objectives

- Analyse customer and account distributions.
- Evaluate transaction volume, value, and trends.
- Compare transaction activity across channels and transaction types.
- Identify high-value merchants and merchant categories.
- Validate data quality and clean missing values.
- Apply advanced SQL techniques to investigate unusually high customer transaction activity.

 Dataset Overview

The project contains five relational tables.

| Table | Records |
|---|---:|
| Branches | 40 |
| Merchants | 800 |
| Customers | 9,000 |
| Accounts | 14,000 |
| Transactions | 320,000 |
| **Total** | **343,840** |

Tools and Technologies

- MySQL
- MySQL Workbench
- SQL
- Python for source-data preparation

 Project Workflow

1. Database and table creation
2. CSV data loading
3. Data-quality validation
4. Data cleaning
5. Exploratory data analysis
6. Business analysis
7. Advanced SQL analysis
8. Documentation and business insights

 Key Findings

- The dataset contains 9,000 customers and 14,000 accounts.
- A total of 320,000 transactions were analysed.
- EUR: 8,340 credit transactions totaling 7,088,706.50 and 33,017 debit transactions totaling 1,493,690.96.
- GBP: 40,316 credit transactions totaling 33,370,133.64 and 163,583 debit transactions totaling 7,474,058.88.
- USD: 14,983 credit transactions totaling 12,461,388.97 and 59,761 debit transactions totaling 2,727,204.99.
- The sum of recorded transaction amounts is 64,615,183.94.
- Current accounts are the most common account type.
- A total of 6,479 blank or whitespace-only customer risk-band values were converted to SQL `NULL`.
- Data-quality checks found no invalid foreign-key references in the checked relationships.
- Customer transaction activity was analysed using average and population standard deviation to flag unusually high activity for further investigation. These flags do not establish fraud.

  Repository Structure

```text
retail-banking-analytics/
├── README.md
├── data/
│   └── data_source_information.md
├── documentation/
│   ├── data_dictionary.md
│   └── Business Insights and Recommendations.txt
├── screenshots/
└── sql/
    ├── 01_database_setup.sql
    ├── 02_data_loading.sql
    ├── 03_data_quality_checks.sql
    ├── 04_exploratory_analysis.sql
    ├── 05_business_analysis.sql
    └── 06_advanced_analysis.sql
```


 Skills Demonstrated

- Relational database design
- Primary and foreign keys
- Bulk CSV data loading
- Data-quality validation and cleaning
- Joins, aggregations, CTEs, and subqueries
- Date-based analysis
- Statistical analysis using standard deviation
- Business-focused SQL reporting
- Technical documentation

 Conclusion

This project demonstrates an end-to-end SQL workflow, from preparing and loading banking data to validating data quality, performing exploratory and business analysis, and documenting findings. It also demonstrates the use of statistical methods to identify unusual transaction activity for further review.