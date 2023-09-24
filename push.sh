#!/bin/bash

# Define default work_folder
work_folder="$(pwd)"  # Set work_folder to the current working directory

# Define properties files within work_folder
project_list_properties="$work_folder/project_list.properties"

# Check if the project_list_properties file exists
if [ ! -f "$project_list_properties" ]; then
  echo "Error: project_list.properties not found in the work_folder."
  exit 1
fi

# Read the project names from project_list.properties and push each project
while read -r project; do
  # Navigate to the project folder within work_folder
  cd "$work_folder/$project" || exit 1

  # Get the current branch name
  current_branch=$(git symbolic-ref --short HEAD)

  # Push changes to the remote repository and set the upstream branch
  git push --set-upstream origin "$current_branch"

  # Return to the script's folder (work_folder)
  cd - || exit 1

  echo "Pushed changes for branch '$current_branch' in project '$project'"
done < "$project_list_properties"
