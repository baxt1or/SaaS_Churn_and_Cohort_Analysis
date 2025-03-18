WITH cte AS (SELECT
customer_id, 
MAX(transaction_date) AS last_transaction_date
FROM transactions
GROUP BY 1),

churn_table AS (SELECT
c.customer_id, c.name,
ct.last_transaction_date,
CASE 
     WHEN ct.last_transaction_date < CURRENT_DATE - INTERVAL '90 days' THEN 'Churn' ELSE 'No' 
END AS churn_flag
FROM customers c 
LEFT JOIN cte ct ON c.customer_id = ct.customer_id)

SELECT
churn_flag, 
COUNT(*) AS total,
ROUND(COUNT(*) * 1.0/ (SELECT COUNT(*) FROM churn_table)* 100, 2) AS churn_percentage
FROM churn_table
GROUP BY 1
ORDER BY 2 DESC