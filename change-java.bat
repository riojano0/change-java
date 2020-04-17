@echo off

SET SCRIPT_DIR=%~dp0
SET FILE_VERSION=%SCRIPT_DIR%/java-location.txt
SET JAVA_TARGET=%1

REM Original permission batch code https://sites.google.com/site/eneerge/scripts/batchgotadmin
:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    for /F "eol=# delims== tokens=1,*" %%a in (%FILE_VERSION%) do (
        IF "%%a" == "%JAVA_TARGET%" (
            echo "Trying to use %%b Restart your console/app to take effect"
        )
    )

    goto UACPrompt

    echo "B"
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"

    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"

    echo "C"
:--------------------------------------   

REM Here is execute code in admin rights

for /F "eol=# delims== tokens=1,*" %%a in (%FILE_VERSION%) do (
    IF "%%a" == "%JAVA_TARGET%" (
        SETX /M JAVA_HOME "%%b"
    )
)