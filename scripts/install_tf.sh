#!/bin/bash

# Downnload Terraform Version Manager to help install Terraform
git clone https://github.com/tfutils/tfenv.git ~/.tfenv
if [ $? -ne 0 ]; then
    echo "Download failed."
    exit 1
fi

# Make a new directory called ~/bin if it doesn't exist
mkdir -p ~/bin
if [ $? -ne 0 ]; then
    echo "Failed to create /bin directory."
    exit 1
fi

# Make a symlink for tfenv/bin/* scripts into the path ~/bin 
ln -s ~/.tfenv/bin/* ~/bin/
if [ $? -ne 0 ]; then
    echo "Symlink failed."
    exit 1
fi

# With Terraform Version Manager install Terraform
tfenv install
if [ $? -ne 0 ]; then
    echo "Terraform install failed."
    exit 1
fi

tfenv use latest
if [ $? -ne 0 ]; then
    echo "Cannot set version."
    exit 1
fi

# Test terraform installation
terraform version
if [ $? -eq 0 ]; then
    echo "Terraform installed successfully."
else
    echo "Terraform installation failed."
    exit 1
fi

# Move the installed Terraform binary to ~/bin and remove tfenv
cp ~/.tfenv/versions/$(tfenv list | head -n 1)/terraform ~/bin/terraform
if [ $? -ne 0 ]; then
    #echo "Failed to copy Terraform binary."
    exit 1
fi

# Clean up install files to save space
rm -rf ~/.tfenv
if [ $? -ne 0 ]; then
    echo "Failed to clean up tfenv."
    exit 1
fi

echo "Cleanup successful."
