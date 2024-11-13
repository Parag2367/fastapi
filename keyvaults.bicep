@description('Azure Region for Deployment')
param location string = resourceGroup().location

@description('Name of the RG Key Vault')
param keyVaultName string

@description('Specifies the object ID of a user, service principal or security group in the Azure Active Directory tenant for the vault. The object ID must be unique for the list of access policies. Get it by using Get-AzADUser or Get-AzADServicePrincipal cmdlets.')
param objectId string

@description('Specifies the object ID of a user, service principal or security group in the Azure Active Directory tenant for the vault. The object ID must be unique for the list of access policies. Get it by using Get-AzADUser or Get-AzADServicePrincipal cmdlets.')
param objectId1 string

@description('Specifies the permissions to keys in the vault. Valid values are: all, encrypt, decrypt, wrapKey, unwrapKey, sign, verify, get, list, create, update, import, delete, backup, restore, recover, and purge.')
param keysPermissions array

@description('Specifies the permissions to secrets in the vault. Valid values are: all, get, list, set, delete, backup, restore, recover, and purge.')
param secretsPermissions array

@description('Specifies the permissions to secrets in the vault. Valid values are: all, get, list, set, delete, backup, restore, recover, and purge.')
param certificatesPermissions array

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
    enablePurgeProtection: true
    tenantId: subscription().tenantId
    softDeleteRetentionInDays: 90
    sku: {
      name: keyvaultSku
      family: 'A'
    }

    accessPolicies: [
      {
        objectId: objectId
        tenantId:  subscription().tenantId
        permissions: {
          keys: keysPermissions
          secrets: secretsPermissions
          certificates: certificatesPermissions
        }
      }
      {
        objectId: objectId1
        tenantId: subscription().tenantId
        permissions:{
          keys: keysPermissions
          secrets: secretsPermissions
          certificates: certificatesPermissions
        }
      }


    ]

    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
    }
  }
}



output resourceGroupName string = resourceGroup().name
output keyVaultName string = keyVault.name
output keyvaultSku string = keyVault.properties.sku.name
output objectId string = keyVault.properties.accessPolicies[0].objectId
output objectId1 string = keyVault.properties.accessPolicies[0].objectId
