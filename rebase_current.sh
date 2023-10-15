#!/bin/bash

# Define default work_folder and clone_folder
work_folder="$(pwd)"  # Set work_folder to the current working directory
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

# Read the current and base branch names from branch.properties
current_branch=$(grep '^current_branch=' "$branch_properties" | cut -d'=' -f2)
base_branch=$(grep '^base_branch=' "$branch_properties" | cut -d'=' -f2)

# Function to rebase the current branch from the base branch in a project
rebase_current() {
  local project="$1"
  
  # Check if the project folder exists within the clone_folder
  project_folder="$clone_folder/$project"
  if [ ! -d "$project_folder" ]; then
    echo "Project folder not found for '$project' in '$clone_folder'. Skipping."
  else
    # Navigate to the project folder
    cd "$project_folder" || exit 1

    # Check if the current branch and base branch exist
    if git rev-parse --verify "$current_branch" >/dev/null 2>&1 && git rev-parse --verify "$base_branch" >/dev/null 2>&1; then
      echo "Rebasing '$current_branch' from '$base_branch' in project '$project'..."
      git checkout "$current_branch"
      git pull origin "$current_branch"
      git rebase "$base_branch"
    else
      echo "Current or base branch does not exist in project '$project'. Skipping."
    fi

    # Return to the clone_folder
    cd "$clone_folder" || exit 1
  fi
}

# Iterate through all projects in both project_unchanged.properties and project_changed.properties
while read -r project || [ -n "$project" ]; do
  rebase_current "$project"
done < <(sort -u "$project_unchanged_properties" "$project_changed_properties")
