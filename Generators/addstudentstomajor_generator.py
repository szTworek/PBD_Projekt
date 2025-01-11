import random
import csv

# Generate random data for AddStudentToMajor procedure
data_addstudenttomajor = []

N = None

with open("samples_amount.txt","r") as infile:
    N = int(infile.read())


for _ in range(N):
    row = {
        "StudentID": random.randint(1, N),
        "SyllabusID": random.randint(1, 5)
    }
    data_addstudenttomajor.append(row)

# Write to CSV
output_file_addstudenttomajor = 'AddStudentToMajor.csv'
with open(output_file_addstudenttomajor, mode='w', newline='', encoding='utf-8') as file:
    writer = csv.DictWriter(file, fieldnames=data_addstudenttomajor[0].keys())
    writer.writeheader()
    writer.writerows(data_addstudenttomajor)

print(f"CSV file for AddStudentToMajor generated: {output_file_addstudenttomajor}")
