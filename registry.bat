echo OFF
:: cd to batch location directory
cd %~dp0

NET SESSION >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
	echo Administrator privileges detected! 
   echo.
) ELSE (
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



SET /p SKIP_COPY="Copy icon to a directory, that contains WT settings, to use default path (Y/[N])? "
IF /I "%SKIP_COPY%" EQU "Y" (
   @echo on
   xcopy "terminal.ico" "%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\" /v /y /q
   set iconPath="\"%%LOCALAPPDATA%%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\terminal.ico\""
   @echo off
)

echo.
echo Enter:
if /I "%SKIP_COPY%" NEQ "Y" (
   echo.
   set /p iconPath="icon path: "
)
echo.

set /p contextmenuName="context menu naming with NO spaces (leave empty for "WindowsTerminal"): " || set "contextmenuName=WindowsTerminal"
echo.

set /p contextmenuLabel="context menu label (leave empty for "Windows Terminal"): " || set "contextmenuLabel=Windows Terminal"
echo.

echo the absolute path "wt-admin.vbs" will be copied in,
set /p openAdmPath="you can also add it to path and use as command (leave empty for "C:\env\commands"): " || set "openAdmPath=C:\env\commands"
@echo on
xcopy "wt-admin.vbs" "%openAdmPath%" /v /y /q
@echo off
echo.

:: https://stackoverflow.com/questions/1794547/how-can-i-make-an-are-you-sure-prompt-in-a-windows-batchfile
@echo off
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
reg.exe add "HKEY_CLASSES_ROOT\Directory\Background\shell\%contextmenuName%" /f /v "ExtendedSubCommandsKey" /d "Directory\ContextMenus\%contextmenuName%"
reg.exe add "HKEY_CLASSES_ROOT\Directory\Background\shell\%contextmenuName%" /f /v "Icon" /d "%iconPath%"
reg.exe add "HKEY_CLASSES_ROOT\Directory\Background\shell\%contextmenuName%" /f /v "MUIVerb" /d "%contextmenuLabel%"

::     HKEY_CLASSES_ROOT\Directory\ContextMenus\PowerShell7-previewx64\shell\openpwsh
:: and HKEY_CLASSES_ROOT\Directory\ContextMenus\PowerShell7-previewx64\shell\runas
::          Icon        REG_SZ <PATH>
::          MUIVerb     REG_SZ <Label>

reg.exe add "HKEY_CLASSES_ROOT\Directory\ContextMenus\%contextmenuName%\shell\open" /f /v "Icon" /d "%iconPath%"
reg.exe add "HKEY_CLASSES_ROOT\Directory\ContextMenus\%contextmenuName%\shell\open" /f /v "MUIVerb" /d "Open here"

reg.exe add "HKEY_CLASSES_ROOT\Directory\ContextMenus\%contextmenuName%\shell\openAsAdm" /f /v "Icon" /d "%iconPath%"
reg.exe add "HKEY_CLASSES_ROOT\Directory\ContextMenus\%contextmenuName%\shell\openAsAdm" /f /v "MUIVerb" /d "Open here as Administrator"
:: System tries to apply admin rights on executable and also adds guard sign to icon
reg.exe add "HKEY_CLASSES_ROOT\Directory\ContextMenus\%contextmenuName%\shell\openAsAdm" /f /v "HasLUAShield"

::     HKEY_CLASSES_ROOT\Directory\ContextMenus\PowerShell7-previewx64\shell\openpwsh\command
:: and HKEY_CLASSES_ROOT\Directory\ContextMenus\PowerShell7-previewx64\shell\runas\command
:: and
::          Icon        REG_SZ <PATH>
::          MUIVerb     REG_SZ <Label>

reg.exe add "HKEY_CLASSES_ROOT\Directory\ContextMenus\%contextmenuName%\shell\open\command" /f /ve /d "%LocalAppData%\Microsoft\WindowsApps\wt.exe -d ""%%V\\."""
reg.exe add "HKEY_CLASSES_ROOT\Directory\ContextMenus\%contextmenuName%\shell\openAsAdm\command" /f /ve /d "wscript.exe \"%openAdmPath%\wt-admin.vbs\" \"%%V\\.\""


ECHO.
ECHO Done.
pause

:: https://stackoverflow.com/questions/1794547/how-can-i-make-an-are-you-sure-prompt-in-a-windows-batchfile
:END
endlocal