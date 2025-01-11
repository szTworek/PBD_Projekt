import random
import faker
import csv

fake = faker.Faker()

data_internship = []

N = None

with open("samples_amount.txt","r") as infile:
    N = int(infile.read())


for _ in range(N):  # Generate N rows
    row = {
        "StartDate": fake.date_between(start_date='-2y', end_date='today'),  # Random start date within the last 2 years
        "SyllabusID": random.randint(1, 20),  # Assuming there are 20 syllabuses
        "InternshipDays": random.choice([14, 21, 28]),  # Default 14 or other common durations
    }
    data_internship.append(row)

# Write to CSV format for Internships
output_file_path_internship = 'Internships.csv'
with open(output_file_path_internship, mode='w', newline='', encoding='utf-8') as file:
    writer = csv.DictWriter(file, fieldnames=data_internship[0].keys())
    writer.writeheader()
    writer.writerows(data_internship)

print(f"CSV file for Internships generated: {output_file_path_internship}")
