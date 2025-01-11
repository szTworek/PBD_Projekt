import random
import faker
import csv

# Generate random data for AddFinalExamGrade procedure
data_final_exam_grades = []

N = None

with open("samples_amount.txt","r") as infile:
    N = int(infile.read())


for _ in range(N):  # Generate N rows
    row = {
        "StudentID": random.randint(1, N),  # Assuming there are N students
        "SyllabusID": random.randint(1, 20),  # Assuming there are 20 syllabuses
        "GradeValue": random.choice([2.0, 3.0, 3.5, 4.0, 4.5, 5.0]),  # Random grade between 2.0 and 5.0
    }
    data_final_exam_grades.append(row)

# Write to CSV format for Final Exam Grades
output_file_path_final_exam_grades = 'FinalExamGrades.csv'
with open(output_file_path_final_exam_grades, mode='w', newline='', encoding='utf-8') as file:
    writer = csv.DictWriter(file, fieldnames=data_final_exam_grades[0].keys())
    writer.writeheader()
    writer.writerows(data_final_exam_grades)

print(f"CSV file for Final Exam Grades generated: {output_file_path_final_exam_grades}")
