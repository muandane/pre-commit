#!/usr/bin/env bash

# Define the command to run
COMMAND="kubescape scan . --output human "
COMMAND_DEVOPS="kubescape scan framework DevOpsBest . --output human "
COMMAND_MITRE="kubescape scan framework mitre . --output human "
COMMAND_NSA="kubescape scan framework nsa . --output human "

extract_summary() {
  local output_file="_temp.txt"
  local failed_controls=$(grep -o 'Failed: [0-9]*' "$output_file" | grep -o '[0-9]*')
  local passed_controls=$(grep -o 'Passed: [0-9]*' "$output_file" | grep -o '[0-9]*')
  local action_required=$(grep -o 'Action Required: [0-9]*' "$output_file" | grep -o '[0-9]*')

  echo "Controls: (Failed: $failed_controls, Passed: $passed_controls, Action Required: $action_required)"
}

classify_severity() {
  local output_file="_temp.txt"
  local critical=$(grep -o 'Critical — [0-9]*' "$output_file" | grep -o '[0-9]*')
  local high=$(grep -o 'High — [0-9]*' "$output_file" | grep -o '[0-9]*')
  local medium=$(grep -o 'Medium — [0-9]*' "$output_file" | grep -o '[0-9]*')
  local low=$(grep -o 'Low — [0-9]*' "$output_file" | grep -o '[0-9]*')

  echo "Failed Resources by Severity: Critical — $critical, High — $high, Medium — $medium, Low — $low"
}

print_table() {
  local output_file="_temp.txt"
  local start_line=$(grep -n '^\+' "$output_file" | head -n 1 | cut -d ':' -f 1)
  local end_line=$(grep -n '^\+' "$output_file" | tail -n 1 | cut -d ':' -f 1)

  # Print the table from the start_line to the end_line
  sed -n "${start_line},${end_line}p" "$output_file"
}

if [[ $(find . -type f \( -name "*.yml" -o -name "*.yaml" \) -not -name ".pre-commit-config.yaml") ]]; then
  # If files are found, execute the command here
  eval "kubescape scan . --output human" >_temp.txt
  extract_summary
  classify_severity
  print_table
else
  echo "No files found."
fi
