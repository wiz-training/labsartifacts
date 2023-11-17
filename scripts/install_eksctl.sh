#!/bin/bash

# Variables
ARCH=amd64
PLATFORM=$(uname -s)_$ARCH
EKSCTL_PATH=/home/cloudshell-user/eksctl

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
sudo mv /tmp/eksctl $EKSCTL_PATH
if [ $? -ne 0 ]; then
    echo "Move failed."
    exit 1
fi

# Add eksctl to PATH if not already present
if ! echo $PATH | grep -q $EKSCTL_PATH; then
    echo "export PATH=$EKSCTL_PATH:\$PATH" >> ~/.bashrc
    source ~/.bashrc
fi

# Test eksctl installation
eksctl version
if [ $? -eq 0 ]; then
    echo "eksctl installed successfully."
else
    echo "eksctl installation failed."
fi
