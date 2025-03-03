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

SELECT *
FROM growth_data.users;