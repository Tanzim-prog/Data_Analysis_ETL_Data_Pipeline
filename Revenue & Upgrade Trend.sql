-- Percentage of users upgraded from Free to Pro --
SELECT (COUNT(CASE WHEN subscription_type LIKE 'Pro' THEN user_id END) /
	   COUNT(*)) *100 AS upgradation_percentage
FROM users;

-- Total monthly revenue from pro users --
