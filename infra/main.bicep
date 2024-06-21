@description('The name of the Managed Cluster resource.')
param baseName string

@description('The location of the Managed Cluster resource.')
param location string = resourceGroup().location

@description('The number of nodes for the cluster.')
@minValue(1)
@maxValue(5)
param agentCount int = 1

@description('The size of the Virtual Machine.')
param agentVMSize string = 'standard_d2ds_v5'

@description('List of Availability Zones to use for the default node pool.')
param nodeZones array = ['1', '2', '3']

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
        name: 'agentpool'
        availabilityZones: nodeZones
        osDiskType: 'Ephemeral'
        count: agentCount
        vmSize: agentVMSize
        osType: 'Linux'
        mode: 'System'
      }
    ]
  }
}

output controlPlaneFQDN string = aks.properties.fqdn
