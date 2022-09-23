# Copyright (c) 2022 YA-androidapp(https://github.com/YA-androidapp) All rights reserved.


# 環境
$PSVersionTable.PSVersion
# Major  Minor  Patch  PreReleaseLabel BuildLabel
# -----  -----  -----  --------------- ----------
# 7      2      6


# AZモジュールを管理者としてインストール
# Administrator
Install-Module -Name Az -AllowClobber -Scope AllUsers


# Current user
Connect-AzAccount
# ポップアップ画面でサインイン


# 既存AADアプリの一覧→アプリのAPIアクセス許可一覧→既存のアプリでApiIdと-PermissionIdを確認
Get-AzADApplication
# DisplayName                                  Id                                   AppId
# -----------                                  --                                   -----
# PowerShellDataverseClient                    351c9b18-e80f-4a3d-976d-************ de3c8178-a1d0-4d36-98de-************

Get-AzADApplication -ObjectId 351c9b18-e80f-4a3d-976d-************ | FL -Property *Id
# ...

Get-AzADAppPermission -ObjectId 351c9b18-e80f-4a3d-976d-************
# ApiId                                Id                                   Type
# -----                                --                                   ----
# 00000007-0000-0000-c000-000000000000 78ce3f0f-a1ce-49c2-8cde-64b5c0896db4 Scope
# 00000007-0000-0000-c000-000000000000, 78ce3f0f-a1ce-49c2-8cde-64b5c0896db4 は Dynamics CRM user_impersonation の ApiId, PermissionId


# AADアプリ登録
New-AzADApplication -DisplayName 'PowerShellDataverseClient' -AvailableToOtherTenants $false


# APIアクセス許可を追加
Add-AzADAppPermission -ObjectId 351c9b18-e80f-4a3d-976d-************ -ApiId 00000007-0000-0000-c000-000000000000 -PermissionId 78ce3f0f-a1ce-49c2-8cde-64b5c0896db4


# シークレットを取得
$appId = '351c9b18-e80f-4a3d-976d-************'
$today = get-Date
$endDay = $today.addYears(1)
New-AzADAppCredential -ObjectId $appId -StartDate $today -EndDate $endDay
# CustomKeyIdentifier DisplayName EndDateTime        Hint KeyId                                SecretText                               StartDateTime
# ------------------- ----------- -----------        ---- -----                                ----------                               -------------
#                                 2023/09/23 4:55:18 oGf  47edd75c-c5ac-476f-843e-************ oGf8Q~1a2Jmgn21z~3Z~******************** 2022/09/23 4:55:18


# サービスプリンシパルを作成
Get-AzADApplication -ObjectId $appId | New-AzADServicePrincipal
# DisplayName               Id                                   AppId
# -----------               --                                   -----
# PowerShellDataverseClient 77161a5d-7041-4da3-9b49-************ de3c8178-a1d0-4d36-98de-************
