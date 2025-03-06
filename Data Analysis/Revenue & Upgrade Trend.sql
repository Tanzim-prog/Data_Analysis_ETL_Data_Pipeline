-- Percentage of users upgraded from Free to Pro --
SELECT COUNT(*) total_user,
COUNT(CASE WHEN subscription_type LIKE 'Free' THEN user_id END) free_user,
COUNT(CASE WHEN subscription_type LIKE 'Pro' THEN user_id END) pro_user,
(COUNT(CASE WHEN subscription_type LIKE 'Pro' THEN user_id END) /
	   COUNT(*)) *100 AS upgradation_percentage
FROM users;

-- Total monthly revenue from pro users --
SELECT COUNT(CASE WHEN subscription_type LIKE 'Pro' THEN user_id END) total_pro_user,
SUM(monthly_revenue) total_monthly_revenue
FROM users;


-- Pro plan that contributes the most in revenue --
SELECT plan_type,
SUM(monthly_revenue) total_revenue
FROM users
GROUP BY 1
ORDER BY 2 DESC;

-- Upgradation trend based on country --
SELECT country,
CASE WHEN total_sessions < 100 THEN 'Low'
	 WHEN total_sessions BETWEEN 100 AND 200 THEN 'Medium'
	 ELSE 'High'
END AS engagement_level,
COUNT(*) AS total_users,
AVG(DATEDIFF(pro_upgrade_date, install_date)) AS avg_days_to_upgrade
FROM users
WHERE pro_upgrade_date IS NOT NULL
GROUP BY 1, 2
ORDER BY 1, 2 ASC;
