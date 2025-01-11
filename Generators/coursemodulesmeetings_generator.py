import faker
import csv
import random

fake = faker.Faker()

# Generate random data for AddCourseModuleMeeting procedure
data_course_module_meetings = []

N = None

with open("samples_amount.txt","r") as infile:
    N = int(infile.read())


for _ in range(N):  # Generate N rows
    row = {
        "CourseModuleID": random.randint(1, N),  # Assuming there are 50 course modules
        "Datetime": fake.date_time_between(start_date='-1y', end_date='now'),  # Random datetime in the last year
        "Duration": fake.time_object(),  # Random time object
        "Topic": fake.sentence(nb_words=4),  # Random 4-word topic
        "Description": fake.text(max_nb_chars=200),  # Random description text
        "Link": fake.url(),  # Random URL
        "ClassroomID": random.choice([None, random.randint(1, 20)]),  # Random classroom ID or None
    }
    data_course_module_meetings.append(row)

# Write to CSV format for Course Module Meetings
output_file_path_course_module_meetings = 'CourseModuleMeetings.csv'
with open(output_file_path_course_module_meetings, mode='w', newline='', encoding='utf-8') as file:
    writer = csv.DictWriter(file, fieldnames=data_course_module_meetings[0].keys())
    writer.writeheader()
    writer.writerows(data_course_module_meetings)

print(f"CSV file for Course Module Meetings generated: {output_file_path_course_module_meetings}")
