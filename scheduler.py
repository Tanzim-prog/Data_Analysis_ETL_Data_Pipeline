import schedule
import time
from data_insertion import insert_data_into_mysql

def job():
    print("Fetching data from Google Sheets and updating MySQL...")
    insert_data_into_mysql()
# Run the script every 10 minutes
schedule.every(10).minutes.do(job)

while True:
    schedule.run_pending()
    time.sleep(1)
