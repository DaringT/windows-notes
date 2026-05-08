@echo off
setlocal enabledelayedexpansion

REM Get the current date and time
for /f "tokens=2-7 delims=:/ " %%a in ('echo %DATE% %TIME%') do (
    set month=%%a
    set day=%%b
    set year=%%c
    set hour=%%d
    set minute=%%e
)

REM Remove leading zeros from date and time components
if "%day:~0,1%"=="0" set day=%day:~1%
if "%month:~0,1%"=="0" set month=%month:~1%
if "%hour:~0,1%"=="0" set hour=%hour:~1%
if "%minute:~0,1%"=="0" set minute=%minute:~1%

REM Construct the folder name
set folder_name=STMS_Logs_%month%-%day%-%year%_%hour%-%minute%

REM Create destination folder
set destination_folder=D:\%folder_name%
mkdir "%destination_folder%"

REM Define source paths and suffixes for the filenames
set sources[1]=X:\Windows\temp\SMSTSLog\smsts.log
set suffixes[1]=X_Windows_temp_SMSTSLog

set sources[2]=X:\smstslog\smsts.log
set suffixes[2]=X_smstslog

set sources[3]=c:\_SMSTaskSequence\Logs\Smstslog\smsts.log
set suffixes[3]=C_SMSTaskSequence_Logs_Smsts

set sources[4]=c:\windows\ccm\logs\Smstslog\smsts.log
set suffixes[4]=C_windows_ccm_logs_Smsts

set sources[5]=c:\windows\ccm\logs\smsts.log
set suffixes[5]=C_windows_ccm_logs_Smsts



REM Copy log files from each source to the destination folder
for /l %%i in (1,1,5) do (
    if exist "!sources[%%i]!" (
        set log_filename=smsts!suffixes[%%i]!.log
        copy /Y "!sources[%%i]!" "%destination_folder%\!log_filename!"
        echo Copied !sources[%%i]! to %destination_folder%\!log_filename!
    ) else (
        echo Source file !sources[%%i]! does not exist.
    )
)

echo All specified SMSTS log files copied to: %destination_folder%
