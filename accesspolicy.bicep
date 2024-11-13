// ============ add-accesspolicies.bicep ============

param keyVaultName string
@description('Specifies the object ID of a user, service principal or security group in the Azure Active Directory tenant for the vault. The object ID must be unique for the list of access policies. Get it by using Get-AzADUser or Get-AzADServicePrincipal cmdlets.')
param objectId string

//@description('Specifies the permissions to keys in the vault. Valid values are: all, encrypt, decrypt, wrapKey, unwrapKey, sign, verify, get, list, create, update, import, delete, backup, restore, recover, and purge.')
//param keysPermissions array 

//@description('Specifies the permissions to secrets in the vault. Valid values are: all, get, list, set, delete, backup, restore, recover, and purge.')
//param secretsPermissions array

//@description('Specifies the permissions to secrets in the vault. Valid values are: all, get, list, set, delete, backup, restore, recover, and purge.')
//param certificatePermissions array 

resource accessPolicies 'Microsoft.KeyVault/vaults/accessPolicies@2022-07-01' = {
  name: 'add'
  parent: keyVaul
  properties: {
    accessPolicies: [
      {
        objectId: objectId
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
output keyVaultName string = keyVaultName
output objectId string = accessPolicies.properties.accessPolicies[0].objectId
output keys array = accessPolicies.properties.accessPolicies[0].permissions.keys
output secrets array = accessPolicies.properties.accessPolicies[0].permissions.secrets
output certificates array = accessPolicies.properties.accessPolicies[0].permissions.certificates
