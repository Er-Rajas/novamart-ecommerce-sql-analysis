# NovaMart E-Commerce Sales Analysis | SQL Business Intelligence

SQL portfolio/class project analyzing NovaMart's e-commerce sales data and answering 30 business questions across basic, intermediate, and advanced SQL.

## Project Overview

**Client:** NovaMart  
**Industry:** E-Commerce / Online Retail  
**Role:** Data Analyst  
**Data period:** January 2023 – June 2025  
**Database:** MySQL / SQL  
**Tables:** Customers, Products, Orders

NovaMart wants a data-driven view of sales performance, product/category performance, customer purchasing behavior, profitability, inventory health, order patterns, cancellations, and payment-method performance.

## Dataset Structure

| Table | Records | Purpose |
|---|---:|---|
| Customers | 500 | Customer profile and signup information |
| Products | 199 | Product catalog, pricing, cost, category, brand, stock |
| Orders | 850 | Sales transactions, quantities, amounts, status and payment method |

## Analysis Areas

- Product and category performance
- Revenue and monthly revenue trends
- Customer spend and lifetime value
- Customer segmentation
- Gross profit and gross margin
- Inventory and remaining stock
- Stock-out risk
- Order status and cancellation analysis
- Payment-method performance
- Month-over-month revenue growth
- Brand ranking within categories

## SQL Concepts Demonstrated

- `WHERE`, `BETWEEN`, `IN`, `DISTINCT`
- `SUM`, `AVG`, `COUNT`, `MIN`, `MAX`
- `JOIN` / `LEFT JOIN`
- `GROUP BY`, `HAVING`, `ORDER BY`
- Common Table Expressions (`WITH`)
- Window functions: `RANK()` and `LAG()`
- `CASE`-based customer segmentation
- Date aggregation with `DATE_FORMAT()`
- Revenue contribution, gross profit, gross margin and MoM growth

## Selected Findings from the Submitted Outputs

> These figures reproduce the outputs shown in the supplied SQL project PDF. They are not recalculated from the source data because the source data files have not yet been added to this repository.

- Electronics accounts for **60.61%** of the reported category revenue in Q22.
- Reported Electronics revenue: **$351,632.40**.
- Beauty & Personal Care has the highest reported gross margin: **64.42%**.
- The highest lifetime value shown in Q19 is **$13,557.56** for **Todd Fischer**.
- Q5 reports total product stock of **29,914 units**.
- Q28 flags **ForgeAudio HD-Lite** with **5 current units** and **8 units sold** under the project's stock-out-risk rule.
- Q29 reports **Google Pay** as the highest-revenue payment method at **$111,879.26**.
- Q30 shows a reported **+99.40%** MoM revenue growth in **2024-03**.

## Important SQL Validation Notes

1. **Q12 status typo:** the query uses `Shiped` instead of `Shipped`.
2. **Q14 requirement mismatch:** the question says "at least 3 orders", but the query uses `> 3`; the stated requirement implies `>= 3`.
3. **Q25 is not a rate:** the query counts cancelled orders by month but does not divide by total orders.
4. **Q18 grouping issue:** the query groups by city while selecting customer name; under strict SQL settings this is invalid.
5. **Q6/Q10 extreme-value identity:** pairing `MAX()`/`MIN()` with a non-aggregated product name can mismatch the product identity. `ORDER BY ... LIMIT 1` is safer.

## Repository Structure

```text
novamart-ecommerce-sql-analysis/
├── README.md
├── sql/
│   └── novamart_analysis.sql
├── presentation/
│   ├── NovaMart_Ecommerce_SQL_Analysis.pptx
│   └── README.md
├── data/
│   └── README.md
└── assets/
    └── README.md
```

## Presentation

The presentation covers the business problem, dataset, SQL approach, category revenue, profitability, customer value, inventory risk, payment methods, revenue trends, management takeaways, and a SQL quality review.


## Data

Source CSV files can be added under `data/` once they are available.

## Portfolio Context

**Business problem → data structure → SQL analysis → validation → insights → management communication**
