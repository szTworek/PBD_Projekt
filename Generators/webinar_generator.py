import random
import faker
import csv
# Generate random data for AddWebinar procedure
data_webinars = []

N = None

with open("samples_amount.txt","r") as infile:
    N = int(infile.read())


fake = faker.Faker()

for _ in range(N):  # Generate N rows
    row = {
        "EmployeeID": random.randint(1, 50),  # Assuming there are 50 employees
        "TranslatorID": random.randint(1, 20),  # Some webinars might not have a translator
        "WebinarTopic": fake.sentence(nb_words=5),  # Random webinar topic with 5 words
        "Description": fake.paragraph(nb_sentences=3),  # Random description with 3 sentences
        "Price": round(random.uniform(50, 500), 2),  # Random price between 50 and 500
        "WebinarDate": fake.date_time_between(start_date='-1y', end_date='now'),  # Random date within the last year
        "Duration": fake.time_object(),  # Random time duration
        "LanguageID": random.randint(1, 4),  # Assuming there are 10 languages
        "Link": fake.url(),  # Random URL
    }
    data_webinars.append(row)

# Write to CSV format for Webinars
output_file_path_webinars = 'Webinars.csv'
with open(output_file_path_webinars, mode='w', newline='', encoding='utf-8') as file:
    writer = csv.DictWriter(file, fieldnames=data_webinars[0].keys())
    writer.writeheader()
    writer.writerows(data_webinars)

print(f"CSV file for Webinars generated: {output_file_path_webinars}")
