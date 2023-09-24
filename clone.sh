#!/bin/bash

# Define default paths and sub-folder
work_folder="$(pwd)"        # Set work_folder to the current working directory
clone_folder="$work_folder/clone"  # Define the clone sub-folder
project_list_properties="$work_folder/project_list.properties"
git_url_properties="$work_folder/git.properties"  # Define the default git_url properties file

# Check if the project_list_properties file exists
if [ ! -f "$project_list_properties" ]; then
  echo "Error: project_list.properties not found in the work_folder."
  exit 1
fi

# Check if the git_url_properties file exists
if [ ! -f "$git_url_properties" ]; then
  echo "Error: git.properties not found in the work_folder."
  exit 1
fi

# Create the clone sub-folder if it doesn't exist
mkdir -p "$clone_folder"

# Read the git_url from git.properties
git_url=$(grep '^git_url=' "$git_url_properties" | cut -d'=' -f2)

# Read the project names from project_list.properties and clone each project
while read -r project; do
  # Clone the project into the clone sub-folder
  git clone "$git_url$project.git" "$clone_folder/$project"
  echo "Cloned project '$project' into '$clone_folder/$project'"
done < "$project_list_properties"
