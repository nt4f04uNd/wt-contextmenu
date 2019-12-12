:: Runs windows terminal as admin
:: TODO when arguments release, add starting work dir

nircmd.exe win hide ititle "cmd.exe"
powershell -Command "Start-Process shell:appsFolder\Microsoft.WindowsTerminal_8wekyb3d8bbwe!App -Verb RunAs"