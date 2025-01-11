import random
import csv

# Generate random data for AddStudentToCourse procedure
data_addstudenttocourse = []

N = None

with open("samples_amount.txt","r") as infile:
    N = int(infile.read())


for _ in range(N):
    row = {
        "StudentID": random.randint(1, N),
        "CourseID": random.randint(1, 30)
    }
    data_addstudenttocourse.append(row)

# Write to CSV
output_file_addstudenttocourse = 'AddStudentToCourse.csv'
with open(output_file_addstudenttocourse, mode='w', newline='', encoding='utf-8') as file:
    writer = csv.DictWriter(file, fieldnames=data_addstudenttocourse[0].keys())
    writer.writeheader()
    writer.writerows(data_addstudenttocourse)

print(f"CSV file for AddStudentToCourse generated: {output_file_addstudenttocourse}")
