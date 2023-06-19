#!/usr/bin/env bash

set -e

export PATH=$PATH:/usr/local/bin

# Define the command to run
COMMAND="kubescape scan"

FRAMEWORK_ARG="$1"

if [[ $(find . -type f \( -name "*.yml" -o -name "*.yaml" \) -not -name ".pre-commit-config.yaml") ]]; then
  # If files are found, execute the command here
  if [ -z "$FRAMEWORK_ARG" ]; then
    # Execute the command without the additional argument
    $COMMAND .
  else
    # Execute the command with the additional argument
    $COMMAND framework "$FRAMEWORK_ARG" .
  fi
else
  # If no files are found, do nothing
  echo "No files found."
fi
