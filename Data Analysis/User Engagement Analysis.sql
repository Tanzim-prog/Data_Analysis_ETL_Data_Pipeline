-- Identify the average number of sessions for Free vs. Pro users --
SELECT subscription_type,
AVG(total_sessions)
FROM users
GROUP BY 1;

-- Find the top 5 most active users based on total sessions --
SELECT user_id, total_sessions
FROM users
ORDER BY total_sessions DESC
LIMIT 5;

										-- Identify the top 5 countries with the highest engagement --
-- Based on total users --
SELECT country,
COUNT(user_id) total_users
FROM users
GROUP BY 1
ORDER BY COUNT(user_id) DESC
LIMIT 5;

-- Based on total user sessions --
SELECT country,
SUM(total_sessions) user_sessions
FROM users
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- Based on total page views --
SELECT country,
SUM(page_views) total_page_views
FROM users
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- Based on total active users --
SELECT country,
COUNT(activation_status) user_active
FROM users
WHERE activation_status = 1
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;


SELECT country, SUM(monthly_revenue)
FROM users
GROUP BY 1
ORDER BY 2 DESC;