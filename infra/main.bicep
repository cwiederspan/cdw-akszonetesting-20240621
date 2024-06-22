@description('The name of the Managed Cluster resource.')
param baseName string

@description('The location of the Managed Cluster resource.')
param location string = resourceGroup().location

@description('The size of the Virtual Machine.')
param agentVMSize string = 'Standard_D4ds_v5'

@description('The number of nodes for the default system node pool.')
@minValue(1)
@maxValue(5)
param systemNodeCount int = 1

@description('List of Availability Zones to use for the default system node pool.')
param systemNodeAZs array = []  // ['1', '2', '3']

@description('The number of nodes for the user node pool.')
@minValue(1)
@maxValue(5)
param userNodeCount int = 1

@description('List of Availability Zones to use for the user node pool.')
param userNodeAZs array = [] 

resource aks 'Microsoft.ContainerService/managedClusters@2024-02-01' = {
  name: baseName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    dnsPrefix: baseName
    agentPoolProfiles: [
      {
        name: 'systempool001'
        availabilityZones: systemNodeAZs
        vmSize: agentVMSize
        count: systemNodeCount
        osDiskType: 'Ephemeral'
        osType: 'Linux'
        mode: 'System'
      }
    ]
  }
}

resource userNodePool001 'Microsoft.ContainerService/managedClusters/agentPools@2024-02-01' = {
  name: 'userpool001'
  parent: aks
  properties: {
    availabilityZones: userNodeAZs
    vmSize: agentVMSize
    count: userNodeCount
    osDiskType: 'Ephemeral'
    osType: 'Linux'
    mode: 'User'
  }
}

output controlPlaneFQDN string = aks.properties.fqdn
