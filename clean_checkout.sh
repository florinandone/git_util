#!/bin/bash

# Define default work_folder
work_folder="$(pwd)"  # Set work_folder to the current working directory

# Define the clone folder path
clone_folder="$work_folder/clone"

# Check if the clone folder exists
if [ -d "$clone_folder" ]; then
  echo "Removing existing clone folder..."
  rm -rf "$clone_folder"
fi

# Call clone.sh to re-clone the projects
echo "Cloning projects..."
../clone.sh
../checkout.sh
