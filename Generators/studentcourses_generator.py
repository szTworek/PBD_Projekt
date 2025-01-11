import csv
import random

# Generate random data for AddStudentToCourse procedure
data_student_to_course = []

N = None

with open("samples_amount.txt","r") as infile:
    N = int(infile.read())


for _ in range(N):  # Generate N rows
    row = {
        "StudentID": random.randint(1, N),  # Assuming there are N students
        "CourseID": random.randint(1, N),  # Assuming there are N courses
    }
    data_student_to_course.append(row)

# Write to CSV format for Students to Courses
output_file_path_student_to_course = 'StudentToCourse.csv'
with open(output_file_path_student_to_course, mode='w', newline='', encoding='utf-8') as file:
    writer = csv.DictWriter(file, fieldnames=data_student_to_course[0].keys())
    writer.writeheader()
    writer.writerows(data_student_to_course)

print(f"CSV file for Students to Courses generated: {output_file_path_student_to_course}")
