#!/bin/bash

# Define default work_folder and clone_folder
work_folder="$(pwd)"  # Set work_folder to the current working directory
clone_folder="$work_folder/clone"  # Define the clone sub-folder

# Define properties files within work_folder
branch_properties="$work_folder/branch.properties"
project_list_properties="$work_folder/project_list.properties"  # Use project_list.properties

# Check if the branch_properties file exists
if [ ! -f "$branch_properties" ]; then
  echo "Error: branch.properties not found in the work_folder."
  exit 1
fi

project_unchanged_properties="$work_folder/project_unchanged.properties"
project_changed_properties="$work_folder/project_changed.properties"


# Check if the project_list_properties file exists
if [ ! -f "$project_unchanged_properties" ]; then
  echo "Error: project_unchanged.properties not found in the work_folder."
  exit 1
fi

# Check if the project_list_properties file exists
if [ ! -f "$project_changed_properties" ]; then
  echo "Error: project_changed.properties not found in the work_folder."
  exit 1
fi


# Read the current branch name from branch.properties
current_branch=$(grep '^current_branch=' "$branch_properties" | cut -d'=' -f2)

# Define the suffix for squash branches
squash_suffix="_squash"

# Iterate through project names in project_list.properties and perform merge squash for each project
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

  # Check if the squash branch already exists in the project
  if git rev-parse --verify "$squash_branch" >/dev/null 2>&1; then
    echo "Squash branch '$squash_branch' already exists in project '$project'. Skipping."
    continue
  fi

  # Create a new branch from the current branch and check it out
  git checkout -b "$squash_branch" "$current_branch"

  # Push the new branch to the remote repository
  git push origin "$squash_branch"

  # Perform a squash merge from the current branch into the new branch
  git merge --squash "$current_branch"

  # Commit the squash merge
  git commit -m "Merge branch '$current_branch' into '$squash_branch' (squash)"

  echo "Created and pushed branch '$squash_branch' with a squash merge from '$current_branch' in project '$project'"

  # Return to the clone_folder
  cd "$clone_folder" || exit 1
done < <(sort -u "$project_unchanged_properties" "$project_changed_properties")
