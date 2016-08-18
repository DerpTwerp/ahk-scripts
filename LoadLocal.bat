@echo off
echo AutoHotKey Scripts...
echo 	* AutoCorrect...
@start /D"c:\Program Files\AutoHotkey" "c:\Program Files (x86)\AutoHotkeyAutoHotkey.exe" "C:\portables\AHKScripts\AutoCorrect.ahk"

echo 	* Work...
@start /D"c:\Program Files\AutoHotkey" "c:\Program Files (x86)\AutoHotkeyAutoHotkey.exe" "C:\portables\AHKScripts\work.ahk"

echo 	* Mouse Toggler...
@start /D"c:\Program Files\AutoHotkey" "c:\Program Files (x86)\AutoHotkeyAutoHotkey.exe" "C:\portables\AHKScripts\ToggleMouseSpeed.ahk"

IF NOT "%1"=="1" (
	PAUSE
)