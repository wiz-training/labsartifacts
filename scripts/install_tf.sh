
# Add bin to PATH in .bashrc if not already present
export PATH=$bin:$PATH

# Test Terraform installation
terraform version
if [ $? -eq 0 ]; then
    echo "Terraform installed successfully."
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
