#!/bin/bash

# Set your desired values
resourceGroupName="WizLab"
location="eastus"

# Create resource group
echo "Creating RG"
az group create --name $resourceGroupName --location $location

# Deploy virtual network
echo "Creating VNET"
az group deployment create --resource-group $resourceGroupName --template-file vnet.json

# Wait for deployment to finish
az group deployment wait --resource-group $resourceGroupName --name deployment0 --timeout 1800

# Get subnet ID
subnetId=$(az network vnet subnet show --resource-group $resourceGroupName --vnet-name MyVNET --name MySubnet --query id --output tsv)

# Deploy virtual machine
echo "Deploying VM"
az group deployment create --resource-group $resourceGroupName --template-file vm.json --parameters subnetId=$subnetId 

# Wait for deployment to finish
az group deployment wait --resource-group $resourceGroupName --name deployment1 --timeout 1800


#Install libraries using a custom script extension
echo "Setting up VM"
script=$(base64 -w0 install-libraries.sh)
vmName="MyVM"
az vm extension set --resource-group $resourceGroupName --vm-name $vmName --name customScript --publisher Microsoft.Azure.Extensions --version 2.1 --settings "{\"script\": \"$script\"}"

storageAccountName="mystorageaccount$(date +%s | sha256sum | base64 | head -c 16)"

az storage account create --name $mystorageaccount --resource-group $resourceGroupName --location $location --sku Standard_LRS --allow-blob-public-access true

az storage container create --name mycontainer --account-name $mystorageaccount

az storage container set-permission --name mycontainer --public-access blob --account-name $mystorageaccount

echo "Deployment and library installation completed."
