import mysql.connector
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# Replace with your MySQL credentials
conn = mysql.connector.connect(
    host="127.0.0.1",
    user="root",
    password="Sanx12345#",
    database="growth_data"
)

cursor = conn.cursor()

query = """
SELECT metric, 
       (n * sum_xy - sum_x * sum_y) / NULLIF(SQRT((n * sum_x2 - sum_x * sum_x) * (n * sum_y2 - sum_y * sum_y)), 0) AS correlation
FROM (
    SELECT 'Total Sessions' AS metric, COUNT(*) AS n,
           SUM(total_sessions) AS sum_x, SUM(churned) AS sum_y,
           SUM(total_sessions * churned) AS sum_xy,
           SUM(total_sessions * total_sessions) AS sum_x2,
           SUM(churned * churned) AS sum_y2 FROM users
    UNION ALL
    SELECT 'Page Views', COUNT(*), SUM(page_views), SUM(churned),
           SUM(page_views * churned), SUM(page_views * page_views),
           SUM(churned * churned) FROM users
    UNION ALL
    SELECT 'Download Clicks', COUNT(*), SUM(download_clicks), SUM(churned),
           SUM(download_clicks * churned), SUM(download_clicks * download_clicks),
           SUM(churned * churned) FROM users
    UNION ALL
    SELECT 'Activation Status', COUNT(*), SUM(activation_status), SUM(churned),
           SUM(activation_status * churned), SUM(activation_status * activation_status),
           SUM(churned * churned) FROM users
    UNION ALL
    SELECT 'Days Active', COUNT(*), SUM(days_active), SUM(churned),
           SUM(days_active * churned), SUM(days_active * days_active),
           SUM(churned * churned) FROM users
    UNION ALL
    SELECT 'Monthly Revenue', COUNT(*), SUM(monthly_revenue), SUM(churned),
           SUM(monthly_revenue * churned), SUM(monthly_revenue * monthly_revenue),
           SUM(churned * churned) FROM users
) AS stats;
"""

cursor.execute(query)
result = cursor.fetchall()

# Convert result into DataFrame
df = pd.DataFrame(result, columns=['Metric', 'Correlation'])

# Close the connection
cursor.close()
conn.close()

# Sort the DataFrame based on correlation values
df = df.sort_values(by="Correlation", ascending=True)

# Set figure size and style
plt.figure(figsize=(12, 6))
sns.set(style="whitegrid")

# Define color palette based on correlation sign
colors = df['Correlation'].apply(lambda x: 'red' if x < 0 else 'green').tolist()  # Convert Series to list

# Create a horizontal barplot
ax = sns.barplot(x='Correlation', y='Metric', data=df, palette=colors)

# Add correlation values as annotations
for index, value in enumerate(df['Correlation']):
    ax.text(value, index, f"{value:.2f}", 
            color='black', ha="left" if value > 0 else "right",
            fontsize=12, fontweight='bold')

# Customize axes and titles
plt.axvline(x=0, color='black', linewidth=1.2, linestyle="--")  # Vertical line at 0
plt.xlabel("Pearson Correlation with Churn", fontsize=14)
plt.ylabel("Feature", fontsize=14)
plt.title("Feature Correlation with Churn (Higher magnitude = Stronger Relationship)", fontsize=16, fontweight='bold')

# Remove spines for a clean look
sns.despine(left=True, bottom=True)

# Show the plot
plt.show()
