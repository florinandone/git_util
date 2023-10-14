#!/bin/bash

# Define default work_folder and clone_folder
work_folder="${1:-$(pwd)}"  # Use the provided folder or set work_folder to the current working directory
clone_folder="$work_folder/clone"  # Define the clone sub-folder

# Define properties files within work_folder
project_unchanged_properties="$work_folder/project_unchanged.properties"
project_changed_properties="$work_folder/project_changed.properties"

# Function to fetch the latest changes from the remote repository in a project
fetch_project() {
  local project="$1"
  
  # Check if the project folder exists within the clone_folder
  project_folder="$clone_folder/$project"
  if [ ! -d "$project_folder" ]; then
    echo "Project folder not found for '$project' in '$clone_folder'. Skipping."
  else
    # Navigate to the project folder
    cd "$project_folder" || exit 1

    # Fetch the latest changes from the remote repository
    git fetch
    echo "Fetched the latest changes for project '$project'."

    # Return to the clone_folder
    cd "$clone_folder" || exit 1
  fi
}

# Iterate through all projects in both project_unchanged.properties and project_changed.properties
while read -r project || [ -n "$project" ]; do
  fetch_project "$project"
done < <(sort -u "$project_unchanged_properties" "$project_changed_properties")
