@echo off
setlocal

echo =======================================
echo   Windows Auto-Logon Configuration
echo =======================================
echo.

:: Ask for the Username
set /p "username=Enter the Default Username: "

:: Ask for the Password (Note: Characters will be visible as you type)
set /p "password=Enter the Default Password: "

echo.
echo Applying registry changes...

:: 1. Set AutoAdminLogon to 1 (DWORD)
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "AutoAdminLogon" /t REG_SZ /d "1" /f

:: 2. Set DefaultUserName (String)
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "DefaultUserName" /t REG_SZ /d "%username%" /f

:: 3. Set DefaultPassword (String)
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "DefaultPassword" /t REG_SZ /d "%password%" /f

echo.
echo Registry updated successfully.
echo Please restart your computer to test the auto-logon.
pause