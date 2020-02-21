:: Runs windows terminal as admin

nircmd.exe win hide ititle "cmd.exe"
powershell -Command "Start-Process cmd -Verb RunAs -ArgumentList '/c start wt -d %CD%'"