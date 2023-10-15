#!/bin/bash

# Define default paths and sub-folder
work_folder="$(pwd)"        # Set work_folder to the current working directory
clone_folder="$work_folder/clone"  # Define the clone sub-folder

# Define the clone folder path
clone_folder="$work_folder/clone"

# Check if the clone folder exists
if [ -d "$clone_folder" ]; then
  echo "Removing existing clone folder..."
  rm -rf "$clone_folder"
fi


rm -rf "$clone_folder"

