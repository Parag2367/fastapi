@description('Azure Region for Deployment')
param location string = resourceGroup().location

@description('Name of the RG Key Vault')
param keyVaultName string

@description('Specifies the object ID of a user, service principal or security group in the Azure Active Directory tenant for the vault. The object ID must be unique for the list of access policies. Get it by using Get-AzADUser or Get-AzADServicePrincipal cmdlets.')
param objectId string

@description('Specifies the object ID of a user, service principal or security group in the Azure Active Directory tenant for the vault. The object ID must be unique for the list of access policies. Get it by using Get-AzADUser or Get-AzADServicePrincipal cmdlets.')
param objectId1 string

@description('Specifies the object ID of a user, service principal or security group in the Azure Active Directory tenant for the vault. The object ID must be unique for the list of access policies. Get it by using Get-AzADUser or Get-AzADServicePrincipal cmdlets.')
param objectId2 string

@description('Specifies the object ID of a user, service principal or security group in the Azure Active Directory tenant for the vault. The object ID must be unique for the list of access policies. Get it by using Get-AzADUser or Get-AzADServicePrincipal cmdlets.')
param objectId3 string

@description('Specifies the permissions to keys in the vault. Valid values are: all, encrypt, decrypt, wrapKey, unwrapKey, sign, verify, get, list, create, update, import, delete, backup, restore, recover, and purge.')
param keysPermissions array = ['list']

@description('Specifies the permissions to secrets in the vault. Valid values are: all, get, list, set, delete, backup, restore, recover, and purge.')
param secretsPermissions array = ['list']

@description('Specifies the permissions to secrets in the vault. Valid values are: all, get, list, set, delete, backup, restore, recover, and purge.')
param certificatePermissions array = ['list']

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
          certificates: certificatePermissions
        }
      }
    ]

    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
    }
  }
}

// ============ add-accesspolicies.bicep ============


resource accessPolicies 'Microsoft.KeyVault/vaults/accessPolicies@2022-07-01' = {
  parent: keyVault
  name: 'add'
  properties: {
    accessPolicies: [
      {
        objectId: objectId1
        tenantId: subscription().tenantId
        permissions: {
          keys: ['all']
          secrets: ['all']
          certificates: ['all']
        }
      }
      {
        objectId: objectId2
        tenantId: subscription().tenantId
        permissions: {
          keys: keysPermissions
          secrets: secretsPermissions
          certificates: certificatePermissions
        }
      }
      {
        objectId: objectId3
        tenantId: subscription().tenantId
        permissions: {
          keys: keysPermissions
          secrets: secretsPermissions
          certificates: certificatePermissions
        }
      }
    ]
  }
}



output resourceGroupName string = resourceGroup().name
output keyVaultName string = keyVault.name
output keyvaultSku string = keyVault.properties.sku.name
output objectId string = keyVault.properties.accessPolicies[0].objectId
output objectId1 string = accessPolicies.properties.accessPolicies[0].objectId
output objectId2 string = accessPolicies.properties.accessPolicies[1].objectId
output objectId3 string = accessPolicies.properties.accessPolicies[2].objectId
output keys array = accessPolicies.properties.accessPolicies[0].permissions.keys
output secrets array = accessPolicies.properties.accessPolicies[0].permissions.secrets
output certificates array = accessPolicies.properties.accessPolicies[0].permissions.certificates
