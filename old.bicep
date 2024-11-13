// Creates a KeyVault

@description('Azure Region for Deployment')
param location string = resourceGroup().location

@description('Name of the Key Vault')
param keyVaultName string

@description('Specifies whether the key vault is a standard vault or a premium vault.')
@allowed([
  'standard'
  'premium'])
param keyvaultSku string = 'standard'

resource keyVault 'Microsoft.KeyVault/vaults@2021-10-01' = {
  name: keyVaultName
  location: location
  properties: {
    createMode: 'default'
    enabledForDeployment: false
    enabledForDiskEncryption: false
    enabledForTemplateDeployment: false
    enableSoftDelete: true
    enableRbacAuthorization: true
    enablePurgeProtection: true
    tenantId: subscription().tenantId
    softDeleteRetentionInDays: 90
    sku: {
      name: keyvaultSku
      family: 'A'
    }

    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
    }
  }
}

output resourceGroupName string = resourceGroup().name
output keyVaultName string = keyVault.name
output keyVaultId string = keyVault.id
output keyvaultSku string = keyVault.properties.sku.name
