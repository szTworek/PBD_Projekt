import random
import csv

# Generate random data for AddStudentToClass procedure
data_addstudenttoclass = []

N = None

with open("samples_amount.txt","r") as infile:
    N = int(infile.read())


for _ in range(N):
    row = {
        "StudentID": random.randint(1, N),
        "ClassID": random.randint(1, 20)
    }
    data_addstudenttoclass.append(row)

# Write to CSV
output_file_addstudenttoclass = 'AddStudentToClass.csv'
with open(output_file_addstudenttoclass, mode='w', newline='', encoding='utf-8') as file:
    writer = csv.DictWriter(file, fieldnames=data_addstudenttoclass[0].keys())
    writer.writeheader()
    writer.writerows(data_addstudenttoclass)

print(f"CSV file for AddStudentToClass generated: {output_file_addstudenttoclass}")
