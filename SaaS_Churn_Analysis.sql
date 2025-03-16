-- Users who haven't made a payment in the last 90 days
SELECT
customer_id, 
MAX(transaction_date) AS last_transaction_date
FROM transactions
GROUP BY 1
HAVING MAX(transaction_date) < CURRENT_DATE - INTERVAL '90 days';

-- Using this table, a business might sent some notification or some offers 
-- to prevent these customers going to churn


-- Finding those users who havent do any engagement in the last 90 days
SELECT
customer_id, 
MAX(event_date) AS last_engamenet
FROM user_activity
GROUP BY 1
HAVING MAX(event_date) < CURRENT_DATE - INTERVAL '90 days';



-- Customers who are with company for long time
SELECT
*
FROM (SELECT
u.customer_id, 
c.signup_date,
COUNT(u.event_type) AS total_engagement_count,
MAX(u.event_date) AS last_engagement_date,
EXTRACT(YEAR FROM AGE(MAX(u.event_date), c.signup_date)) AS lifetime_history
FROM user_activity u
LEFT JOIN customers c ON c.customer_id = u.customer_id
GROUP BY 1, 2
ORDER BY 1) AS sub
WHERE lifetime_history > 1;


-- Total Purchase amount per visit
SELECT
u.customer_id, 
SUM(t.amount) AS total_amount
FROM user_activity u 
INNER JOIN transactions t ON u.customer_id = t.customer_id AND u.event_date = t.transaction_date
WHERE u.event_type = 'Purchase' AND t.transaction_id IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC;


-- Engagement history in every month
SELECT
customer_id, 
COUNT(CASE WHEN event_type ='Feature_Usage' THEN activity_id END) AS feature_usage_count,
COUNT(CASE WHEN event_type ='Purchase' THEN activity_id END) AS purchase_count,
COUNT(CASE WHEN event_type ='Support_Usage' THEN activity_id  END) AS support_request_count,
COUNT(CASE WHEN event_type ='Login' THEN activity_id  END) AS login_count,
COUNT(CASE WHEN event_type ='Logout' THEN activity_id  END) AS logout_count
FROM user_activity
WHERE event_date BETWEEN '2024-01-01' AND CURRENT_DATE
GROUP BY 1;

-- Finding those who still pay but doesnt login
SELECT
t.customer_id, 
MAX(t.transaction_date) AS last_payment_date,
MAX(u.event_date) AS last_login_date
FROM transactions t
LEFT JOIN user_activity u ON t.customer_id = u.customer_id
WHERE u.event_type = 'Login' 
GROUP BY 1
HAVING MAX(t.transaction_date) >= CURRENT_DATE - INTERVAL '90 days'
AND MAX(u.event_date) < CURRENT_DATE - INTERVAL '90 days';












