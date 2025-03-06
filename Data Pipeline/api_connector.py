import gspread
from google_auth_oauthlib.flow import InstalledAppFlow

def fetch_google_sheet_data():
    """Fetch data from Google Sheets using OAuth 2.0 authentication."""
    # Define the correct scope
    scope = [
        "https://www.googleapis.com/auth/spreadsheets",
        "https://www.googleapis.com/auth/drive"
    ]

    # Authenticate using OAuth 2.0
    flow = InstalledAppFlow.from_client_secrets_file("credentials.json", scope)
    creds = flow.run_local_server(port=0)

    # Connect to Google Sheets
    client = gspread.authorize(creds)

    # Open Google Sheet
    sheet = client.open("wppool_growth_data_sample_20k").sheet1

    # Read data
    data = sheet.get_all_records()
    return data

if __name__ == "__main__":
    fetched_data = fetch_google_sheet_data()
    print(fetched_data)
