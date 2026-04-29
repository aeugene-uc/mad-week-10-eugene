import os
import re
import shutil

project_dir = r"c:\Users\a_eug\Eugene\Kuliah\MAD\W10\MAD_Lab_Week_10"

header_template = """//
//  {filename}
//  MAD Week 10 Eugene
//
//  Created by student on 29/04/26.
//

"""

renames = {
    "AppUser": "User",
    "StoryListViewModel": "StoriesViewModel",
    "GameplayViewModel": "GameViewModel",
    "NodeEditorViewModel": "StoryNodeViewModel",
    "MAD_Lab_Week_10App": "MAD_Week_10_EugeneApp",
    "MainTabLayout": "MainTabView",
    "AdminPage": "AdminView",
    "CreateStorySheet": "CreateStoryView",
    "GameplayPage": "GameplayView",
    "HomePage": "HomeView",
    "LoginPage": "LoginView",
    "NodeEditorSheet": "NodeEditorView",
    "ProfilePage": "ProfileView",
    "RegisterPage": "RegisterView",
    "StoryNodesPage": "StoryNodesView",
    "AchievementRow": "AchievementRowView",
    "AnimatedNarrativeText": "AnimatedNarrativeTextView",
    "AppTextField": "AppTextFieldView",
    "ChoiceButton": "ChoiceButtonView",
    "PrimaryButton": "PrimaryButtonView",
    "SectionHeader": "SectionHeaderView",
    "SeedDataRow": "SeedDataRowView",
    "StoryCard": "StoryCardView"
}

# Directories to flatten
views_dir = os.path.join(project_dir, "Views")
components_dir = os.path.join(views_dir, "Components")
layouts_dir = os.path.join(views_dir, "Layouts")
pages_dir = os.path.join(views_dir, "Pages")

# Step 1: Move all files from Layouts and Pages to Views
def move_files():
    for d in [layouts_dir, pages_dir]:
        if os.path.exists(d):
            for f in os.listdir(d):
                if f.endswith(".swift"):
                    shutil.move(os.path.join(d, f), os.path.join(views_dir, f))
            os.rmdir(d) # Remove empty directories

move_files()

# Step 2: Rename files
def rename_files():
    for root, dirs, files in os.walk(project_dir):
        for file in files:
            if file.endswith(".swift"):
                base_name = file[:-6]
                if base_name in renames:
                    new_name = renames[base_name] + ".swift"
                    os.rename(os.path.join(root, file), os.path.join(root, new_name))

rename_files()

# App file special case
app_file_old = os.path.join(project_dir, "MAD_Lab_Week_10App.swift")
app_file_new = os.path.join(project_dir, "MAD_Week_10_EugeneApp.swift")
if os.path.exists(app_file_old):
    os.rename(app_file_old, app_file_new)

# Step 3: Process content of each swift file
def process_content():
    for root, dirs, files in os.walk(project_dir):
        for file in files:
            if file.endswith(".swift"):
                file_path = os.path.join(root, file)
                with open(file_path, "r", encoding="utf-8") as f:
                    content = f.read()

                # Remove existing header comments (assumes they are at the top)
                # Regex to match leading comments
                content = re.sub(r'^(//.*\n)+', '', content, flags=re.MULTILINE)
                
                # Replace class/struct names and types
                for old_name, new_name in renames.items():
                    # Use word boundary to avoid partial matches
                    content = re.sub(r'\b' + old_name + r'\b', new_name, content)
                
                # Add gap between imports and code
                content = re.sub(r'(import .*?\n)(?!\s*import|\s*\n)', r'\1\n', content)

                # Add new header
                header = header_template.format(filename=file)
                new_content = header + content.lstrip()

                with open(file_path, "w", encoding="utf-8") as f:
                    f.write(new_content)

process_content()
print("Refactoring script completed.")
