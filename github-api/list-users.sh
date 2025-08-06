#!/bin/bash

<< task
About: The script is about collaborators means who are the users in a specific github organization
Input:1. first you have to export your username
      2. you should have to export your token name
      3. Give required arguments to execute the script
Owner:bharathkumar07-creator
Date: Thu 7th Aug, 2025
task

#This function is added new to help the developers to know how many arguments should be passed to execute the script

function helper {
    expected_cmd_line_arguments=2
    if [ $# -ne $expected_cmd_line_arguments ]; then
        echo "invalid number of arguments"
        echo "enter <nameOfTheScript <REPO_OWNER> <REPO_NAME>"
        exit 1
    fi
}

helper "$@" # Or you can also write "$#" -> "$@" means execute all positional arguments and "$#" means no. of arguments passed in the script
# GitHub API URL
API_URL="https://api.github.com"

# GitHub username and personal access token
USERNAME=$username
TOKEN=$token

# User and Repository information
REPO_OWNER=$1
REPO_NAME=$2

# Function to make a GET request to the GitHub API
function github_api_get {
    local endpoint="$1"
    local url="${API_URL}/${endpoint}"

    # Send a GET request to the GitHub API with authentication
    curl -s -u "${USERNAME}:${TOKEN}" "$url"
}

# Function to list users with read access to the repository
function list_users_with_read_access {
    local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"

    # Fetch the list of collaborators on the repository
    collaborators="$(github_api_get "$endpoint" | jq -r '.[] | select(.permissions.pull == true) | .login')"

    # Display the list of collaborators with read access
    if [[ -z "$collaborators" ]]; then
        echo "No users with read access found for ${REPO_OWNER}/${REPO_NAME}."
    else
        echo "Users with read access to ${REPO_OWNER}/${REPO_NAME}:"
        echo "$collaborators"
    fi
}

# Main script

echo "Listing users with read access to ${REPO_OWNER}/${REPO_NAME}..."
list_users_with_read_access
