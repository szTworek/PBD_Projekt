import csv
import random

data_internship_attendance = []

N = None

with open("samples_amount.txt","r") as infile:
    N = int(infile.read())


for _ in range(N):  # Generate N rows
    row = {
        "StudentID": random.randint(1, N),  # Assuming there are N students
        "InternshipID": random.randint(1, 50),  # Assuming there are 50 internships
        "InternshipDay": random.randint(1, 28),  # Random day within a 28-day internship period
        "Attendance": random.choice([0, 1]),  # Random attendance (0 or 1)
    }
    data_internship_attendance.append(row)

# Write to CSV format for Internship Attendance
output_file_path_internship_attendance = 'InternshipAttendance.csv'
with open(output_file_path_internship_attendance, mode='w', newline='', encoding='utf-8') as file:
    writer = csv.DictWriter(file, fieldnames=data_internship_attendance[0].keys())
    writer.writeheader()
    writer.writerows(data_internship_attendance)

print(f"CSV file for Internship Attendance generated: {output_file_path_internship_attendance}")
