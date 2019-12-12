:: Thanks to blak3r for creating the part to check for admin rights
:: https://stackoverflow.com/questions/4051883/batch-script-how-to-check-for-admin-rights

echo OFF
NET SESSION >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    ECHO Administrator PRIVILEGES Detected! 
) ELSE (
   echo ######## ########  ########   #######  ########  
   echo ##       ##     ## ##     ## ##     ## ##     ## 
   echo ##       ##     ## ##     ## ##     ## ##     ## 
   echo ######   ########  ########  ##     ## ########  
   echo ##       ##   ##   ##   ##   ##     ## ##   ##   
   echo ##       ##    ##  ##    ##  ##     ## ##    ##  
   echo ######## ##     ## ##     ##  #######  ##     ## 
   echo.
   echo.
   echo ####### ERROR: ADMINISTRATOR PRIVILEGES REQUIRED #########
   echo This script must be run as an administrator to work properly!  
   echo If you're seeing this after opening the script, then right click and select "Run as administrator".
   echo ##########################################################
   echo.
   PAUSE
   EXIT /B 1
)
@echo ON

xcopy "terminal.ico" "%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\" /b /v /y /q

@echo off

reg.exe add "HKEY_CLASSES_ROOT\Directory\Background\shell\wt" /f /ve /d "Open Windows Terminal window here"
reg.exe add "HKEY_CLASSES_ROOT\Directory\Background\shell\wt" /f /v "Icon" /t REG_EXPAND_SZ /d "\"%%LOCALAPPDATA%%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\terminal.ico\""
reg.exe add "HKEY_CLASSES_ROOT\Directory\Background\shell\wt\command" /f /ve /t REG_EXPAND_SZ /d "\"%%LOCALAPPDATA%%\Microsoft\WindowsApps\wt.exe\""

pause