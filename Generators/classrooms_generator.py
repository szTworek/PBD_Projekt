import random
import faker
import csv
from datetime import datetime, timedelta

fake = faker.Faker()

# Generate random data for Classes table
data = []

N = None

with open("samples_amount.txt","r") as infile:
    N = int(infile.read())

for _ in range(N):  # Generate N rows
    row = {
        "BuildingID":  random.randint(1,N),
        "PlacesLimit": random.randint(10,200)
    }
    data.append(row)

# Write to CSV format
output_file_path = 'Classrooms.csv'
with open(output_file_path, mode='w', newline='', encoding='utf-8') as file:
    writer = csv.DictWriter(file, fieldnames=data[0].keys())
    writer.writeheader()
    writer.writerows(data)

print(f"CSV file generated: {output_file_path}")
