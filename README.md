# PowerShell-DataverseClient

Calling Dataverse Web API via PowerShell

---

## 準備

### AADアプリ登録

```powershell

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

```

### APIエンドポイント確認

Power Platform 管理センターの [環境](https://admin.powerplatform.microsoft.com/environments/) から対象環境を「オープン」して遷移先URLを確認

```
https://<env-name>.api.<region>.dynamics.com/api/data/v9.2/

https://org********.api.crm*.dynamics.com/api/data/v9.2/
```

### セキュリティロール設定

- [環境](https://admin.powerplatform.microsoft.com/environments/) > <対象環境> > 設定 > セキュリティ ロール > 新しいロール
- 「詳細」タブ > 「ロール名」を入力
- 「ユーザー定義エンティティ」 > <対象のテーブル> に権限付与（作成・読み・書き・削除）

| 項目           | 種類     | 種類の別名 | 内容                                   |
| -------------- | -------- | ---------- | -------------------------------------- |
| 特権           |          |            |                                        |
|                | 作成     | Create     | レコードを作成                         |
|                | 読み込み | Read       | レコードを読み取り                     |
|                | 書き込み | Write      | レコードを更新                         |
|                | 削除     | Delete     | レコードを削除                         |
|                | 追加     | Append     | 他レコードに紐づける                   |
|                | 追加先   | AppendTo   | 他のレコードを紐づける                 |
|                | 割り当て | Assign     | レコード所有者を変更                   |
|                | 共有     | Share      | レコードを共有                         |
|                |          |            |                                        |
| アクセスレベル |          |            |                                        |
|                | 組織全体 | グローバル | すべてのレコード                       |
|                | 部署配下 | ディープ   | 所属部署・配下の部署に所属するレコード |
|                | 部署     | ローカル   | 所属部署に所属するレコード             |
|                | ユーザー | 基本       | 自身が所有するレコード                 |
|                | なし     |            | 権限なし                               |


### アプリユーザー設定

- [環境](https://admin.powerplatform.microsoft.com/environments/) > <対象環境> > 設定 > アプリケーション ユーザー > アプリユーザーの設定
- 「アプリ」 > AADアプリを選択
- 「部署」を選択
- 「セキュリティロール」に作成したものを指定

---

## APIアクセス

### CRUD

[手順](CRUD.ps1)

---

Copyright (c) 2022 YA-androidapp(https://github.com/YA-androidapp) All rights reserved.
