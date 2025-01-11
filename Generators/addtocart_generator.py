import random
import faker
import csv

fake = faker.Faker()

# Generate random data for AddToCart procedure
data_addtocart = []

N = None

with open("samples_amount.txt","r") as infile:
    N = int(infile.read())


for _ in range(N):
    row = {
        "StudentID": random.randint(1, N),
        "WebinarID": random.randint(1, 10) if random.random() < 0.5 else None,  # 50% chance to be None
        "ClassID": random.randint(1, 20) if random.random() < 0.5 else None,
        "CourseID": random.randint(1, 30) if random.random() < 0.5 else None,
        "SyllabusID": random.randint(1, 5) if random.random() < 0.5 else None
    }
    data_addtocart.append(row)

# Write to CSV
output_file_addtocart = 'AddToCart.csv'
with open(output_file_addtocart, mode='w', newline='', encoding='utf-8') as file:
    writer = csv.DictWriter(file, fieldnames=data_addtocart[0].keys())
    writer.writeheader()
    writer.writerows(data_addtocart)

print(f"CSV file for AddToCart generated: {output_file_addtocart}")
