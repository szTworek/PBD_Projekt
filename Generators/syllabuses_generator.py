import random
import faker
import csv
from datetime import datetime, timedelta

fake = faker.Faker()

# Generate random data for Syllabuses table
data = []

N = None

with open("samples_amount.txt","r") as infile:
    N = int(infile.read())

for _ in range(N):  # Generate N rows
    start_date = fake.date_between(start_date='-2y', end_date='-1y')
    end_date = fake.date_between(start_date='+1y', end_date='+2y')
    start_year = random.randint(2000, 2099)
    end_year = start_year + random.choice([5,3,2])
    row = {
        "Description": fake.paragraph(nb_sentences=3),
        "StudiesEntryFee": round(random.uniform(100, 1000), 2),  # Random fee between 100, 1000
        "EmployeeID": random.randint(1, 50),
        "PriceChange": round(random.uniform(1.0, 2.0), 2),  # PriceChange > 0
        "Edition": f"{start_year}/{end_year}",  # Format YYYY/YYYY
        "StartDate": start_date.strftime('%Y-%m-%d'),
        "EndDate": end_date.strftime('%Y-%m-%d'),
        "PlaceLimit": random.randint(5, 50),
    }
    data.append(row)

# Write to CSV format
output_file_path = 'Syllabuses.csv'
with open(output_file_path, mode='w', newline='', encoding='utf-8') as file:
    writer = csv.DictWriter(file, fieldnames=data[0].keys())
    writer.writeheader()
    writer.writerows(data)

print(f"CSV file generated: {output_file_path}")
