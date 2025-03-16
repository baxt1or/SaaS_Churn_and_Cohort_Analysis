WITH cte AS (SELECT
customer_id, amount,
DATE_TRUNC('month', transaction_date)::DATE AS transaction_month,
MIN(DATE_TRUNC('month', transaction_date)::DATE) OVER(PARTITION BY customer_id) AS cohort_month
FROM transactions
WHERE transaction_date BETWEEN '2024-01-01' AND CURRENT_DATE),

cohort_analysis AS (SELECT
cohort_month, 
EXTRACT(YEAR FROM AGE(transaction_month, cohort_month)) * 12 +
EXTRACT(MONTH FROM AGE(transaction_month, cohort_month)) +1 AS cohort_index,
COUNT(DISTINCT customer_id) AS unique_customers
FROM cte
GROUP BY 1, 2)

SELECT
    cohort_month, 
    SUM(CASE WHEN cohort_index=1 THEN unique_customers ELSE 0 END) AS "2024-01-01",
    SUM(CASE WHEN cohort_index=2 THEN unique_customers ELSE 0 END) AS "2024-02-01",
    SUM(CASE WHEN cohort_index=3 THEN unique_customers ELSE 0 END) AS "2024-03-01",
    SUM(CASE WHEN cohort_index=4 THEN unique_customers ELSE 0 END) AS "2024-04-01",
    SUM(CASE WHEN cohort_index=5 THEN unique_customers ELSE 0 END) AS "2024-05-01",
    SUM(CASE WHEN cohort_index=6 THEN unique_customers ELSE 0 END) AS "2024-06-01",
    SUM(CASE WHEN cohort_index=7 THEN unique_customers ELSE 0 END) AS "2024-07-01",
    SUM(CASE WHEN cohort_index=8 THEN unique_customers ELSE 0 END) AS "2024-08-01",
    SUM(CASE WHEN cohort_index=9 THEN unique_customers ELSE 0 END) AS "2024-09-01",
    SUM(CASE WHEN cohort_index=10 THEN unique_customers ELSE 0 END) AS "2024-10-01",
    SUM(CASE WHEN cohort_index=11 THEN unique_customers ELSE 0 END) AS "2024-11-01",
    SUM(CASE WHEN cohort_index=12 THEN unique_customers ELSE 0 END) AS "2024-12-01",
	SUM(CASE WHEN cohort_index=13 THEN unique_customers ELSE 0 END) AS "2025-01-01",
	SUM(CASE WHEN cohort_index=14 THEN unique_customers ELSE 0 END) AS "2025-02-01",
	SUM(CASE WHEN cohort_index=15 THEN unique_customers ELSE 0 END) AS "2025-03-01"
FROM cohort_analysis
GROUP BY cohort_month;







