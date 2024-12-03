#!/bin/bash

# Variables
ARCH=amd64
PLATFORM=$(uname -s)_$ARCH
EKSCTL_PATH=/home/cloudshell-user
BIN_DIR=$EKSCTL_PATH/bin

# Ensure bin directory exists
mkdir -p $BIN_DIR
if [ $? -ne 0 ]; then
    echo "Failed to create directory: $BIN_DIR"
    exit 1
fi

# Download and extract eksctl
echo "Downloading eksctl..."
curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"
if [ $? -ne 0 ]; then
    echo "Download failed."
    exit 1
fi

echo "Extracting eksctl..."
tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz
if [ $? -ne 0 ]; then
    echo "Extraction failed."
    exit 1
fi

echo "Moving eksctl to $BIN_DIR..."
sudo mv /tmp/eksctl $BIN_DIR/eksctl
if [ $? -ne 0 ]; then
    echo "Move failed."
    exit 1
fi

# Add eksctl to PATH if not already present
if ! grep -q "export PATH=$BIN_DIR" ~/.bashrc; then
    echo "Adding $BIN_DIR to PATH in .bashrc..."
    echo "export PATH=$BIN_DIR:\$PATH" >> ~/.bashrc
fi

# Update the current shell's PATH
export PATH=$BIN_DIR:$PATH

# Test eksctl installation
echo "Verifying eksctl installation..."
eksctl version
if [ $? -eq 0 ]; then
    echo "eksctl installed successfully."
else
    echo "eksctl installation failed."
    exit 1
fi

# Check for OpenSSL and install if not present
if ! command -v openssl &> /dev/null; then
    echo "OpenSSL not found. Installing OpenSSL..."
    sudo yum install -y openssl
    if [ $? -ne 0 ]; then
        echo "OpenSSL installation failed."
        exit 1
    fi
fi

# Download and execute the Helm installation script
echo "Installing Helm..."
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
if [ $? -ne 0 ]; then
    echo "Helm installation failed."
    exit 1
fi

# Verify Helm installation
if command -v helm &> /dev/null; then
    echo "Helm installation was successful."
    helm version
else
    echo "Helm installation failed."
    exit 1
fi

echo "All tools installed successfully!"
