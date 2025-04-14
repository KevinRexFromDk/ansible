#!/bin/bash

# error handling
handle_error() {
    echo -e "\e[31mError: $1\e[0m"
    exit 1 
}

echo -e "\e[34mUpdating and upgrading the system...\e[0m"
sudo apt-get update -y && sudo apt-get upgrade -y || handle_error "System update/upgrade failed."

echo -e "\e[34mChecking if snap is installed...\e[0m"
if command -v snap &> /dev/null; then
    echo -e "\e[32mSnap is installed\e[0m"
else
    echo -e "\e[33mSnap is not installed.\e[0m"
    while true; do
        read -p "Do you want to install snapd? [Y/n]: " yn
        yn=${yn:-Y}
        case $yn in
            [Yy]* )
                sudo apt install snapd -y || handle_error "Failed to install snapd"
                echo -e "\e[32mSnap installed successfully!\e[0m"
                break
                ;;
            [Nn]* )
                echo -e "\e[31mSnap will not be installed. Exiting...\e[0m"
                exit 1
                ;;
            * ) echo "Please answer yes or no.";;
        esac
    done
fi

echo -e "\e[34mChecking if Semaphore is installed...\e[0m"
if command -v semaphore &> /dev/null; then
    echo -e "\e[32mSemaphore is installed\e[0m"
else
    echo -e "\e[33mSemaphore is not installed.\e[0m"
    while true; do
        read -p "Do you want to install Semaphore? [Y/n]: " yn
        yn=${yn:-Y} 
        case $yn in
            [Yy]* )
                echo -e "\e[34mInstalling Semaphore...\e[0m"
                sudo snap install semaphore || handle_error "Failed to install Semaphore"
                echo -e "\e[32mSemaphore installed successfully!\e[0m"
                break
                ;;
            [Nn]* )
                echo -e "\e[31mSemaphore will not be installed. Exiting...\e[0m"
                exit 1
                ;;
            * ) echo "Please answer yes or no.";;
        esac
    done
fi

if command -v semaphore &> /dev/null; then
    sudo snap stop semaphore || handle_error "Failed to stop semaphore for user creation"
fi

while true; do
    read -p "Create a semaphore admin account? [Y/n] (default 'true'): " semAdmin
    semAdmin=${semAdmin:-true}
    
    if [[ "$semAdmin" == "true" || "$semAdmin" == "false" ]]; then
        echo -e "\e[32mSemaphore admin: $semAdmin\e[0m"
        break
    else
        echo -e "\e[31mInvalid input. Please enter 'true' or 'false'.\e[0m"
    fi
done

read -p "Enter the Semaphore user's name [Y/n] (default 'semaphore'): " semName
semName=${semName:-semaphore}
echo -e "\e[32mSemaphore User Name: $semName\e[0m"

read -p "Enter the Semaphore user's login [Y/n] (default 'semaphore'): " semLogin
semLogin=${semLogin:-semaphore}
echo -e "\e[32mSemaphore User Login: $semLogin\e[0m"

while true; do
    read -p "Enter the Semaphore user's email [Y/n] (required): " semEmail
    if [[ "$semEmail" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$ ]]; then
        echo -e "\e[32mSemaphore User Email: $semEmail\e[0m"
        break
    else
        echo -e "\e[31mInvalid email format. Please enter a valid email address (e.g., user@something.com).\e[0m"
    fi
done

read -sp "Enter the Semaphore user's password [Y/n] (default 'Passw0rd'): " semPassword
semPassword=${semPassword:-Passw0rd}
echo -e "\e[32mSemaphore User Password: $semPassword\e[0m"

echo -e "\e[32m--- Summary ---\e[0m"
echo -e "Admin Account: $semAdmin"
echo -e "User Name: $semName"
echo -e "Login: $semLogin"
echo -e "Email: $semEmail"
echo -e "Password: $semPassword"

while true; do
    read -p "Is this information correct? [Y/n]: " confirm
    confirm=${confirm:-Y}
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

semaphore_command="sudo semaphore user add --admin $semAdmin --name $semName --login $semLogin --email $semEmail --password $semPassword"

echo -e "\e[34mRunning Semaphore user creation command...\e[0m"
$semaphore_command || handle_error "Failed to create Semaphore user."

echo -e "\e[32mSemaphore user created successfully!\e[0m"

# Check and stop semaphore
if command -v semaphore &> /dev/null; then
    sudo snap start semaphore || handle_error "Failed to start semaphore"
fi
