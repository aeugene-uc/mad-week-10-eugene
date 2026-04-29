import os
import re

project_dir = r"c:\Users\a_eug\Eugene\Kuliah\MAD\W10\MAD_Lab_Week_10"

for root, dirs, files in os.walk(project_dir):
    for file in files:
        if file.endswith(".swift") and "Models" not in root:
            file_path = os.path.join(root, file)
            with open(file_path, "r", encoding="utf-8") as f:
                content = f.read()

            # Revert SwiftUI label closures
            new_content = content.replace("} optionText: {", "} label: {")
            new_content = new_content.replace(" optionText: {", " label: {")
            new_content = new_content.replace("optionText: Text", "label: Text")
            
            # Write back
            with open(file_path, "w", encoding="utf-8") as f:
                f.write(new_content)

print("Fix completed.")
