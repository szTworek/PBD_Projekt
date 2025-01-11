import random 
import csv

# Generate random data for AddCourseModule procedure
data_course_modules = []

N = None

with open("samples_amount.txt","r") as infile:
    N = int(infile.read())


for _ in range(N):  # Generate N rows
    row = {
        "CourseID": random.randint(1, N),  # Assuming there are N courses
        "CourseType": random.choice(["onsitecourse",'hybrid','onlineasynccourse','onlinesynccourse']),  # Random course type
    }
    data_course_modules.append(row)

# Write to CSV format for Course Modules
output_file_path_course_modules = 'CourseModules.csv'
with open(output_file_path_course_modules, mode='w', newline='', encoding='utf-8') as file:
    writer = csv.DictWriter(file, fieldnames=data_course_modules[0].keys())
    writer.writeheader()
    writer.writerows(data_course_modules)

print(f"CSV file for Course Modules generated: {output_file_path_course_modules}")
