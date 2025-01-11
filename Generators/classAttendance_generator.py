import random
import faker
import csv
    

data_attendance = []

N = None

with open("samples_amount.txt","r") as infile:
    N = int(infile.read())

for _ in range(N):  # Generate N rows
    row = {
        "StudentID": random.randint(1, N),  # Assuming there are N students
        "ClassID": random.randint(1, N),  # Assuming there are N classes
        "Attendance": random.choice([0, 1]),  # Random attendance (0 or 1)
    }
    data_attendance.append(row)

# Write to CSV format for Class Attendance
output_file_path_attendance = 'ClassAttendance.csv'
with open(output_file_path_attendance, mode='w', newline='', encoding='utf-8') as file:
    writer = csv.DictWriter(file, fieldnames=data_attendance[0].keys())
    writer.writeheader()
    writer.writerows(data_attendance)

print(f"CSV file for Class Attendance generated: {output_file_path_attendance}")
