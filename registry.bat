echo OFF
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
   xcopy "%~dp0terminal.ico" "%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\" /b /v /y /q
   set iconPath="\"%%LOCALAPPDATA%%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\terminal.ico\""
   @echo off
)

echo.
echo Enter:
IF /I "%SKIP_COPY%" NEQ "Y" (
   echo.
   set /p iconPath="icon path: "
)
echo.
echo (example) WindowsTerminal
set /p contextmenuName="context menu naming with NO spaces: "
echo.
echo (example) Windows Terminal
set /p contextmenuLabel="context menu label: "
echo.
echo (example) C:\Users\^<USERNAME^>\AppData\Local\Microsoft\WindowsApps\wt.exe
set /p openPath="executable path: "
echo.
echo (example) C:\env\windows_terminal\run.bat
set /p openAdmPath="executable administrator (run.bat) path: "
echo.

:: https://stackoverflow.com/questions/1794547/how-can-i-make-an-are-you-sure-prompt-in-a-windows-batchfile
@echo off
setlocal
:PROMPT
SET /P AREYOUSURE="Are you sure (Y/[N])? "
IF /I "%AREYOUSURE%" NEQ "Y" GOTO END

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

reg.exe add "HKEY_CLASSES_ROOT\Directory\ContextMenus\%contextmenuName%\shell\open\command" /f /ve /d "%openPath% -d ""%%V"""
reg.exe add "HKEY_CLASSES_ROOT\Directory\ContextMenus\%contextmenuName%\shell\openAsAdm\command" /f /ve /d "%openAdmPath%"


ECHO.
ECHO Done.
pause

:: https://stackoverflow.com/questions/1794547/how-can-i-make-an-are-you-sure-prompt-in-a-windows-batchfile
:END
endlocal