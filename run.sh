#!/bin/bash

packages=("ansible" "python3-rpm" "git" "tar" "python3-dnf")

check_installed() {
    rpm -q "$1" >/dev/null 2>&1
}

echo "======================================="
echo "Checking and Installing Missing Packages"
echo "======================================="
for pkg in "${packages[@]}"; do
    if check_installed "$pkg"; then
        echo "[✔] $pkg is already installed."
    else
        echo "[✘] $pkg is not installed. Installing..."
        if sudo dnf install -y "$pkg" >/dev/null 2>&1; then
            echo "[✔] Successfully installed $pkg."
        else
            echo "[✘] Failed to install $pkg."
            exit 1
        fi
    fi
done

echo -e "\n======================================="
echo "Installing Required Ansible Collections"
echo "======================================="
collections=(
    "git+https://github.com/Giftpilz0/ansible-collection-general.git"
    "git+https://github.com/Giftpilz0/ansible-collection-desktop.git"
    "git+https://github.com/Giftpilz0/ansible-collection-server.git"
)

for collection in "${collections[@]}"; do
    echo "Installing collection: $collection..."
    if ansible-galaxy collection install "$collection" >/dev/null 2>&1; then
        echo "[✔] Successfully installed $collection."
    else
        echo "[✘] Failed to install $collection. Please check the repository URL."
        exit 1
    fi
done

echo -e "\n======================================="
echo "Choose Connection Type for Playbook Execution"
echo "======================================="
echo "1. Local connection (connection: local)"
echo "2. Default connection (SSH)"
read -p "Enter your choice (1 or 2): " choice

if [ "$choice" -eq 1 ]; then
    CONNECTION_TYPE="--connection=local"
    INVENTORY="inventory/local_workstation"
    echo "[✔] Using local connection."
elif [ "$choice" -eq 2 ]; then
    CONNECTION_TYPE=""
    INVENTORY="inventory/hosts"
    echo "[✔] Using default SSH connection."
else
    echo "[✘] Invalid choice. Exiting."
    exit 1
fi

echo -e "\n======================================="
echo "Set ansible_user"
echo "======================================="
read -p "Enter the username for Ansible connection: " ansible_user

PLAYBOOK="play.yml"

echo -e "\n======================================="
echo "Executing Ansible Playbook: $PLAYBOOK"
echo "======================================="
if ansible-playbook $CONNECTION_TYPE -i "$INVENTORY" "$PLAYBOOK" --extra-vars "ansible_user=$ansible_user"; then
    echo -e "\n[✔] Playbook executed successfully."
else
    echo -e "\n[✘] Playbook execution failed. Please check the playbook and logs for details."
    exit 1
fi

echo -e "\n======================================="
echo "Script Execution Completed Successfully"
echo "======================================="
