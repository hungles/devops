#!/bin/bash

# Prompt the user for their local subnet
read -p "Enter your local subnet (example: 192.168.1): " subnet

# Display the IPs that will be used
ip1="${subnet}.160"
ip2="${subnet}.170"
ip3="${subnet}.180"

echo "The following IPs will be used:"
echo "- $ip1"
echo "- $ip2"
echo "- $ip3"

# Ask the user if they want to proceed
read -p "Do you want to continue and update the Vagrant file? (yes/no): " confirmation

# Convert the response to lowercase to avoid case sensitivity issues
confirmation=$(echo "$confirmation" | tr '[:upper:]' '[:lower:]')

# Check the user's response
if [ "$confirmation" != "yes" ]; then
    echo "Operation canceled by the user."
    exit 1
fi

# Path to the Vagrant file (adjust the path as needed)
vagrant_file="Vagrantfile"

# Check if the Vagrant file exists
if [ ! -f "$vagrant_file" ]; then
    echo "Error: The Vagrant file was not found at the specified path."
    exit 1
fi

# Update the IPs in the Vagrant file
# Search and replace only the ip: "current_value" part
sed -i "/master.vm.network \"public_network\"/s/ip: \"[0-9.]*\"/ip: \"$ip1\"/" "$vagrant_file"
sed -i "/worker1.vm.network \"public_network\"/s/ip: \"[0-9.]*\"/ip: \"$ip2\"/" "$vagrant_file"
sed -i "/worker2.vm.network \"public_network\"/s/ip: \"[0-9.]*\"/ip: \"$ip3\"/" "$vagrant_file"

echo "The Vagrant file has been updated with the following IPs:"
echo "- $ip1"
echo "- $ip2"
echo "- $ip3"

# Using the main interface as a bridge
interface=$(ip route show | grep default | cut -d" " -f 5)
read -p "Is $interface your main interface? (yes/no): " interface_confirmation

# Convert the response to lowercase to avoid case sensitivity issues
interface_confirmation=$(echo "$interface_confirmation" | tr '[:upper:]' '[:lower:]')

# Check the user's response
if [ "$interface_confirmation" != "yes" ]; then
    echo "Operation canceled by the user."
    exit 1
fi

sed -i "s/bridge: \"[^\"]*\"/bridge: \"$interface\"/g" $vagrant_file

#Creando cluster
echo "Empezando con la creacion de las virtuales en Virtualbox"

vagrant up

sleep 30

ansible-playbook -i inventory/development/inventory.yml playbooks/preconfig_kubernetes_servers.yml -K
ansible-playbook -i inventory/development/inventory.yml playbooks/configure_nodes.yml -K