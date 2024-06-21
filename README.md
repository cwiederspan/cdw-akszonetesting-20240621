# AKS Zone Testing

A repo for testing the creation of AKS clusters in regions with one or more capacity constrained AZs.

```bash

# Install Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash



# Setup environment variables
BASE_NAME=cdw-akstesting-20240621
LOCATION=westus2


# Check capacity
az vm list-skus --location $LOCATION -o table

# Check quota and usage
az vm list-usage --location $LOCATION -o table

# Create the resource group
az group create --name $BASE_NAME --location $LOCATION

# Deploy the AKS cluster using the bicep file
az deployment group create -g $BASE_NAME --template-file ./infra/main.bicep --parameters baseName=$BASE_NAME location=$LOCATION nodeZones="['3']"


```