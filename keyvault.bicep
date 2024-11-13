@description('Azure Region for Deployment')
param location string = resourceGroup().location

@description('Name of the RG Key Vault')
param keyVaultName string

@description('Specifies the object ID of a user, service principal or security group in the Azure Active Directory tenant for the vault. The object ID must be unique for the list of access policies. Get it by using Get-AzADUser or Get-AzADServicePrincipal cmdlets.')
param objectId array

@description ('keyvault sku')
param keyvaultSku string = 'standard'

param cicd object = {
  keys: ['all', 'purge']
  secrets: ['all' , 'purge']
  certificates: ['all', 'purge']
}

param owner object = {
  keys: ['all' , 'purge']
  secrets: ['all', 'purge']
  certificates: ['all', 'purge']
}

param reader object = {
  keys: ['get']
  secrets: ['get']
  certificates: ['get']
}

param contributor object = {
  keys: ['list']
  secrets: ['list']
  certificates: ['list']
}

resource keyVault 'Microsoft.KeyVault/vaults@2021-10-01' = {
  name: keyVaultName
  location: location
  properties: {
    createMode: 'default'
    enabledForDeployment: true
    enabledForDiskEncryption: true
    enabledForTemplateDeployment: true
    enableSoftDelete: true
    enablePurgeProtection: true
    tenantId: subscription().tenantId
    softDeleteRetentionInDays: 90
    sku: {
      name: keyvaultSku
      family: 'A'
    }

    accessPolicies: [ for a in objectId : {
        objectId: a
        permissions: a
      }
    ]

    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
    }
  }
}

output keyVaultName string = keyVault.name
