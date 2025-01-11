import random
import csv

# Generate random data for AddOrderPayment procedure
data_addorderpayment = []

N = None

with open("samples_amount.txt","r") as infile:
    N = int(infile.read())


for _ in range(N):
    row = {
        "OrderID": random.randint(1, N)
    }
    data_addorderpayment.append(row)

# Write to CSV
output_file_addorderpayment = 'AddOrderPayment.csv'
with open(output_file_addorderpayment, mode='w', newline='', encoding='utf-8') as file:
    writer = csv.DictWriter(file, fieldnames=data_addorderpayment[0].keys())
    writer.writeheader()
    writer.writerows(data_addorderpayment)

print(f"CSV file for AddOrderPayment generated: {output_file_addorderpayment}")
