#!/bin/bash

# Check if the required parameters are provided
if [ $# -ne 3 ]; then
  echo "Usage: $0 folder git.properties project_list.properties"
  exit 1
fi

folder="$1"
git_properties="$2"
project_list_properties="$3"

# Read the git_url from git.properties
git_url=$(grep '^git_url=' "$folder/$git_properties" | cut -d'=' -f2)

echo $git_url

# Read the project names from project_list.properties
while read -r project; do
  # Clone the project using the git_url
  git clone "$git_url$project.git" "$folder/$project"
done < "$folder/$project_list_properties"

