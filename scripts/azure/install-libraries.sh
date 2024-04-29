#!/bin/bash
# Your installation commands here
sudo apt-get update
sudo apt-cache showpkg apache2
sudo apt-get install -y apache2=2.4.29-1ubuntu4.27  # Install outdated Apache
sudo sed -i 's/ServerTokens OS/ServerTokens Full/' /etc/apache2/conf-available/security.conf  # Change ServerTokens
sudo sed -i 's/ServerSignature On/ServerSignature Off/' /etc/apache2/conf-available/security.conf
sudo apt-get install -y libssl1.0.0=1.0.2n-1ubuntu5 libcurl3  # Install outdated libraries
