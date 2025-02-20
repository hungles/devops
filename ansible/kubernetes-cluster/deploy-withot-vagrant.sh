#!/bin/bash
declare -a IPS
# Check if Vagrant or external IPs will be used
ALL_VPS=0
for ARG in "$@"; do
    if [[ $ARG =~ --ip[0-9]+=.* ]];then
        ((ALL_VPS++))
    fi
done

while [ "$ALL_VPS" -gt 0 ]; do
    # Request the number of master nodes
    read -p "How many master nodes do you want? (Must be 1 or more): " MASTER_NODES

    # Validate input
    if ! [[ "$MASTER_NODES" =~ ^[0-9]+$ ]] || [ "$MASTER_NODES" -lt 1 ]; then
        echo "Error: You must enter a valid number greater than or equal to 1."
        continue
    fi

    # Verify that it doesn't exceed the total available VPS
    if [ "$MASTER_NODES" -gt "$ALL_VPS" ]; then
        echo "Error: You cannot allocate more master nodes than available VPS ($ALL_VPS)."
        continue
    fi

    # Subtract master nodes from the total available VPS
    ALL_VPS=$((ALL_VPS - MASTER_NODES))

    # Request the number of worker nodes
    read -p "How many worker nodes do you want? (You have $ALL_VPS VPS left): " WORKER_NODES

    # Validate input
    if ! [[ "$WORKER_NODES" =~ ^[0-9]+$ ]]; then
        echo "Error: You must enter a valid number."
        ALL_VPS=$((ALL_VPS + MASTER_NODES)) # Restore master nodes to the total
        continue
    fi

    # Verify that it doesn't exceed the total available VPS
    if [ "$WORKER_NODES" -gt "$ALL_VPS" ]; then
        echo "Error: You cannot allocate more worker nodes than available VPS ($ALL_VPS)."
        ALL_VPS=$((ALL_VPS + MASTER_NODES)) # Restore master nodes to the total
        continue
    fi

    # Subtract worker nodes from the total available VPS
    ALL_VPS=$((ALL_VPS - WORKER_NODES))

    echo "You have allocated $MASTER_NODES masters and $WORKER_NODES workers. You have $ALL_VPS VPS left."
done
    
for ARG in "$@"; do
    if [[ $ARG =~ --ip[0-9]+=([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}) ]];then
        IP="${BASH_REMATCH[1]}"
            if [[ $IP =~ ^([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})$ ]]; then
                OCTET1="${BASH_REMATCH[1]}"
                OCTET2="${BASH_REMATCH[2]}"
                OCTET3="${BASH_REMATCH[3]}"
                OCTET4="${BASH_REMATCH[4]}"
            else
                echo "Error parsing"
            fi
            if (( OCTET1 < 255 && OCTET2 < 255 && OCTET3 < 255 && OCTET4 < 255 )); then
                IPS+=("$IP")
            else
                echo "The IP $IP is not valid :-)"
            fi
    else
        echo "The format is not valid"
    fi
    done

# Inventory file name
INVENTORY_FILE="inventory.yml"

# Create the inventory file
HOST_VARS="hosts_vars.yml"
echo "Creating file $INVENTORY_FILE ..."

# Creating the file host_vars.yml
cat << EOL > "roles/common/vars/$HOST_VARS"
my_hosts:
EOL
# Start of inventory.yml file
cat <<EOL > "inventory/development/$INVENTORY_FILE"
---
all:
    children:
        k8-masters:
            hosts:
EOL

# Add masters to the inventory
N_IPS=0
for ((i=1; i<=MASTER_NODES; i++)); do
  echo "                master$i:" >> "inventory/development/$INVENTORY_FILE"
  echo "                    ansible_host: ${IPS[$N_IPS]}" >> "inventory/development/$INVENTORY_FILE"
  echo "    - ip: ${IPS[$N_IPS]}" >> "roles/common/vars/$HOST_VARS"
  echo "      hostname: master$i" >> "roles/common/vars/$HOST_VARS"
  ((N_IPS++))
done

# Add the workers section
cat <<EOL >> "inventory/development/$INVENTORY_FILE"
        k8-workers:
            hosts:
EOL

# Add workers to the inventory
for ((i=1; i<=WORKER_NODES; i++)); do
  echo "                worker$i:" >> "inventory/development/$INVENTORY_FILE"
  echo "                    ansible_host: ${IPS[$N_IPS]}" >> "inventory/development/$INVENTORY_FILE"
  echo "    - ip: ${IPS[$N_IPS]}" >> "roles/common/vars/$HOST_VARS"
  echo "      hostname: worker$i" >> "roles/common/vars/$HOST_VARS"
  ((N_IPS++))  # Increment WORKER_IPS correctly
done


if ! command -v pipx &>/dev/null; then
    echo "pipx is not installed. Installing it first..."
    # Try to install pipx
    if command -v python3 &>/dev/null; then
        python3 -m pip install --user pipx
        python3 -m pipx ensurepath
        # Add pipx to PATH if needed
        export PATH="$PATH:$HOME/.local/bin"
        echo "pipx installed successfully."
    else
        echo "Python3 is not installed. Please install it first to use pipx."
        exit 1
    fi
else
    echo "pipx is already installed."
fi

# Check if Ansible is installed
if ! pipx list | grep -q "ansible"; then
    echo "Ansible is not installed. Installing it with pipx..."
    pipx install ansible
    if [ $? -eq 0 ]; then
        echo "Ansible installed successfully via pipx."
    else
        echo "There was an error installing Ansible. Please check the error message."
        exit 1
    fi
else
    echo "Ansible is already installed."
fi


# ansible-playbook -i inventory.yml playbooks/preconfig_kubernetes_servers.yml -K
# ansible-playbook -i inventory.yml playbooks/configure_nodes.yml -K