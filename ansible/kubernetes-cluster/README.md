# Kubernetes Cluster Deployment with Ansible

## Overview

This project automates the deployment of a Kubernetes cluster with one master node and two worker nodes using Ansible. The setup ensures that the cluster is configured correctly with essential components and ready for workload deployment.

## Architecture

- **1 Master Node**: Controls the cluster, schedules workloads, and manages API requests.
- **2 Worker Nodes**: Execute workloads (Pods and Containers) and communicate with the master node.
- **Ansible**: Automates the provisioning and configuration of all nodes.

## Prerequisites

Before running the Ansible playbook, ensure the following requirements are met:

### Control Node (your machine running Ansible)
- Ansible installed (`ansible --version` to check)
- SSH access to all nodes (passwordless authentication recommended)
- Inventory file listing all nodes

### Target Nodes (Master & Workers)
- Ubuntu 22.04
- SSH enabled
- Python installed

## Setup & Installation

### 1. Clone the Repository

```bash
git clone https://github.com/hungles/devops.git
cd ansible/kubernetes-cluster
```
## 2. Update Inventory File

Modify `inventory.yml` with the IP addresses of your nodes:

```yml
k8-masters:
  hosts:
    k8-master-01:
      ansible_host: "master-ip"

k8-workers:
  hosts:
    k8-worker-01:
      ansible_host: "worker-01-ip"
    k8-worker-02:
      ansible_host: "worker-02-ip"

k8-cluster:
  children:
    k8-masters:
    k8-workers:
```

## 3. Edit the hosts_vars.yml File

Modify `roles/vars/hosts_vars.yml` with the ip and hostname from your servers

```yml
my_hosts:
  - ip: "master-ip"
    hostname: "worker-01-hostname"
  - ip: "worker-01-hostname"
    hostname: "worker-01-hostname"
  - ip: "worker-02-ip"
    hostname: "worker-02-hostname"
```

## 4. Run the Ansible Playbook

Execute the playbook to set up the cluster:

```bash
ansible-playbook -i inventory/development/inventory.yml playbooks/preconfig_kubernetes_servers -K
```
# Features

- **Automated installation of Kubernetes components**: Installs `kubeadm`, `kubelet`, and `kubectl` seamlessly.
- **Secure SSH-based deployment**: Ensures secure communication between nodes using SSH.
- **Configurable inventory for scaling**: Easily scale your cluster by updating the inventory file.
- **Automatic worker node joining to the cluster**: Simplifies the process of adding worker nodes to the cluster.

# Future Improvements

- **Add support for HA (High Availability)**: Implement a highly available control plane for production environments.
- **Deploy a CNI (Container Network Interface) plugin**: Integrate plugins like Calico or Flannel for networking.
- **Automate Helm installation**: Simplify application deployment using Helm.
- **Implement monitoring with Prometheus and Grafana**: Set up monitoring and visualization for cluster metrics.

# License

This project is licensed under the **MIT License**. See the [LICENSE](LICENSE) file for details.

# Author

**[Sebastian Carmona]** - Kubernetes & Ansible Enthusiast  
[GitHub Profile](https://github.com/hungles) | [Email](scarmona04@hotmail.com)