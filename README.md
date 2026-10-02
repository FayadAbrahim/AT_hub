# Assistive Technology Hub

The website reads two Excel files, so you never edit code:

    data/tutorials.xlsx   one row per tool (name, category, tutorial link, description)
    data/students.xlsx    one row per student (grade, device, supports, tools, recommendation)

Edit a file, save, publish. The site updates in 1-2 minutes. Each file has a "How to update" tab.

## Add a tutorial
Open data/tutorials.xlsx and add a row at the bottom. Only "Tool name" is required.
- Category: same category = same group on the site. A new category name makes a new group.
- Tutorial link: paste the full address starting with https://
- Also called: other spellings used in students.xlsx, separated by semicolons.

## Add a student
Open data/students.xlsx and add a row. Last name, First name and Grade are required.
- Supports and Tools: separate items with semicolons.
- Tools that match a tutorial become links to it. Any other name shows as a plain label.
- New kind of support? Add a row on the Supports tab, then use that exact name.

## Publish your changes (pick one)
A) On github.com: open your repo, open the data folder, Add file -> Upload files,
   drop in the updated .xlsx, Commit changes.
B) With the script: ./deploy.sh [repo-name] [public|full]
   (first-time setup: install git and the GitHub CLI, then run: gh auth login)

## Privacy - read before uploading students.xlsx
GitHub Pages is public, and anyone can download the .xlsx files in the repo.
- ./deploy.sh (default "public") leaves students.xlsx out, so the site shows tutorials only.
  The student section appears on its own only when data/students.xlsx is in the repo.
- Only use "full", or upload students.xlsx, if your school has approved publishing student names.
- Do not paste internal notes (purchase orders, follow-ups) into students.xlsx.

## Notes
- Open the site from its web address. Opening index.html from a saved file will not load the data.
- vendor/xlsx.full.min.js is the library that reads the Excel files. Leave it in place.
