-- Table Creation --
CREATE TABLE users(
	user_id INT(10) NOT NULL PRIMARY KEY,
    install_date DATE,
    last_active_date DATE,
    subscription_type VARCHAR(10),
    country VARCHAR(20),
    total_sessions INT(10),
    page_views INT(10),
    download_clicks INT(10),
    activation_status INT(10),
    days_active INT(10),
    pro_upgrade_date DATE,
    plan_type VARCHAR(20),
    monthly_revenue INT(10),
    churned INT(10)
    );
 
 -- EDA --
 
SELECT *
FROM growth_data.users;

SELECT DISTINCT subscription_type
FROM users;

SELECT DISTINCT country
FROM users;

SELECT DISTINCT plan_type
FROM users;

SELECT DISTINCT COUNT(user_id)
FROM users;

SELECT 
    SUM(CASE WHEN install_date IS NULL THEN 1 ELSE 0 END) AS missing_install_date,
    SUM(CASE WHEN last_active_date IS NULL THEN 1 ELSE 0 END) AS missing_last_active_date,
    SUM(CASE WHEN subscription_type IS NULL THEN 1 ELSE 0 END) AS missing_subscription_type,
    SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS missing_country,
    SUM(CASE WHEN total_sessions IS NULL THEN 1 ELSE 0 END) AS missing_total_sessions,
    SUM(CASE WHEN page_views IS NULL THEN 1 ELSE 0 END) AS missing_page_views,
    SUM(CASE WHEN download_clicks IS NULL THEN 1 ELSE 0 END) AS missing_download_clicks,
    SUM(CASE WHEN activation_status IS NULL THEN 1 ELSE 0 END) AS missing_activation_status,
    SUM(CASE WHEN days_active IS NULL THEN 1 ELSE 0 END) AS missing_days_active,
    SUM(CASE WHEN pro_upgrade_date IS NULL THEN 1 ELSE 0 END) AS missing_pro_upgrade_date,
    SUM(CASE WHEN plan_type IS NULL THEN 1 ELSE 0 END) AS missing_plan_type,
    SUM(CASE WHEN monthly_revenue IS NULL THEN 1 ELSE 0 END) AS missing_monthly_revenue,
    SUM(CASE WHEN churned IS NULL THEN 1 ELSE 0 END) AS missing_churned
FROM users;

SELECT user_id, subscription_type, pro_upgrade_date, plan_type
FROM users 
WHERE subscription_type != 'Pro'
AND pro_upgrade_date IS NOT NULL
AND plan_type IS NOT NULL;

SELECT 
    MIN(total_sessions) AS min_sessions, MAX(total_sessions) AS max_sessions, AVG(total_sessions) AS avg_sessions,
    MIN(page_views) AS min_page_views, MAX(page_views) AS max_page_views, AVG(page_views) AS avg_page_views,
    MIN(monthly_revenue) AS min_revenue, MAX(monthly_revenue) AS max_revenue, AVG(monthly_revenue) AS avg_revenue,
    MIN(days_active) AS min_days_active, MAX(days_active) AS max_days_active, AVG(days_active) AS avg_days_active
FROM users;

SELECT user_id, install_date, last_active_date, pro_upgrade_date 
FROM users 
WHERE install_date NOT REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$';

SELECT user_id, last_active_date, churned 
FROM users 
WHERE churned = 1 AND last_active_date > DATE_SUB(CURDATE(), INTERVAL 30 DAY);

