#!/bin/bash

# Define default work_folder and clone_folder
work_folder="$(pwd)"  # Set work_folder to the current working directory
clone_folder="$work_folder/clone"  # Define the clone sub-folder

# Define properties files within work_folder
branch_properties="$work_folder/branch.properties"

# Check if the branch_properties file exists
if [ ! -f "$branch_properties" ]; then
  echo "Error: branch.properties not found in the work_folder."
  exit 1
fi

project_changed_properties="$work_folder/project_changed.properties"


# Check if the project_list_properties file exists
if [ ! -f "$project_changed_properties" ]; then
  echo "Error: project_changed.properties not found in the work_folder."
  exit 1
fi

# Read the current branch name from branch.properties
current_branch=$(grep '^current_branch=' "$branch_properties" | cut -d'=' -f2)

# Define the suffix for squash branches
squash_suffix="_squash"

# Iterate through project names in project_list.properties and delete the squash branches
while read -r project; do
  # Check if the project folder exists within the clone_folder
  project_folder="$clone_folder/$project"
  if [ ! -d "$project_folder" ]; then
    echo "Warning: Project folder not found for '$project' in '$clone_folder'. Skipping."
    continue
  fi

  # Navigate to the project folder
  cd "$project_folder" || exit 1

  # Define the name of the squash branch
  squash_branch="${current_branch}${squash_suffix}"

  # check out squash branch so can delete it
  git checkout "$squash_branch"

  # Check out the current branch before deleting the squash branch
  git checkout "$current_branch"

  # Delete the squash branch if it exists (both locally and remotely)
  if git rev-parse --verify "$squash_branch" >/dev/null 2>&1; then
    # Delete the local branch
    git branch -d "$squash_branch"
    
    # Delete the remote branch
    git push origin --delete "$squash_branch"

    echo "Deleted branch '$squash_branch' in project '$project' (local and remote)"
  else
    echo "Branch '$squash_branch' not found in project '$project'"
  fi

  # Return to the clone_folder
  cd "$clone_folder" || exit 1
done < <(sort -u "$project_changed_properties")
