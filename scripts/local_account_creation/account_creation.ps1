# ============================================
# Windows User Creation Tool
# ============================================

function Show-Banner {
    Clear-Host
    Write-Host "============================================"
    Write-Host "       Windows User Creation Tool"
    Write-Host "============================================"
    Write-Host ""
}

# ============================================
# Admin Check + Elevation
# ============================================

$currentUser = New-Object Security.Principal.WindowsPrincipal `
    ([Security.Principal.WindowsIdentity]::GetCurrent())

$isAdmin = $currentUser.IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator
)

if (-not $isAdmin) {

    Clear-Host
    Write-Host "[WARNING] This script requires administrative privileges."
    Write-Host "Requesting elevation..."
    Write-Host ""

    Start-Process powershell `
        -ArgumentList "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" `
        -Verb RunAs

    exit
}

# ============================================
# Username Prompt
# ============================================

Show-Banner

$username = Read-Host "Enter username"

if ([string]::IsNullOrWhiteSpace($username)) {
    Write-Host ""
    Write-Host "Username cannot be empty."
    Pause
    exit
}

# ============================================
# Password Prompt
# ============================================

$passwordSecure = Read-Host "Enter password" -AsSecureString

if (-not $passwordSecure) {
    Write-Host ""
    Write-Host "Password cannot be empty."
    Pause
    exit
}

# ============================================
# Account Type Prompt
# ============================================

Show-Banner

Write-Host "Account Type:"
Write-Host "[1] Administrator"
Write-Host "[2] Local User"
Write-Host ""

$acctype = Read-Host "Choose account type (1 or 2)"

if ($acctype -ne "1" -and $acctype -ne "2") {
    Write-Host ""
    Write-Host "Invalid selection."
    Pause
    exit
}

# ============================================
# Password Expiration Prompt
# ============================================

Show-Banner

Write-Host "Should the password expire?"
Write-Host "[1] Yes"
Write-Host "[2] No"
Write-Host ""

$pwexpire = Read-Host "Choose option (1 or 2)"

if ($pwexpire -ne "1" -and $pwexpire -ne "2") {
    Write-Host ""
    Write-Host "Invalid selection."
    Pause
    exit
}

# ============================================
# Create User
# ============================================

Show-Banner

Write-Host "Creating user account..."
Write-Host ""

try {
    New-LocalUser `
        -Name $username `
        -Password $passwordSecure `
        -FullName $username `
        -Description "Local user account"

    Write-Host "User account created successfully."
    Write-Host ""
}
catch {
    Write-Host "Failed to create user."
    Write-Host $_.Exception.Message
    Pause
    exit
}

# ============================================
# Administrator Group
# ============================================

if ($acctype -eq "1") {

    try {
        Add-LocalGroupMember `
            -Group "Administrators" `
            -Member $username

        Write-Host "User added to Administrators group."
    }
    catch {
        Write-Host "Failed to add user to Administrators group."
    }
}
else {
    Write-Host "User created as standard local user."
}

Write-Host ""

# ============================================
# Password Expiration
# ============================================

if ($pwexpire -eq "2") {

    try {
        Set-LocalUser `
            -Name $username `
            -PasswordNeverExpires $true

        Write-Host "Password expiration disabled."
    }
    catch {
        Write-Host "Failed to disable password expiration."
    }

}
else {
    Write-Host "Password expiration left enabled."
}

Write-Host ""

# ============================================
# Password Change Permission
# ============================================

if ($acctype -eq "2") {

    Show-Banner

    $changepw = Read-Host "Allow user to change password? (Y/N)"

    Write-Host ""

    if ($changepw.ToUpper() -eq "N") {

        try {
            net user "$username" /passwordchg:no | Out-Null
            Write-Host "User cannot change password."
        }
        catch {
            Write-Host "Failed to restrict password changes."
        }

    }
    else {
        Write-Host "User can change password."
    }
}

Write-Host ""
Write-Host "============================================"
Write-Host "User setup completed successfully."
Write-Host "============================================"

Pause