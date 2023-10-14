#!/bin/bash

# Define default work_folder and clone_folder
work_folder="$(pwd)"        # Set work_folder to the current working directory
clone_folder="$work_folder/clone"  # Define the clone sub-folder

# Define properties files within work_folder
branch_properties="$work_folder/branch.properties"
project_changed_properties="$work_folder/project_changed.properties"

# Check if the branch_properties file exists
if [ ! -f "$branch_properties" ]; then
  echo "Error: branch.properties not found in the work_folder."
  exit 1
fi

# Read the current branch name from branch.properties
current_branch=$(grep '^current_branch=' "$branch_properties" | cut -d'=' -f2)

# Function to create a new branch in a project
create_branch() {
  local project="$1"
  
  # Check if the project folder exists within the clone_folder
  project_folder="$clone_folder/$project"
  if [ ! -d "$project_folder" ]; then
    echo "Project folder not found for '$project' in '$clone_folder'. Skipping."
  else
    # Navigate to the project folder
    cd "$project_folder" || exit 1

    # Check if the new branch already exists
    if git rev-parse --verify "$current_branch" >/dev/null 2>&1; then
      echo "Branch '$current_branch' already exists in project '$project'. Skipping."
    else
      # Create a new branch based on the current_branch and check it out
      git checkout -b "$current_branch"
      echo "Created and checked out branch '$current_branch' in project '$project'."
    fi

    # Return to the clone_folder
    cd "$clone_folder" || exit 1
  fi
}

# Iterate through projects listed in project_changed_properties
while read -r project || [ -n "$project" ]; do
  create_branch "$project"
done < "$project_changed_properties"
