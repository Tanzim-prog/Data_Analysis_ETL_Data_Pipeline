import mysql.connector 
from datetime import datetime
from api_connector import fetch_google_sheet_data  # Import data function

def insert_data_into_mysql():
    """Fetches data from Google Sheets and inserts it into MySQL"""
    
    # Connect to MySQL
    db_connection = mysql.connector.connect(
        host="local host name",
        user="mysql user name",
        password="mysql password",
        database="database name"
    )
    cursor = db_connection.cursor()

    # Define the insertion query
    insertion_query = """
        INSERT IGNORE INTO users (user_id, install_date, last_active_date, subscription_type, country, total_sessions, 
        page_views, download_clicks, activation_status, days_active, pro_upgrade_date, plan_type, 
        monthly_revenue, churned)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s) 
    """

    # Fetch data from Google Sheets
    sheet_data = fetch_google_sheet_data()

    def convert_date_format(date_str):
        """Converts date from MM/DD/YYYY to YYYY-MM-DD"""
        try:
            return datetime.strptime(date_str, "%m/%d/%Y").strftime("%Y-%m-%d")
        except ValueError:
            return None  # Handle invalid dates

    # Check if rows have the correct number of columns
    expected_keys = ['user_id', 'install_date', 'last_active_date', 'subscription_type', 'country', 
                    'total_sessions', 'page_views', 'download_clicks', 'activation_status', 'days_active', 
                    'pro_upgrade_date', 'plan_type', 'monthly_revenue', 'churned']
    
    for row in sheet_data:
        missing_keys = [key for key in expected_keys if key not in row]
        if missing_keys:
            print(f"❌ Missing keys in row: {missing_keys}")
            continue  # Skip rows with missing data

    # Convert and insert data
    data_to_insert = [
        (row['user_id'], convert_date_format(row['install_date']), convert_date_format(row['last_active_date']),
         row['subscription_type'], row['country'], row['total_sessions'], row['page_views'], 
         row['download_clicks'], row['activation_status'], row['days_active'], convert_date_format(row['pro_upgrade_date']),
         row['plan_type'], row['monthly_revenue'], row['churned']) 
        for row in sheet_data
        if all(key in row for key in expected_keys)  # Ensure all required keys exist
    ]

    # Debugging: Check if data matches expected format
    if data_to_insert:
        print(f"✅ First row sample: {data_to_insert[0]} (Expected 14 values)")
        print(f"✅ Total rows: {len(data_to_insert)}")

        # Execute insert query
        cursor.executemany(insertion_query, data_to_insert)
        db_connection.commit()

        print(f"✅ Inserted {cursor.rowcount} records successfully!")
    else:
        print("⚠️ No valid data to insert.")

    # ✅ Close connection
    cursor.close()
    db_connection.close()
