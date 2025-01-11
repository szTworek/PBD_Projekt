import csv
import faker
import random

fake = faker.Faker()

data_courses = []

N = None

with open("samples_amount.txt","r") as infile:
    N = int(infile.read())


for _ in range(N):  # Generate N rows
    row = {
        "Topic": fake.sentence(nb_words=4),  # Random 4-word topic
        "ClassLecturerID": random.randint(1, 50),  # Assuming there are 50 lecturers
        "CoursePrice": round(random.uniform(100, 1000), 2),  # Random price between 100, 1000
        "Language": random.choice( ["English","Polish","German","French","Esperanto"]),  # Random language name
        "PriceChange": round(random.uniform(1.0, 1.5), 2),  # Random price change multiplier
        "TranslatorID": random.randint(1, 20),  # Random translator or None
        "Description": fake.text(max_nb_chars=200),  # Random description text
    }
    data_courses.append(row)

# Write to CSV format for Courses
output_file_path_courses = 'Courses.csv'
with open(output_file_path_courses, mode='w', newline='', encoding='utf-8') as file:
    writer = csv.DictWriter(file, fieldnames=data_courses[0].keys())
    writer.writeheader()
    writer.writerows(data_courses)

print(f"CSV file for Courses generated: {output_file_path_courses}")
