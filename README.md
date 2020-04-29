# wt-contextmenu

Run Windows Terminal from the context menu

*Thanks to [EmTschi](https://github.com/EmTschi) for giving an [idea](https://github.com/microsoft/terminal/issues/632#issuecomment-539420599)*.
Original solution was found [here](https://github.com/microsoft/terminal/issues/1060)

![Gif demo](/demo.gif)

## Usage

1. In right click context-menu
2. Run `wt-admin` command in cmd/powershell.

## Installation

Run `registry.bat` as Admin

It will suggest you to copy icon to WT settings dir

NOTE that `_8wekyb3d8bbwe` may change, so keep it mind

Specify:
* **icon path**
If answered "y", you can now use that path to access icon
`%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\terminal.ico`
* **name** to identify WT in registry (`WindowsTerminal`)
* **label** for context menu (by default `Windows Terminal`)
* **path to wt-admin.vbs** full path where you want ro preserve `wt-admin.vbs`, (by default `C:\env\commands`), I also recommend you to add it to PATH variable to access it from cmd/powershell

**Done!**

P.S. If you have something not working - try to run `registry.bat` again and avoid any spaces before and after paths.
