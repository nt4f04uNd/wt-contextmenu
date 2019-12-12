# wt-contextmenu

It is a short guide with batch files to add windows terminal to windows context menu

*Thanks to [EmTschi](https://github.com/EmTschi) for giving an [idea](https://github.com/microsoft/terminal/issues/632#issuecomment-539420599)*.
Original solution was found [here](https://github.com/microsoft/terminal/issues/1060)

## Guidance

1. Open `settings.json` and set your terminal starting directory as to be `"startingDirectory": "."`.
For today it is the only way to change starting dir, but in the future some start parameters should appear, so I will probably update it. [Check out](https://github.com/microsoft/terminal/issues/607)
2. (Optional) Create some folder in root directory, so you can easily access it. I created `C:\env\windows_terminal`
3. (Optional, see next clause) Install `nircmd` with `choco install nircmd`
4. Create file in that directory called `run.bat` (or copy it there).
   In that file put the following script

   I wasn't able to hide batch script file window completely to run it from registry. I have tried to use vbs, but it didn't run from registry for some reason, just closed immediately.
   So I just minimized time that cmd window can be seen
   ```bat
   :: This line is optional
   nircmd.exe win hide ititle "cmd.exe" 
   
   :: Run windows terminal as administrator
   powershell -Command "Start-Process shell:appsFolder\Microsoft.WindowsTerminal_8wekyb3d8bbwe!App -Verb RunAs"
   ```

5. Run `registry.bat`

   It will suggest you to copy icon to WT settings dir
   NOTE that is might brake if `_8wekyb3d8bbwe` changes, this brakes, so keep it in your mind

   Then you have to specify:
   * **icon path**
   If answered "y", you can now use that path to access icon
   `%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\terminal.ico`
   * **name** to identify WT in registry

   I used `WindowsTerminal`
   * **label** for context menu

   I used `Windows Terminal` 

   * **path to executable file**

   I tried `%LOCALAPPDATA%\Microsoft\WindowsApps\wt.exe`, but it didn't work for me.
   So I just pasted my full path `C:\Users\UserName\AppData\Local\Microsoft\WindowsApps`

   * **path to bat (or whatever runs wt with admin privileges) file**

   I used `C:\env\windows_terminal\run.bat`

   **Done!**