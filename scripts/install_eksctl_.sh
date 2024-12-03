#!/bin/bash

# Variables
ARCH=amd64
PLATFORM=$(uname -s)_$ARCH
EKSCTL_PATH=/home/cloudshell-user

# Download and extract eksctl
curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"
if [ $? -ne 0 ]; then
    echo "Download failed."
    exit 1
fi

tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz
if [ $? -ne 0 ]; then
    echo "Extraction failed."
    exit 1
fi

# Move eksctl to the user's home directory
mkdir $EKSCTL_PATH/bin
sudo mv /tmp/eksctl $EKSCTL_PATH/bin/eksctl
if [ $? -ne 0 ]; then
    echo "Move failed."
    exit 1
fi

# Add eksctl to PATH in .bashrc if not already present
export PATH=$EKSCTL_PATH:$PATH

# Test eksctl installation
eksctl version
if [ $? -eq 0 ]; then
    echo "eksctl installed successfully."
else
    echo "eksctl installation failed."
fi

# Define Helm installation directory
HELM_INSTALL_DIR="/usr/local/bin"

# Check for OpenSSL and install if not present
if ! command -v openssl &> /dev/null; then
    echo "OpenSSL not found. Installing OpenSSL..."
    sudo yum install -y openssl
fi

# Download and execute the Helm installation script
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Verify installation
if command -v helm &> /dev/null; then
    echo "Helm installation was successful."
    helm version
else
    echo "Helm installation failed."
    exit 1
fi