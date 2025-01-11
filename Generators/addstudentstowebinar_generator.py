import random
import csv
import faker 

fake = faker.Faker()

# Generate random data for AddStudentToWebinar procedure
data_addstudenttowebinar = []

N = None

with open("samples_amount.txt","r") as infile:
    N = int(infile.read())


for _ in range(N):
    row = {
        "StudentID": random.randint(1, N),
        "WebinarID": random.randint(1, 10),
        "Date": fake.date_time_between(start_date='-1y', end_date='now')
    }
    data_addstudenttowebinar.append(row)

# Write to CSV
output_file_addstudenttowebinar = 'AddStudentToWebinar.csv'
with open(output_file_addstudenttowebinar, mode='w', newline='', encoding='utf-8') as file:
    writer = csv.DictWriter(file, fieldnames=data_addstudenttowebinar[0].keys())
    writer.writeheader()
    writer.writerows(data_addstudenttowebinar)

print(f"CSV file for AddStudentToWebinar generated: {output_file_addstudenttowebinar}")
