import os
import re

# Regular expression pattern for matching the text in the original format
#pattern = r'\| A \|\n\| :--- \|\n\|([\s\S]*?)\|'
pattern = r'\| A \|\n\| :--- \|\n\|([\s\S]*?)\| \n '

# Function to process each markdown file
def process_file(file_path):
    with open(file_path, 'r', encoding='cp1252', errors='ignore') as file:
        content = file.read()
        # Find matches using regular expression
        matches = re.findall(pattern, content, re.MULTILINE)
        for match in matches:
            # Replace with new format
            new_text = "```\n" + match.strip() + "\n```"
            content = content.replace("| A |\n| :--- |\n|" + match + "|", new_text)
    with open(file_path, 'w', encoding='cp1252', errors='ignore') as file:
        file.write(content)

# Get all markdown files in current folder
markdown_files = [file for file in os.listdir() if file.endswith('.md')]

# Process each markdown file
for file in markdown_files:
    process_file(file)

print("Text in the original format has been replaced with new format in all markdown files.")



# Regular expression pattern for matching the text to be removed
#pattern = r'\([hH][tT][tT][pP][sS]?://[\w\W]+\)'

pattern5 = r'\(http[^\]]+\)'

# Function to process each markdown file
def process_file(file_path):
    with open(file_path, 'r') as file:
        content = file.read()
        # Find matches using regular expression
        matches = re.findall(pattern5, content)
        for match in matches:
            # Remove characters [ ] ( )
            new_text = match.replace('(', '').replace(')', '')
            content = content.replace(match, new_text)
    with open(file_path, 'w') as file:
        file.write(content)

# Get all markdown files in current folder
markdown_files = [file for file in os.listdir() if file.endswith('.md')]

# Process each markdown file
for file in markdown_files:
    process_file(file)

print("Characters [ ], ( ), have been removed from the matched text in all markdown files.")


#Regular expression pattern for matching the text to be removed
#pattern2 = r'\\[\w\W]+\]'

pattern2 = r'\\\[[^\]]+\]'

# Function to process each markdown file
def process_file(file_path):
    with open(file_path, 'r') as file:
        content = file.read()
        # Find matches using regular expression
        matches = re.findall(pattern2, content)
        for match in matches:
            # Remove characters [ ] ( )
            new_text = match.replace('\[', '').replace(']', '')
            content = content.replace(match, new_text)
    with open(file_path, 'w') as file:
        file.write(content)

# Get all markdown files in current folder
markdown_files = [file for file in os.listdir() if file.endswith('.md')]

# Process each markdown file
for file in markdown_files:
    process_file(file)

print("Characters [ ], ( ), have been removed from the matched text in all markdown files.")



# Regular expression pattern3 for matching the text to be removed
pattern3 = r'\[http[^\]]+\]'

# Function to process each markdown file
def process_file(file_path):
    with open(file_path, 'r') as file:
        content = file.read()
        # Find matches using regular expression
        matches = re.findall(pattern3, content)
        for match in matches:
            # Remove text inside square brackets
            content = content.replace(match, '')
    with open(file_path, 'w') as file:
        file.write(content)

# Get all markdown files in current folder
markdown_files = [file for file in os.listdir() if file.endswith('.md')]

# Process each markdown file
for file in markdown_files:
    process_file(file)

print("All text inside square brackets has been removed from all markdown files.")




pattern4 = r'\\\[]'

# Function to process each markdown file
def process_file(file_path):
    with open(file_path, 'r') as file:
        content = file.read()
        # Find matches using regular expression
        matches = re.findall(pattern4, content)
        for match in matches:
            # Remove text inside square brackets
            content = content.replace(match, '[]')
    with open(file_path, 'w') as file:
        file.write(content)

# Get all markdown files in current folder
markdown_files = [file for file in os.listdir() if file.endswith('.md')]

# Process each markdown file
for file in markdown_files:
    process_file(file)

print("All text inside square brackets has been removed from all markdown files.")