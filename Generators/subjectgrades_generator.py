import random
import faker
import csv

fake = faker.Faker()

# Generate random data for AddSubjectsGrade procedure
data_subjects_grades = []

N = None

with open("samples_amount.txt","r") as infile:
    N = int(infile.read())


for _ in range(N):  # Generate N rows
    row = {
        "StudentID": random.randint(1, N),  # Assuming there are N students
        "GradeValue": random.choice([2.0, 3.0, 3.5, 4.0, 4.5, 5.0]),  # Random grade between 1.0 and 5.0
        "SubjectID": random.randint(1, 50),  # Assuming there are 50 subjects
    }
    data_subjects_grades.append(row)

# Write to CSV format for Subjects Grades
output_file_path_subjects_grades = 'SubjectsGrades.csv'
with open(output_file_path_subjects_grades, mode='w', newline='', encoding='utf-8') as file:
    writer = csv.DictWriter(file, fieldnames=data_subjects_grades[0].keys())
    writer.writeheader()
    writer.writerows(data_subjects_grades)

print(f"CSV file for Subjects Grades generated: {output_file_path_subjects_grades}")
