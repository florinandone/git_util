#!/bin/bash

# Define default work_folder and clone_folder
work_folder="$(pwd)"  # Set work_folder to the current working directory
clone_folder="$work_folder/clone"  # Define the clone sub-folder

# Define the properties file path within work_folder
properties_file="$work_folder/build.properties"

# Check if the properties file exists
if [ -f "$properties_file" ]; then
  # Read the properties from the file using grep and cut
  build_from=$(grep '^build_from=' "$properties_file" | cut -d'=' -f2)
  build_targets=$(grep '^build_targets=' "$properties_file" | cut -d'=' -f2)

  # Check if build_from and build_targets are defined
  if [ -z "$build_from" ] || [ -z "$build_targets" ]; then
    echo "Error: The properties build_from and build_targets must be defined in $properties_file."
    exit 1
  fi

  # Change to the project directory (build_from) within clone_folder
  cd "$clone_folder/$build_from" || exit 1

  pwd
  ls
  # Build the project using Gradle with the specified targets
  ./gradlew $build_targets
else
  echo "Error: The properties file $properties_file does not exist in $work_folder."
  exit 1
fi
