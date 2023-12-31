#!/bin/bash

# Define default work_folder and clone_folder
work_folder="${1:-$(pwd)}"  # Use the provided folder or set work_folder to the current working directory
clone_folder="$work_folder/clone"  # Define the clone sub-folder

# Define properties files within work_folder
branch_properties="$work_folder/branch.properties"
project_unchanged_properties="$work_folder/project_unchanged.properties"
project_changed_properties="$work_folder/project_changed.properties"

# Check if the branch_properties file exists
if [ ! -f "$branch_properties" ]; then
  echo "Error: branch.properties not found in the work_folder."
  exit 1
fi

# Read the current branch name from branch.properties
current_branch=$(grep '^current_branch=' "$branch_properties" | cut -d'=' -f2)

# Function to push the current branch to its corresponding remote branch in a project
push_current() {
  local project="$1"
  
  # Check if the project folder exists within the clone_folder
  project_folder="$clone_folder/$project"
  if [ ! -d "$project_folder" ]; then
    echo "Project folder not found for '$project' in '$clone_folder'. Skipping."
  else
    # Navigate to the project folder
    cd "$project_folder" || exit 1

    # Check if the current branch exists
    if git rev-parse --verify "$current_branch" >/dev/null 2>&1; then
      # Push the current branch to the corresponding remote branch
      git push origin "$current_branch"
      echo "Pushed '$current_branch' to the remote in project '$project'."
    else
      echo "Current branch does not exist in project '$project'. Skipping."
    fi

    # Return to the clone_folder
    cd "$clone_folder" || exit 1
  fi
}

# Iterate through all projects in both project_unchanged.properties and project_changed.properties
while read -r project || [ -n "$project" ]; do
  push_current "$project"
done < <(sort -u "$project_unchanged_properties" "$project_changed_properties")
