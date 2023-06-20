#!/usr/bin/env bash

set -e

export PATH=$PATH:/usr/local/bin

# Define the command to run
COMMAND="kubescape scan --output human > _temp.txt"

FRAMEWORK_ARG="$1"

extract_summary() {
  local output_file="\$1"
  local failed_controls=$(grep -o 'Failed: [0-9]*' "$output_file" | grep -o '[0-9]*')
  local passed_controls=$(grep -o 'Passed: [0-9]*' "$output_file" | grep -o '[0-9]*')
  local action_required=$(grep -o 'Action Required: [0-9]*' "$output_file" | grep -o '[0-9]*')

  echo "Controls: (Failed: $failed_controls, Passed: $passed_controls, Action Required: $action_required)"
}

classify_severity() {
  local output_file="\$1"
  local critical=$(grep -o 'Critical — [0-9]*' "$output_file" | grep -o '[0-9]*')
  local high=$(grep -o 'High — [0-9]*' "$output_file" | grep -o '[0-9]*')
  local medium=$(grep -o 'Medium — [0-9]*' "$output_file" | grep -o '[0-9]*')
  local low=$(grep -o 'Low — [0-9]*' "$output_file" | grep -o '[0-9]*')

  echo "Failed Resources by Severity: Critical — $critical, High — $high, Medium — $medium, Low — $low"
}

print_table() {
  local output_file="\$1"
  local start_line=$(grep -n '^\+' "$output_file" | head -n 1 | cut -d ':' -f 1)
  local end_line=$(grep -n '^\+' "$output_file" | tail -n 1 | cut -d ':' -f 1)

  # Print the table from the start_line to the end_line
  sed -n "${start_line},${end_line}p" "$output_file"
}

if [[ $(find . -type f \( -name "*.yml" -o -name "*.yaml" \) -not -name ".pre-commit-config.yaml") ]]; then
  # If files are found, execute the command here
  if [ -z "$FRAMEWORK_ARG" ]; then
    # Execute the command without the additional argument
    $COMMAND .
  else
    # Execute the command with the additional argument
    $COMMAND framework "$FRAMEWORK_ARG" .
  fi

  # Call the functions to extract summary and classify severity
  extract_summary "_temp.txt"
  classify_severity "_temp.txt"
  print_table "_temp.txt"

else
  # If no files are found, do nothing
  echo "No files found."
fi
