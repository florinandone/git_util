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

# Function to pull the latest changes from the remote repository in a project
pull_project() {
  local project="$1"
  
  # Check if the project folder exists within the clone_folder
  project_folder="$clone_folder/$project"
  if [ ! -d "$project_folder" ]; then
    echo "Project folder not found for '$project' in '$clone_folder'. Skipping."
  else
    # Navigate to the project folder
    cd "$project_folder" || exit 1

    # Pull the latest changes from the remote repository into the current branch
    git pull origin "$current_branch"
    echo "Pulled the latest changes into current branch '$current_branch' for project '$project'."

    # Return to the clone_folder
    cd "$clone_folder" || exit 1
  fi
}

# Iterate through all projects in both project_unchanged.properties and project_changed.properties
while read -r project || [ -n "$project" ]; do
  pull_project "$project"
done < <(sort -u "$project_unchanged_properties" "$project_changed_properties")
