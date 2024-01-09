#!/bin/bash

# This script loops over all folders and subfolders in root_directory and checks if 
# any file contains "services_list" list.  When it finds that list it checks if 
# specific item exists there (here - "policyanalyzer.googleapis.com"), if it exists - skips, 
# if it doesn't exist - adds to the end of the list


# Directory to start the search from
root_directory=""
# Function to update services_list in a file
update_services_list() {
    local file=$1
    local service="policyanalyzer.googleapis.com"
    # Check if the service is already in the list
    if grep -q "$service" "$file"; then
        echo "Service already exists in $file"
    else
        # Append the service to the services_list
        awk -v service="$service" '
            /services_list *= *\[/ {
                in_brackets = 1
            }
            in_brackets {
                if (/]/) {
                    sub(/]$/, ", \"" service "\"]")
                    in_brackets = 0
                }
            }
            { print }
        ' "$file" > tmpfile && mv tmpfile "$file"
        echo "Service added to $file"
    fi
}
# Export the function so it's available to subshells
export -f update_services_list
# Find all project-composite.tf files and update services_list
find "$root_directory" -type f -name "project-composite.tf" -exec bash -c 'update_services_list "$0"' {} \;
echo "Operation completed."
