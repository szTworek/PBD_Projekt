import csv 
import random 

# Generate random data for AddCourseModuleAttendance procedure
data_course_module_attendance = []

N = None

with open("samples_amount.txt","r") as infile:
    N = int(infile.read())


for _ in range(N):  # Generate N rows
    row = {
        "CourseModuleID": random.randint(1, N),  # Assuming there are 50 course modules
        "StudentID": random.randint(1, N),  # Assuming there are N students
        "Attended": random.choice([0, 1]),  # Random attendance (0 or 1)
    }
    data_course_module_attendance.append(row)

# Write to CSV format for Course Module Attendance
output_file_path_course_module_attendance = 'CourseModuleAttendance.csv'
with open(output_file_path_course_module_attendance, mode='w', newline='', encoding='utf-8') as file:
    writer = csv.DictWriter(file, fieldnames=data_course_module_attendance[0].keys())
    writer.writeheader()
    writer.writerows(data_course_module_attendance)

print(f"CSV file for Course Module Attendance generated: {output_file_path_course_module_attendance}")
