import os
import re
files = [f for f in os.listdir() if os.path.isfile(f)]

output = ''
for file in files:
    if re.search(r'(Add|Edit|Delete).*\.sql',file):
        with open(file,'r') as infile:
            output += infile.read()
            output += '\n'
    
with open('AllProcedures.sql','w') as outfile:
    outfile.write(output)