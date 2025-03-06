-- Churn Rate for Free vs Pro --
SELECT subscription_type,
COUNT(user_id) AS total_users,
COUNT(CASE WHEN churned = 1 THEN user_id END) AS churned_users,
ROUND(100 * COUNT(CASE WHEN churned = 1 THEN user_id END) / COUNT(user_id), 2) AS churn_rate
FROM growth_data.users
GROUP BY 1;

-- Monthly churn trend --
SELECT subscription_type,
COUNT(user_id) AS total_users,
EXTRACT(MONTH FROM last_active_date) AS month,
COUNT(CASE WHEN churned = 1 THEN user_id END) AS churned_users,
ROUND(100 * COUNT(CASE WHEN churned = 1 THEN user_id END) / COUNT(user_id), 2) AS churn_rate
FROM growth_data.users
GROUP BY 1, 3
ORDER BY 1, 3;

-- Yearly churn trend --
SELECT subscription_type,
COUNT(user_id) AS total_users,
EXTRACT(YEAR FROM last_active_date) AS year,
COUNT(CASE WHEN churned = 1 THEN user_id END) AS churned_users,
ROUND(100 * COUNT(CASE WHEN churned = 1 THEN user_id END) / COUNT(user_id), 2) AS churn_rate
FROM users
GROUP BY 1, 3
ORDER BY 1, 3;

-- Country wise churn trend --
SELECT country, subscription_type,
COUNT(user_id) AS total_users,
COUNT(CASE WHEN churned = 1 THEN user_id END) AS churned_users,
ROUND(100 * COUNT(CASE WHEN churned = 1 THEN user_id END) / COUNT(user_id), 2) AS churn_rate
FROM users
GROUP BY 1, 2
ORDER BY 5 DESC;

-- User engagement wise churn trend --
SELECT subscription_type,
CASE 
WHEN total_sessions < 100 THEN 'Low Engagement'
WHEN total_sessions BETWEEN 100 AND 200 THEN 'Medium Engagement'
ELSE 'High Engagement'
END AS engagement_level,
COUNT(*) AS total_users,
SUM(churned) AS churned_users,
ROUND(100 * SUM(churned) / COUNT(*), 2) AS churn_rate
FROM users
GROUP BY 1, 2
ORDER BY 1, 5 DESC;

-- Pro plan wise churn trend --
SELECT plan_type,
COUNT(*) AS total_users,
SUM(churned) AS churned_users,
ROUND(100 * SUM(churned) / COUNT(*), 2) AS churn_rate
FROM users
WHERE subscription_type = 'Pro'
GROUP BY plan_type
ORDER BY churn_rate DESC;

-- User lifespan wise churn trend --
SELECT subscription_type,
AVG(DATEDIFF(last_active_date, install_date)) AS avg_days_before_churn
FROM users
WHERE churned = 1
GROUP BY subscription_type;

-- New vs Old user churn trend --
SELECT subscription_type,
CASE WHEN DATEDIFF(last_active_date, install_date) < 10 THEN 'Churned in <10 Days'
WHEN DATEDIFF(last_active_date, install_date) BETWEEN 10 AND 20 THEN 'Churned in 10-20 Days'
ELSE 'Churned After 20 Days'
END AS churn_duration,
SUM(churned) AS churned_users
FROM users
WHERE churned = 1
GROUP BY 1, 2
ORDER BY 3 DESC;

-- Early warning sign of churn --
SELECT  user_id, subscription_type, last_active_date,
DATEDIFF(CURDATE(), last_active_date) AS days_since_last_active
FROM users
WHERE churned = 0
ORDER BY 4 DESC;

-- Churn Correlation Analysis --
SELECT 'Total Sessions' AS metric, ( 
    (n * sum_xy - sum_x * sum_y) / 
    SQRT((n * sum_x2 - sum_x * sum_x) * (n * sum_y2 - sum_y * sum_y))
) AS correlation
FROM (
    SELECT 
        COUNT(*) AS n,
        SUM(total_sessions) AS sum_x,
        SUM(churned) AS sum_y,
        SUM(total_sessions * churned) AS sum_xy,
        SUM(total_sessions * total_sessions) AS sum_x2,
        SUM(churned * churned) AS sum_y2
    FROM users
) AS stats

UNION ALL

SELECT 'Page Views', ( 
    (n * sum_xy - sum_x * sum_y) / 
    SQRT((n * sum_x2 - sum_x * sum_x) * (n * sum_y2 - sum_y * sum_y))
) AS correlation
FROM (
    SELECT 
        COUNT(*) AS n,
        SUM(page_views) AS sum_x,
        SUM(churned) AS sum_y,
        SUM(page_views * churned) AS sum_xy,
        SUM(page_views * page_views) AS sum_x2,
        SUM(churned * churned) AS sum_y2
    FROM users
) AS stats

UNION ALL

SELECT 'Download Clicks', ( 
    (n * sum_xy - sum_x * sum_y) / 
    SQRT((n * sum_x2 - sum_x * sum_x) * (n * sum_y2 - sum_y * sum_y))
) AS correlation
FROM (
    SELECT 
        COUNT(*) AS n,
        SUM(download_clicks) AS sum_x,
        SUM(churned) AS sum_y,
        SUM(download_clicks * churned) AS sum_xy,
        SUM(download_clicks * download_clicks) AS sum_x2,
        SUM(churned * churned) AS sum_y2
    FROM users
) AS stats

UNION ALL

SELECT 'Activation Status', ( 
    (n * sum_xy - sum_x * sum_y) / 
    SQRT((n * sum_x2 - sum_x * sum_x) * (n * sum_y2 - sum_y * sum_y))
) AS correlation
FROM (
    SELECT 
        COUNT(*) AS n,
        SUM(activation_status) AS sum_x,
        SUM(churned) AS sum_y,
        SUM(activation_status * churned) AS sum_xy,
        SUM(activation_status * activation_status) AS sum_x2,
        SUM(churned * churned) AS sum_y2
    FROM users
) AS stats

UNION ALL

SELECT 'Days Active', ( 
    (n * sum_xy - sum_x * sum_y) / 
    SQRT((n * sum_x2 - sum_x * sum_x) * (n * sum_y2 - sum_y * sum_y))
) AS correlation
FROM (
    SELECT 
        COUNT(*) AS n,
        SUM(days_active) AS sum_x,
        SUM(churned) AS sum_y,
        SUM(days_active * churned) AS sum_xy,
        SUM(days_active * days_active) AS sum_x2,
        SUM(churned * churned) AS sum_y2
    FROM users
) AS stats

UNION ALL

SELECT 'Monthly Revenue', ( 
    (n * sum_xy - sum_x * sum_y) / 
    SQRT((n * sum_x2 - sum_x * sum_x) * (n * sum_y2 - sum_y * sum_y))
) AS correlation
FROM (
    SELECT 
        COUNT(*) AS n,
        SUM(monthly_revenue) AS sum_x,
        SUM(churned) AS sum_y,
        SUM(monthly_revenue * churned) AS sum_xy,
        SUM(monthly_revenue * monthly_revenue) AS sum_x2,
        SUM(churned * churned) AS sum_y2
    FROM users
) AS stats;
