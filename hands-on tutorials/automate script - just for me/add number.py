import os
import datetime

# Get the user input for the directory path
directory_path = input("Enter the directory path: ")

# Get the list of all the files in the directory
file_list = os.listdir(directory_path)

# Sort the file list by date modified
file_list.sort(key=lambda x: os.path.getmtime(os.path.join(directory_path, x)))

# Iterate through the file list and add the number to the first filename
for i, file_name in enumerate(file_list):
    new_filename = "{}. {}".format(i + 1, file_name)
    os.rename(os.path.join(directory_path, file_name), os.path.join(directory_path, new_filename))

# Print a message to the user
print("The files have been successfully renamed.")




# #DELETE 3 Characters
# import os

# # Get a list of all files in the current folder
# files = os.listdir()

# # Iterate over the list of files
# for file in files:

#     # Get the first 3 characters of the file name
#     first_3_characters = file[:3]

#     # Remove the first 3 characters from the file name
#     new_file_name = file[3:]

#     # Rename the file
#     os.rename(file, new_file_name)

# print("Done!")


