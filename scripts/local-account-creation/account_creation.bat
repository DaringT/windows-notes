@echo off
setlocal enabledelayedexpansion

REM ============================================
REM Admin check and elevation
REM ============================================
fltmc >nul 2>&1 || (
    cls
    echo [WARNING] This script requires administrative privileges.
    echo Requesting elevation...

    powershell -Command "Start-Process cmd -ArgumentList '/c \"%~f0\"' -Verb RunAs"

    exit /b
)

REM ============================================
REM Username Prompt
REM ============================================
call :banner
set "username="
set /p username=Enter username:
set "password="
set /p password=Enter password:

REM ============================================
REM Account Type Prompt
REM ============================================
call :banner
echo Account Type:
echo [1] Administrator
echo [2] Local User
set /p acctype=Choose account type (1 or 2):

REM ============================================
REM Password Expiration Prompt
REM ============================================
call :banner
echo Should the password expire?
echo [1] Yes
echo [2] No
set /p pwexpire=Choose option (1 or 2):

REM ============================================
REM Create User
REM ============================================
call :banner
echo Creating user account...
echo.

net user "%username%" "%password%" /add

if errorlevel 1 (
    echo.
    echo Failed to create user.
    pause
    exit /b
)

echo.

REM ============================================
REM Administrator Group
REM ============================================
if "%acctype%"=="1" (
    net localgroup Administrators "%username%" /add

    if errorlevel 1 (
        echo Failed to add user to Administrators group.
    ) else (
        echo User added to Administrators group.
    )
) else (
    echo User created as standard local user.
)

REM ============================================
REM Password Expiration
REM ============================================
if "%pwexpire%"=="2" (
    wmic useraccount where "Name='%username%'" set PasswordExpires=false

    if errorlevel 1 (
        echo Failed to disable password expiration.
    ) else (
        echo Password expiration disabled.
    )
) else (
    echo Password expiration left enabled.
)

echo.

REM ============================================
REM Password Change Permission
REM ============================================
if "%acctype%"=="2" (

    call :banner
    set /p changepw=Allow user to change password? (Y/N):

    echo.

    if /I "%changepw%"=="N" (
        net user "%username%" /passwordchg:no
        echo User cannot change password.
    ) else (
        echo User can change password.
    )
)

echo.
echo ============================================
echo User setup completed successfully.
echo ============================================
pause
exit /b

REM ============================================
REM Banner Function
REM ============================================
:banner
cls
echo ============================================
echo        Windows User Creation Tool
echo ============================================
echo.
exit /b
