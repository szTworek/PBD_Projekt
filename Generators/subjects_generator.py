import random
import faker
import csv

fake = faker.Faker()

# Generate random data for Subjects table
data = []

N = None

with open("samples_amount.txt","r") as infile:
    N = int(infile.read())

for _ in range(N):  # Generate N rows
    row = {
        "SubjectName": fake.word().capitalize(),  # Random single word as SubjectName
        "SyllabusID": random.randint(1, N),  # Assuming there are N Syllabuses
        "Description": fake.paragraph(nb_sentences=2),
    }
    data.append(row)

# Write to CSV format
output_file_path = 'Subjects.csv'
with open(output_file_path, mode='w', newline='', encoding='utf-8') as file:
    writer = csv.DictWriter(file, fieldnames=data[0].keys())
    writer.writeheader()
    writer.writerows(data)

print(f"CSV file generated: {output_file_path}")