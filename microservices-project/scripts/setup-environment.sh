#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to print status
print_status() {
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓${NC} $1"
    else
        echo -e "${RED}✗${NC} $1"
    fi
}

# Function to check system resources
check_resources() {
    echo -e "\n${YELLOW}Checking System Resources:${NC}"

    # Check CPU
    CPU_CORES=$(nproc)
    echo -e "CPU Cores: $CPU_CORES"
    if [ $CPU_CORES -lt 2 ]; then
        echo -e "${RED}Warning: Minimum 2 CPU cores recommended for Kubernetes${NC}"
    fi

    # Check Memory
    TOTAL_MEM=$(free -m | awk '/^Mem:/{print $2}')
    echo -e "Total Memory: ${TOTAL_MEM}MB"
    if [ $TOTAL_MEM -lt 4096 ]; then
        echo -e "${RED}Warning: Minimum 4GB RAM recommended for Kubernetes${NC}"
    fi

    # Check Disk Space
    DISK_SPACE=$(df -h / | awk 'NR==2 {print $4}')
    echo -e "Available Disk Space: $DISK_SPACE"
}

# Function to install Docker
install_docker() {
    echo -e "\n${YELLOW}Installing Docker:${NC}"

    if command_exists docker; then
        echo -e "${GREEN}Docker is already installed${NC}"
        docker --version
    else
        echo "Installing Docker..."
        sudo apt-get update
        sudo apt-get install -y docker.io
        sudo systemctl start docker
        sudo systemctl enable docker
        sudo usermod -aG docker $USER
        print_status "Docker installation"
    fi
}

# Function to install Minikube
install_minikube() {
    echo -e "\n${YELLOW}Installing Minikube:${NC}"

    if command_exists minikube; then
        echo -e "${GREEN}Minikube is already installed${NC}"
        minikube version
    else
        echo "Installing Minikube..."
        curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
        sudo install minikube-linux-amd64 /usr/local/bin/minikube
        rm minikube-linux-amd64
        print_status "Minikube installation"
    fi
}

# Function to install kubectl
install_kubectl() {
    echo -e "\n${YELLOW}Installing kubectl:${NC}"

    if command_exists kubectl; then
        echo -e "${GREEN}kubectl is already installed${NC}"
        kubectl version --client
    else
        echo "Installing kubectl..."
        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
        sudo install kubectl /usr/local/bin/kubectl
        rm kubectl
        print_status "kubectl installation"
    fi
}

# Function to install Helm
install_helm() {
    echo -e "\n${YELLOW}Installing Helm:${NC}"

    if command_exists helm; then
        echo -e "${GREEN}Helm is already installed${NC}"
        helm version
    else
        echo "Installing Helm..."
        curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
        print_status "Helm installation"
    fi
}

# Main setup function
main() {
    echo -e "${YELLOW}Starting Development Environment Setup${NC}"

    # Check if running on Ubuntu
    if ! grep -q Ubuntu /etc/os-release; then
        echo -e "${RED}This script is designed for Ubuntu. Please modify for your OS.${NC}"
        exit 1
    fi

    # Check system resources
    check_resources

    # Install required packages
    echo -e "\n${YELLOW}Installing required packages...${NC}"
    sudo apt-get update
    sudo apt-get install -y curl apt-transport-https ca-certificates software-properties-common

    # Install main components
    install_docker
    install_minikube
    install_kubectl
    install_helm

    # Verify installations
    echo -e "\n${YELLOW}Verifying installations:${NC}"
    docker --version && print_status "Docker"
    minikube version && print_status "Minikube"
    kubectl version --client && print_status "kubectl"
    helm version && print_status "Helm"

    echo -e "\n${YELLOW}Setting up Minikube...${NC}"
    minikube config set driver docker
    minikube start --memory=4096 --cpus=2

    echo -e "\n${GREEN}Setup complete!${NC}"
    echo -e "\nNext steps:"
    echo -e "1. Run 'minikube status' to verify cluster status"
    echo -e "2. Run 'kubectl get nodes' to verify node availability"
    echo -e "3. Run 'minikube dashboard' to access the Kubernetes dashboard"

    # Reminder about docker group
    echo -e "\n${YELLOW}Note: You may need to log out and back in for docker group changes to take effect${NC}"
}

# Run main function
main
