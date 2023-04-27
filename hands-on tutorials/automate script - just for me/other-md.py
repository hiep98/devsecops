import os
import shutil
import glob
import re
import codecs

# source_folder = "D:\\TeraBoxDownload\\one-note\\onemore\\md - Copy"
destination_folder = "D:\TeraBoxDownload\one-note\onemore\md"
images_folder = os.path.join(destination_folder, "images")

# Copy all files except one.py and one.sh
# for file in os.listdir(source_folder):
#     if file not in ["one.py", "one.sh"]:
#         shutil.copy(os.path.join(source_folder, file), destination_folder)

# Create images folder and copy all .png files into it
os.makedirs(images_folder, exist_ok=True)
for png_file in glob.glob(os.path.join(destination_folder, "*.png")):
    shutil.move(png_file, os.path.join(images_folder, os.path.basename(png_file)))

# Update markdown files
def replace_image_path(match):
    return f"![{match.group(1)}](images/{match.group(2)}.png)"
for md_file in glob.glob(os.path.join(destination_folder, "*.md")):
    with open(md_file, "r",  encoding='utf-8', errors='ignore') as file:
        content = file.read()

    updated_content = re.sub(r'!\[(.*?)\]\((.*?)\.png\)', replace_image_path, content)

    with open(md_file, "w", encoding='utf-8', errors='ignore') as file:
        file.write(updated_content)

        
# fix suggest

# import re

# with open('file.txt', 'r') as f:
#     content = f.read()

# content = re.sub(r'\u2192', '', content)

# with open('file.txt', 'w') as f:
#     f.write(content)


# import codecs

# with open('file.txt', 'r', encoding='cp1252') as f:
#     content = f.read()

# with open('file.txt', 'w', encoding='utf-8') as f:
#     f.write(content)


# import re

# with open('file.txt', 'r') as f:
#     content = f.read()

# content = re.sub(r'\u2192', '', content)

# with open('file.txt', 'w') as f:
#     f.write(content)


# import codecs

# with open('file.txt', 'r', encoding='utf-8') as f:
#     content = f.read()

# with open('file.txt', 'w', encoding='utf-8') as f:
#     f.write(content)


# import codecs

# with open('file.txt', 'r', encoding='utf-8') as f:
#     content = f.read()

# # Remove the arrow symbol from the content
# content = content.replace('\u2192', '')

# with open('file.txt', 'w', encoding='utf-8') as f:
#     f.write(content)
