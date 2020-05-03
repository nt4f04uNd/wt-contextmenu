@echo off

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

setlocal EnableDelayedExpansion
:PROMPT
echo This script will remove WT context menu.
set /P AREYOUSURE="Are you sure (Y/[N])? "
if /I "%AREYOUSURE%" neq "Y" GOTO END

echo.
if exist "%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\terminal.ico" (
    echo Removing icon
    del "%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\terminal.ico"
)

if exist  "C:\env\commands\wt-admin.vbs" (
    echo Removing "C:\env\commands\wt-admin.vbs"
    del "C:\env\commands\wt-admin.vbs"
) else (
   echo.
   echo There's no vbs by path "C:\env\commands".
   echo If you used custom path, delete it by yourself
   echo.
)


reg delete "HKEY_CLASSES_ROOT\Directory\shell\WindowsTerminal" /f
reg delete "HKEY_CLASSES_ROOT\Directory\Background\shell\WindowsTerminal" /f
reg delete "HKEY_CLASSES_ROOT\Directory\ContextMenus\WindowsTerminal" /f

echo.
echo Ended removal
pause
echo.

rem :END
rem endlocal