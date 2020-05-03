echo OFF
:: cd to batch location directory
cd %~dp0

NET SESSION >nul 2>&1
if %ERRORLEVEL% EQU 0 (
	echo Administrator privileges detected! 
   echo.
) else (
	color 4
	ECHO Administrator privileges aren't detected! 
   echo.
   echo ####### ERROR: ADMINISTRATOR PRIVILEGES REQUIRED #########
   echo This script must be run as an administrator to work properly!  
   echo If you're seeing this after opening the script, then right click and select "Run as administrator".
   echo ##########################################################
   echo.
   PAUSE
   EXIT /B 1
)


set iconPath="\"%%LOCALAPPDATA%%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\terminal.ico\""
@echo on
echo Copying icon to WT settings directory
xcopy "terminal.ico" "%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\" /v /y /q
@echo off

echo.

echo the absolute path "wt-admin.vbs" will be copied in,
set /p vbsPath="you can also add it to path and use as command (leave empty for "C:\env\commands"): " || set "vbsPath=C:\env\commands"
@echo on
xcopy "wt-admin.vbs" "%vbsPath%" /v /y /q
@echo off
echo.

:: https://stackoverflow.com/questions/1794547/how-can-i-make-an-are-you-sure-prompt-in-a-windows-batchfile
setlocal
:PROMPT
set /P AREYOUSURE="Are you sure (Y/[N])? "
if /I "%AREYOUSURE%" neq "Y" GOTO END

:: /ve sets default value
:: /v stands for value
:: /f forces
:: /d stands for data
:: /t stands for type

:: HKEY_CLASSES_ROOT\Directory\Background\shell\PowerShell7-previewx64
::          ExtendedSubCommandsKey REG_SZ Directory\ContextMenus\PowerShell7-previewx64
::          Icon                   REG_SZ <PATH>
::          MUIVerb                &PowerShell 7-preview
reg add "HKEY_CLASSES_ROOT\Directory\shell\WindowsTerminal" /f /v "ExtendedSubCommandsKey" /d "Directory\ContextMenus\WindowsTerminal"
reg add "HKEY_CLASSES_ROOT\Directory\shell\WindowsTerminal" /f /v "Icon" /d "%iconPath%"
reg add "HKEY_CLASSES_ROOT\Directory\shell\WindowsTerminal" /f /v "MUIVerb" /d "Windows Terminal"
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\WindowsTerminal" /f /v "ExtendedSubCommandsKey" /d "Directory\ContextMenus\WindowsTerminal"
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\WindowsTerminal" /f /v "Icon" /d "%iconPath%"
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\WindowsTerminal" /f /v "MUIVerb" /d "Windows Terminal"

::     HKEY_CLASSES_ROOT\Directory\ContextMenus\PowerShell7-previewx64\shell\openpwsh
:: and HKEY_CLASSES_ROOT\Directory\ContextMenus\PowerShell7-previewx64\shell\runas
::          Icon        REG_SZ <PATH>
::          MUIVerb     REG_SZ <Label>

reg add "HKEY_CLASSES_ROOT\Directory\ContextMenus\WindowsTerminal\shell\open" /f /v "Icon" /d "%iconPath%"
reg add "HKEY_CLASSES_ROOT\Directory\ContextMenus\WindowsTerminal\shell\open" /f /v "MUIVerb" /d "Open here"

reg add "HKEY_CLASSES_ROOT\Directory\ContextMenus\WindowsTerminal\shell\openAsAdm" /f /v "Icon" /d "%iconPath%"
reg add "HKEY_CLASSES_ROOT\Directory\ContextMenus\WindowsTerminal\shell\openAsAdm" /f /v "MUIVerb" /d "Open here as Administrator"
:: System tries to apply admin rights on executable and also adds guard sign to icon
reg add "HKEY_CLASSES_ROOT\Directory\ContextMenus\WindowsTerminal\shell\openAsAdm" /f /v "HasLUAShield"

::     HKEY_CLASSES_ROOT\Directory\ContextMenus\PowerShell7-previewx64\shell\openpwsh\command
:: and HKEY_CLASSES_ROOT\Directory\ContextMenus\PowerShell7-previewx64\shell\runas\command
:: and
::          Icon        REG_SZ <PATH>
::          MUIVerb     REG_SZ <Label>

reg add "HKEY_CLASSES_ROOT\Directory\ContextMenus\WindowsTerminal\shell\open\command" /f /ve /d "%LocalAppData%\Microsoft\WindowsApps\wt.exe -d ""%%V\\."""
reg add "HKEY_CLASSES_ROOT\Directory\ContextMenus\WindowsTerminal\shell\openAsAdm\command" /f /ve /d "wscript.exe \"%vbsPath%\wt-admin.vbs\" \"%%V\\.\""


ECHO.
ECHO Done.
pause

:: https://stackoverflow.com/questions/1794547/how-can-i-make-an-are-you-sure-prompt-in-a-windows-batchfile
:END
endlocal