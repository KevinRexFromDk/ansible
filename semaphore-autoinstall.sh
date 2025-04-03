#!/bin/bash

# Function to handle errors
handle_error() {
    echo -e "\e[31mError: $1\e[0m"  # Print error in red
    exit 1  # Exit the script with an error status
}

# Ask the user for the Semaphore admin account (true/false)
while true; do
    read -p "Create a semaphore admin account? (true/false, default 'true'): " semAdmin
    semAdmin=${semAdmin:-true}  # Default to 'true' if nothing is entered
    
    if [[ "$semAdmin" == "true" || "$semAdmin" == "false" ]]; then
        echo -e "\e[34mSemaphore admin: $semAdmin\e[0m"
        break
    else
        echo -e "\e[31mInvalid input. Please enter 'true' or 'false'.\e[0m"
    fi
done

# Ask for the Semaphore user name (default to 'semaphore_user')
read -p "Enter the Semaphore user's name (default 'semaphore'): " semName
semName=${semName:-semaphore}
echo -e "\e[34mSemaphore User Name: $semName\e[0m"

# Ask for the Semaphore login (default to 'semaphore_login')
read -p "Enter the Semaphore user's login (default 'semaphore'): " semLogin
semLogin=${semLogin:-semaphore}
echo -e "\e[34mSemaphore User Login: $semLogin\e[0m"

# Ask for the Semaphore user's email (required)
while true; do
    read -p "Enter the Semaphore user's email (required): " semEmail
    # Validate email format with regex
    if [[ "$semEmail" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$ ]]; then
        echo -e "\e[34mSemaphore User Email: $semEmail\e[0m"
        break
    else
        echo -e "\e[31mInvalid email format. Please enter a valid email address (e.g., user@something.com).\e[0m"
    fi
done

# Ask for the Semaphore user's password (default to 'Password123')
read -sp "Enter the Semaphore user's password (default 'Passw0rd'): " semPassword
semPassword=${semPassword:-Passw0rd}
echo -e "\e[34mSemaphore User Password: $semPassword\e[0m"  # Don't show password for security

# Confirm input (just to show the collected information before proceeding)
echo -e "\e[32m--- Summary ---\e[0m"
echo -e "Admin Account: $semAdmin"
echo -e "User Name: $semName"
echo -e "Login: $semLogin"
echo -e "Email: $semEmail"
echo -e "Password: [hidden]"

# Ask the user to confirm
while true; do
    read -p "Is this information correct? (y/n): " confirm
    case $confirm in
        [Yy]* ) 
            break
            ;;
        [Nn]* ) 
            echo -e "\e[31mExiting script. Please rerun to provide correct information.\e[0m"
            exit 1
            ;;
        * ) 
            echo -e "\e[31mPlease answer yes or no.\e[0m"
            ;;
    esac
done

# Now you can use the gathered data in your command to create the Semaphore user.
# For example:
semaphore_command="sudo semaphore user add --admin $semAdmin --name $semName --login $semLogin --email $semEmail --password $semPassword"

# Execute the command
echo -e "\e[34mRunning Semaphore user creation command...\e[0m"
$semaphore_command || handle_error "Failed to create Semaphore user."

echo -e "\e[32mSemaphore user created successfully!\e[0m"
