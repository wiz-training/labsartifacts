#!/bin/bash

# Downnload Terraform Version Manager to help install Terraform
git clone https://github.com/tfutils/tfenv.git ~/.tfenv
if [ $? -ne 0 ]; then
    echo "Download failed."
    exit 1
fi

# make a new directory called ~/bin
mkdir ~/bin
if [ $? -ne 0 ]; then
    echo "/bin directory already exists."
    exit 1
fi

# make a symlink for tfenv/bin/* scripts into the path ~/bin 
ln -s ~/.tfenv/bin/* ~/bin/
if [ $? -ne 0 ]; then
    echo "Simlink failed."
    exit 1
fi

# with Terraform Version Manager install Terraform
tfenv install
if [ $? -ne 0 ]; then
    echo "Terraform install failed."
    exit 1
fi

# Test terraform installation
terraform version
if [ $? -eq 0 ]; then
    echo "terrafrom installed successfully."
else
    echo "terrafrom installation failed."
fi

