param location string
param adminUsername string
@secure()
param adminPassword string 

param managedIdentityId string
param subnetId string
param cartCname string
param productCname string
param resourceTags object

var cartVmName = 'cartVM'
var prodVmName = 'prodVM'
 

resource cartPublicIP 'Microsoft.Network/publicIPAddresses@2021-02-01' = {
  name: 'cartPublicIP'
  location: location
  tags: resourceTags
  properties: {
    publicIPAllocationMethod: 'Dynamic'
    dnsSettings: {
        domainNameLabel: '${cartCname}'
        fqdn: cartCname
    }
  }
}

resource cartNIC 'Microsoft.Network/networkInterfaces@2021-02-01' = {
  name: 'cartNIC'
  location: location
  tags: resourceTags
  properties: {
    ipConfigurations: [
      {
        name: 'myIPConfig'
        properties: {
          subnet: {
            id: subnetId
          }
          publicIPAddress: {
            id: cartPublicIP.id
          }
        }
      }
    ]
  }
}

resource cartVM 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: cartVmName
  location: location
  tags: resourceTags
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_DS2_v2'
    }
    osProfile: {
      computerName: cartVmName
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'canonical'
        offer: '0001-com-ubuntu-server-focal'
        sku: '20_04-lts-gen2'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        { id: cartNIC.id }
      ]
    }
    
  }
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentityId}': {}
    }
  }
}

resource cartVM_extensionName 'Microsoft.Compute/virtualMachines/extensions@2019-12-01' = {
  parent: cartVM
  name: 'DockerExtension'
  location: location
  tags: resourceTags
  properties: {
    publisher: 'Microsoft.Azure.Extensions'
    type: 'DockerExtension'
    typeHandlerVersion: '1.0'
    autoUpgradeMinorVersion: true
  }
} 

resource prodPublicIP 'Microsoft.Network/publicIPAddresses@2021-02-01' = {
  name: 'prodPublicIP'
  location: location
  tags: resourceTags
  properties: {
    publicIPAllocationMethod: 'Dynamic'
    dnsSettings: {
        domainNameLabel: '${productCname}'
        fqdn: productCname
    }
  }
}

resource prodNIC 'Microsoft.Network/networkInterfaces@2021-02-01' = {
  name: 'prodNIC'
  location: location
  tags: resourceTags
  properties: {
    ipConfigurations: [
      {
        name: 'myIPConfig'
        properties: {
          subnet: {
            id: subnetId
          }
          publicIPAddress: {
            id: prodPublicIP.id
          }
        }
      }
    ]
  }
}

resource prodVM 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: prodVmName
  location: location
  tags: resourceTags
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_DS2_v2'
    }
    osProfile: {
      computerName: prodVmName
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'canonical'
        offer: '0001-com-ubuntu-server-focal'
        sku: '20_04-lts-gen2'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        { id: prodNIC.id }
      ]
    }
    
  }
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentityId}': {}
    }
  }
}

resource prodVM_extensionName 'Microsoft.Compute/virtualMachines/extensions@2019-12-01' = {
  parent: prodVM
  name: 'DockerExtension'
  location: location
  tags: resourceTags
  properties: {
    publisher: 'Microsoft.Azure.Extensions'
    type: 'DockerExtension'
    typeHandlerVersion: '1.0'
    autoUpgradeMinorVersion: true
  }
} 
