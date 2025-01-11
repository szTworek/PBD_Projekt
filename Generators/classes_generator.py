import random
import faker
import csv

fake = faker.Faker()

# Generate random data for AddClass procedure
data_classes = []

N = None

with open("samples_amount.txt","r") as infile:
    N = int(infile.read())

class_types = ['onsiteclasses', 'onlineasyncclasses', 'onlinesyncclasses']

for _ in range(N):  # Generate N rows
    class_type = random.choice(class_types)

    row = {
        "ClassLecturerID": random.randint(1, 50),  # Assuming there are 50 lecturers
        "SubjectID": random.randint(1, N),  # Assuming there are N subjects
        "Topic": fake.sentence(nb_words=3),  # Random topic
        "Description": fake.paragraph(nb_sentences=3),
        "ClassPrice": round(random.uniform(50, 500), 2),  # Random price between 50 and 500
        "Date": fake.date_time_this_year().strftime('%Y-%m-%d %H:%M:%S'),
        "Duration": fake.time(pattern='%H:%M:%S'),
        "LanguageID": random.randint(1, 4),  # Assuming there are 10 languages
        "TranslatorID": random.choice([random.randint(1, 20), 2]),  # Random translator or None
        "PriceChange": round(random.uniform(1.0, 2.0), 2),  # PriceChange > 1
        "ClassTypeName": class_type,
        "LimitedPlaces": random.randint(5, 50),  # Random limit on places
        "ClassroomID": random.randint(1, N) if class_type == 'onsiteclasses' else  None,  # Provide ClassroomID for onsite classes
        "Link": fake.url() if class_type in ['onlineasyncclasses', 'onlinesyncclasses'] else None,  # Provide link for online classes
    }
    data_classes.append(row)

# Write to CSV format for Classes
output_file_path_classes = 'Classes.csv'
with open(output_file_path_classes, mode='w', newline='', encoding='utf-8') as file:
    writer = csv.DictWriter(file, fieldnames=data_classes[0].keys())
    writer.writeheader()
    writer.writerows(data_classes)

print(f"CSV file for Classes generated: {output_file_path_classes}")
