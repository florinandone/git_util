#!/bin/bash

# Define default work_folder
work_folder="$(pwd)"  # Set work_folder to the current working directory

# Define properties files within work_folder
branch_properties="$work_folder/branch.properties"
git_url_properties="$work_folder/git.properties"  # Define the default git_url properties file

# Check if the branch_properties file exists
if [ ! -f "$branch_properties" ]; then
  echo "Error: branch.properties not found in the work_folder."
  exit 1
fi

# Check if the git_url_properties file exists
if [ ! -f "$git_url_properties" ]; then
  echo "Error: git.properties not found in the work_folder."
  exit 1
fi

# Read the current branch name from branch.properties
current_branch=$(grep '^current_branch=' "$branch_properties" | cut -d'=' -f2)

# Read the git_url from git.properties
git_url=$(grep '^git_url=' "$git_url_properties" | cut -d'=' -f2)

# Create a new branch name by appending "_squash" to the current branch
squash_branch="${current_branch}_squash"

# Navigate to the project folder within work_folder (assumed to be the root of the repository)
cd "$work_folder" || exit 1

# Delete the squash branch if it already exists
if git rev-parse --verify "$squash_branch" >/dev/null 2>&1; then
  git branch -d "$squash_branch"
  echo "Deleted existing branch '$squash_branch'"
fi

# Create a new branch from the current branch and check it out
git checkout -b "$squash_branch" "$current_branch"

# Push the new branch to the remote repository
git push origin "$squash_branch"

# Perform a squash merge from the current branch into the new branch
git merge --squash "$current_branch"

# Commit the squash merge
git commit -m "Merge branch '$current_branch' into '$squash_branch' (squash)"

echo "Created and pushed branch '$squash_branch' with a squash merge from '$current_branch'"
