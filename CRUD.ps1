# Copyright (c) 2022 YA-androidapp(https://github.com/YA-androidapp) All rights reserved.


# トークン取得
$appSecret = 'oGf8Q~1a2Jmgn21z~3Z~********************'
$resourceAppIdUri = 'https://***********.crm*.dynamics.com'

$tenantId = (Get-AzTenant).Id
$appId = (Get-AzADApplication -Displayname 'PowerShellDataverseClient').AppId
$tokenEndpoint = 'https://login.microsoftonline.com/' + $tenantId + '/oauth2/token'

$body = @{
    resource      = $resourceAppIdUri
    client_id     = $appId
    client_secret = $appSecret
    grant_type    = 'client_credentials'
}

$response = Invoke-RestMethod -Method Post -Uri $tokenEndpoint -Body $body -ErrorAction Stop
$token = $response.access_token
Write-Output $token


# READ
# LogicalNameで指定
$query = '$select=crcda_zenkokuid,createdon,modifiedon&$filter=(createdon gt 2022-01-23T01:23:45Z)'

# LogicalCollectionNameで指定
$table = 'crcda_zenkokus'

$headers = @{Authorization = 'Bearer ' + $Token }
$endPoint = $resourceAppIdUri + '/api/data/v9.2/' + $table
$result = Invoke-RestMethod -Uri ($endPoint + '?' + $query) -Method 'GET' -Headers $headers

Write-Output $result.value | ConvertTo-Json
$result.value | ConvertTo-Csv | Out-File read.csv



# ----------

# CRUD共通
$headers = @{Authorization = " Bearer $Token" }
$endPoint = 'https://*******.api.crm*.dynamics.com/api/data/v9.2/crcda_zenkokus'

$id = '*******-****-****-****-***********'
$body = '{"crcda_zenkokuid":"abc123"}'

# C
Invoke-RestMethod -Uri $endPoint -Method 'POST' -Headers $headers -Body $body -ContentType "application/json"

# R
Invoke-RestMethod -Uri $endPoint -Method 'GET' -Headers $headers

# U
Invoke-RestMethod -Uri "$endPoint($id)" -Method 'PATCH' -Headers $headers -Body $body -ContentType "application/json"

# D
Invoke-RestMethod -Uri "$endPoint($id)" -Method 'DELETE' -Headers $headers -Body $body
