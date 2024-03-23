import sys, csv

# Adds a user name field, which AWS CLI needs, but AWS IAM does not provide (for mysterious reasons)

path_in = sys.argv[1]
path_out = sys.argv[2]

with open(path_in, 'r') as file_in:
    data = list(csv.reader(file_in))

data[0].append("User Name")
data[1].append("default")

with open(path_out, 'w') as file_out:
    csv.writer(file_out).writerows(data)

