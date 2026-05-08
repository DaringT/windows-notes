# Account creation in Windows

## Script Process
### [auto_logon.bat](scripts/account_creation.bat)
<br>

## How to add local accounts

### Add a user

Command Prompt
```cmd
net user "username-here" "password-here" /add
```

PowerShell
```ps1
New-LocalUser -Name "username-here" `
  -Password (ConvertTo-SecureString "password-here" -AsPlainText -Force)
```



### How to set the password to not expire

Command Prompt
```ps1
wmic useraccount where "Name='username-here'" set PasswordExpires=false
```

PowerShell
```ps1
Set-LocalUser -Name "username-here" -PasswordNeverExpires $true
```


### How to prevent the password from being changed (⚠️ Only local accounts)

Command Prompt
```cmd
net user "username-here" /passwordchg:no
```

PowerShell
```ps1
$user = [ADSI]"WinNT://./username-here,user"
$user.PasswordExpired = 0
$user.SetInfo()
```
