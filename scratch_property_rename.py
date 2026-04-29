import os
import re

project_dir = r"c:\Users\a_eug\Eugene\Kuliah\MAD\W10\MAD_Lab_Week_10"

# Specific patterns to safely replace properties
replacements = [
    (r'\bname:', 'userName:'),
    (r'\bemail:', 'userEmail:'),
    (r'\bstatus:', 'userStatus:'),
    (r'\bcompletedStories:', 'finishedStories:'),
    
    (r'\.name\b', '.userName'),
    (r'\.email\b', '.userEmail'),
    (r'\.status\b', '.userStatus'),
    (r'\.completedStories\b', '.finishedStories'),
    
    (r'\btitle:', 'storyTitle:'),
    (r'\bdescription:', 'storyDesc:'),
    (r'\bcategory:', 'storyCategory:'),
    (r'\bentryNodeId:', 'startNodeId:'),
    
    (r'\.title\b', '.storyTitle'),
    (r'\.description\b', '.storyDesc'),
    (r'\.category\b', '.storyCategory'),
    (r'\.entryNodeId\b', '.startNodeId'),
    
    (r'\bnarrative:', 'storyText:'),
    (r'\bchoices:', 'options:'),
    (r'\bisEntryPoint:', 'isStart:'),
    (r'\bisEnding:', 'isEnd:'),
    (r'\bcreatedAt:', 'timestamp:'),
    
    (r'\.narrative\b', '.storyText'),
    (r'\.choices\b', '.options'),
    (r'\.isEntryPoint\b', '.isStart'),
    (r'\.isEnding\b', '.isEnd'),
    (r'\.createdAt\b', '.timestamp'),
    
    (r'\blabel:', 'optionText:'),
    (r'\bnextNodeId:', 'followingNodeId:'),
    
    (r'\.label\b', '.optionText'),
    (r'\.nextNodeId\b', '.followingNodeId'),
    
    # Achievement specific
    (r'\.iconName\b', '.badgeIcon'),
    (r'\.isUnlocked\b', '.hasUnlocked'),
    (r'\biconName:', 'badgeIcon:'),
    (r'\bisUnlocked:', 'hasUnlocked:'),
]

# Do not replace 'title' blindly, but '.title' and 'title:' are mostly safe except maybe `.navigationTitle`. But `.navigationTitle` is matched by `.navigationTitle`, not `.title`. 
# Wait, what if someone named a variable `title`? `title: "hello"` would become `storyTitle: "hello"`. This might break Text(title), but wait, `Text(title)` is just `title`, not `title:`.
# We need to be careful. Let's just run it and fix the compilation errors manually using swift build or xcodebuild if available, or just manually check.

for root, dirs, files in os.walk(project_dir):
    for file in files:
        if file.endswith(".swift"):
            file_path = os.path.join(root, file)
            with open(file_path, "r", encoding="utf-8") as f:
                content = f.read()

            new_content = content
            for old, new in replacements:
                # Do not replace if it's part of a framework keyword like navigationTitle
                # Oh wait, regex \.title\b replaces .title in obj.title
                new_content = re.sub(old, new, new_content)
                
            # Extra safety: fix some known false positives
            # If navigationTitle became navigationStoryTitle
            new_content = new_content.replace('navigationStoryTitle', 'navigationTitle')
            new_content = new_content.replace('navigationUserName', 'navigationName')

            # We also need to change paddings and spacings.
            # .padding() -> .padding(18) or change existing .padding(X) to X+2
            def change_padding(match):
                val = match.group(1)
                if val:
                    try:
                        new_val = int(val) + 2
                        return f'.padding({new_val})'
                    except:
                        return match.group(0)
                else:
                    return '.padding(18)'

            new_content = re.sub(r'\.padding\(\s*([0-9]+)?\s*\)', change_padding, new_content)
            
            # Change spacing in stacks
            def change_spacing(match):
                val = match.group(1)
                try:
                    new_val = int(val) + 4
                    return f'spacing: {new_val}'
                except:
                    return match.group(0)
                    
            new_content = re.sub(r'spacing:\s*([0-9]+)', change_spacing, new_content)

            with open(file_path, "w", encoding="utf-8") as f:
                f.write(new_content)

print("Property renaming and paraphrasing completed.")
