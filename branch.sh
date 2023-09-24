#!/bin/bash

# Define default work_folder
work_folder="$(pwd)"  # Set work_folder to the current working directory

# Define properties files within work_folder
project_list_properties="$work_folder/project_list.properties"
branch_properties="$work_folder/branch.properties"  # New combined properties file

# Check if the project_list_properties file exists
if [ ! -f "$project_list_properties" ]; then
  echo "Error: project_list.properties not found in the work_folder."
  exit 1
fi

# Check if the branch_properties file exists
if [ ! -f "$branch_properties" ]; then
  echo "Error: branch.properties not found in the work_folder."
  exit 1
fi

# Read the base branch name from branch_properties
base_branch=$(grep '^base_branch=' "$branch_properties" | cut -d'=' -f2)

# Read the branch name from branch_properties
branch_name=$(grep '^current_branch=' "$branch_properties" | cut -d'=' -f2)

# Read the project names from project_list.properties
while read -r project; do
  # Navigate to the project folder within work_folder
  cd "$work_folder/$project" || exit 1

  # Ensure we're on the specified base branch
  git checkout "$base_branch"

  # Create a new branch with the branch name
  git checkout -b "$branch_name"

  # Return to the script's folder (work_folder)
  cd - || exit 1

  echo "Created branch '$branch_name' for project '$project'"
done < "$project_list_properties"
