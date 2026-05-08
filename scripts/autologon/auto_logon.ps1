Write-Host "======================================="
Write-Host "  Windows Auto-Logon Configuration"
Write-Host "======================================="
Write-Host ""

# Ask for the Username
$username = Read-Host "Enter the Default Username"

# Ask for the Password securely
$password = Read-Host "Enter the Default Password" -AsSecureString

# Convert SecureString to plain text for registry storage
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password)
$plainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

Write-Host ""
Write-Host "Applying registry changes..."

$regPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"

# 1. Enable AutoAdminLogon
Set-ItemProperty -Path $regPath -Name "AutoAdminLogon" -Value "1"

# 2. Set DefaultUserName
Set-ItemProperty -Path $regPath -Name "DefaultUserName" -Value $username

# 3. Set DefaultPassword
Set-ItemProperty -Path $regPath -Name "DefaultPassword" -Value $plainPassword

Write-Host ""
Write-Host "Registry updated successfully."
Write-Host "Please restart your computer to test the auto-logon."

pause