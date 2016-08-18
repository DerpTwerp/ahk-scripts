#SingleInstance force
#Persistent
SetTitleMatchMode 1
SendMode Input

; $Last Updated: 09-Jun-2011 7:47:21PM John Jimenez $

; !	Alt
; ^	Control
; +	Shift
; #	Win (Windows logo key)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Variables
EnvGet, UserProfile, USERPROFILE

; Kill these buttons!
Launch_Mail:: send {ESC}
Launch_Media::return


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MultiMedia
; Create my own MultiMedia Keyboard
#NumpadAdd::
#Right::
#Up::
#WheelUp::
	Send {Volume_Up}
return
#NumpadSub::
#Down::
#Left::
#WheelDown::
	Send {Volume_Down}
return
#NumpadEnter::
^#NumpadEnter::
^+#RButton::
	Send {Media_Play_Pause}
return
^#Left::
^+#WheelDown::
	Send {Media_Prev}
return
^#Right::
+^#WheelUp::
	Send {Media_Next}
return


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; GLobal Hot Keys


!^+#c:: send 4111111111111111 ; Send Dummy Visa number
#c:: Send, {F2}^{c}{ESC} ; Attempt to copy a selected file's name;

^+#e::edit ; Edit the script!

!^+F:: ; Run Fiddler
if FileExist("C:\Program Files\Fiddler2\Fiddler.exe")
	Run "C:\Program Files\Fiddler2\Fiddler.exe"
return

!^+#i:: run control inetcpl.cpl ; Launch Internet Settings.

!^#L:: run E:\portableApps\Misc\caffeine\caffeine.exe -appexit ; Kill Caffeine (allows the system to sleep/idle)
^#L:: run E:\portableApps\Misc\caffeine\caffeine.exe -replace -activefor:5 ; Prevent Sleep/Idle for 5 minutes

^#n:: Send John Jimenez ; My name
+#n::run c:\windows\notepad.exe ; Load Notepad
#n:: send 770.433.8211 x83788 ; My Phone Number

!^+O::Send {#}E6781E ; Home Depot Specific: Orange in Hex!

!^+r:: run TortoiseProc.exe /command:repobrowser ; Load SVN Repo Browser
^+#r:: ; Reload this script
	Traytip, Reloading Script..., %A_ScriptName%
	sleep 1000
	reload
return

; Load the SVN Environments as root levels in explorer
^#s::Run %A_WinDir%\explorer.exe /e`,/root`,Y:\hdonline_staticweb
#s::Run %A_WinDir%\explorer.exe /e`,/root`,y:\

#x:: ; Windows to Unix Slashes in Clipboard
	StringReplace, clipboard, clipboard, \, /, All
	ToolTip, Replaced Windows Slashes with Unix Slashes
	SetTimer, RemoveToolTip, 750
Return


!^+#z:: ; Copy all open explorer windows to CB
	MyVar:= ""
	WinGet, id, list, , , Program Manager
	Loop, %id%
	{
		StringTrimRight, this_id, id%a_index%, 0
		WinGetTitle, title, ahk_id %this_id%
		WinGet, id_min, ID, ahk_id %this_id%
		WinGet, minim , MinMax, ahk_id %this_id%

		winget processname,processname, ahk_id %this_id%
		WinGetClass class , ahk_id %this_id%

		if ( processname = "explorer.exe" and class = "CabinetWClass" ) 
		{
			thisTitle:= ""
			WinGetText, windowText, ahk_id %this_id%
			Loop, parse, windowText, `n`r
			{
				thisTitle = %A_LoopField%
				break
			}

			IF RegExMatch( thisTitle, "i)^([a-z]:)|(\\)")
			{
				IF %MyVar% {
					MyVar =%MyVar%`n
				}
				MyVar = %MyVar%%thisTitle%
			}
		}
	}

	IF %MyVar%
	{
		Sort MyVar, CL D`n
		tooltip `n`n             Open Explorer Windows have been saved to Clipboard!             `n`n
		SetTimer, RemoveToolTip, 1000
		clipboard = %MyVar%
		
	}
return

#z:: ; Unix to Windows Slashes in Clipboard
	StringReplace, clipboard, clipboard, /, \, All
	ToolTip, Replaced Unix Slashes with Windows Slashes
	SetTimer, RemoveToolTip, 750
Return

; Press both crtl buttons to open control panel.
^RCtrl::run Control Panel


; Use IrfanView for screen shot.
^PrintScreen::
	irfanViewPath = "%A_ProgramFiles%\IrfanView\i_view32.exe"
	FilePath = %UserProfile%\My Documents\AHKScreenshots
	; if there is not already a folder c:\screenshot create one
	ifnotexist, %FilePath%
	{
		fileCreateDir, %FilePath%
	}
	adjust(zeit)
	; /capture=0 takes a screenshot of the whole desktop
	; /capture=1 takes a screenshot of the active window
	; /capture=2 takes a screenshot of the client area of the active window
	Run, %irfanViewPath% /capture=2 /convert="%FilePath%\capture_%Zeit%.png"
	sleep, 500
	Run, "%FilePath%\capture_%Zeit%.png"
return
#PrintScreen::
	irfanViewPath = "%A_ProgramFiles%\IrfanView\i_view32.exe"
	FilePath = %UserProfile%\My Documents\AHKScreenshots
	; if there is not already a folder c:\screenshot create one
	ifnotexist, %FilePath%
	{
		fileCreateDir, %FilePath%
	}
	adjust(zeit)
	; /capture=0 takes a screenshot of the whole desktop
	; /capture=1 takes a screenshot of the active window
	; /capture=2 takes a screenshot of the client area of the active window
	Run, %irfanViewPath% /capture=1 /convert="%FilePath%\capture_%Zeit%.png"
	sleep, 500
	Run, "%FilePath%\capture_%Zeit%.png"
return


#ifWinActive ahk_class CabinetWClass
{
	; Creat a new Folder in Explorer window
	f7:: Send, {APPSKEY}{UP  2}{RIGHT 2}{ENTER}
	; Display Folder Bar
	#a::
		Send !v
		sleep 50
		Send e
		sleep 50
		send o
	return
	; New Explorer, Current as Root with Folder view.
	^+#!e::
		WinGetActiveTitle, pth
		cmd = explorer /e,/n,/root,"%pth%"
		run, %cmd%, %pth%
	return
	; TortoiseSVN Update

	#u::
		WinGetActiveTitle, pth
		cmd = c:\program files\TortoiseSVN\bin\TortoiseProc.exe /command:update /path:"%pth%" /notempfile /closeonend:2
		run, %cmd%, %pth%
	Return 
return
}

#ifWinActive ahk_class WorkerW
{
	; Creat a new Folder in Explorer window
	f7:: Send, {APPSKEY}{UP  2}{RIGHT 2}{ENTER}
	; Display Fodler Bar
	#a::
		Send !v
		sleep 50
		Send e
		sleep 50
		send o
	return
	; New Explorer, Current as Root with Folder view.
	^+#!e::
		WinGetActiveTitle, pth
		cmd = explorer /e,/n,/root,"%pth%"
		run, %cmd%, %pth%
	return

	; TortoiseSVN Update
	#u::
	   WinGetActiveTitle, pth
	   cmd = c:\program files\TortoiseSVN\bin\TortoiseProc.exe /command:update /path:"%pth%" /notempfile /closeonend:2
	   run, %cmd%, %pth%
	Return 
return
}
#ifWinActive ahk_class Progman
{
	; Creat a new Folder in Explorer window
	f7:: Send, {APPSKEY}{UP  2}{RIGHT 2}{ENTER}
	; Display Fodler Bar
	#a::
		Send !v
		sleep 50
		Send e
		sleep 50
		send o
	return
	; New Explorer, Current as Root with Folder view.
	^+#!e::
		WinGetActiveTitle, pth
		cmd = explorer /e,/n,/root,"%pth%"
		run, %cmd%, %pth%
	return
	; TortoiseSVN Update
	#u::
	   WinGetActiveTitle, pth
	   cmd = c:\program files\TortoiseSVN\bin\TortoiseProc.exe /command:update /path:"%pth%" /notempfile /closeonend:2
	   run, %cmd%, %pth%
	Return 
return
}
#ifWinActive ahk_class ExploreWClass
{
	; Creat a new Folder in Explorer window
	f7:: Send, {APPSKEY}{UP  2}{RIGHT 2}{ENTER}
	; Display Fodler Bar
	#a::
		Send !v
		sleep 50
		Send e
		sleep 50
		send o
	return
	; New Explorer, Current as Root with Folder view.
	^+#!e::
		WinGetActiveTitle, pth
		cmd = explorer /e,/n,/root,"%pth%"
		run, %cmd%, %pth%
	return
	; TortoiseSVN Update
	#u::
	   WinGetActiveTitle, pth
	   cmd = c:\program files\TortoiseSVN\bin\TortoiseProc.exe /command:update /path:"%pth%" /notempfile /closeonend:2
	   run, %cmd%, %pth%
	Return 
return
}

#ifWinActive ahk_class #32770
{
	; Creat a new Folder in Explorer window
	f7:: Send, {APPSKEY}{UP  2}{RIGHT 2}{ENTER}
return
}


; Firefox!
#ifWinActive Firefox
{
	#c::
		send +^{delete}
		sleep 500
		send {enter}
		sleep 500
		send ^r
	return
return
}

; Coding Strings (will only work in EditPlus)
#ifWinActive EditPlus
{

	; - John Jimenez CTRL+D (11:05:34)
	#j:: send ^m ^d John Jimenez
	; - Copy Remote File name to cb
	^+#c::
		send !^+s
		sleep, 250
		send ^c {esc}
	return

	; - Copy Local File name to cb
	^+#x::
		WinGetText, windowText, A
		Loop, parse, windowText, `n`r
		{
			clipboard = %A_LoopField%
			break
		}
		StringReplace, clipboard, clipboard, %A_SPACE%*, , All  
		ToolTip, Copied Path to Clipboard
		SetTimer, RemoveToolTip, 500
	return


	; Shared PHP & JavaScript Structures
	; switch
	:b0O:switch (::) {{}{enter}case:{enter}break{;}{enter}default:{enter}break{;}{enter}{backspace}{}}{UP 5}{End}{Left 3}
	:b0O:switch(::) {{}{enter}case:{enter}break{;}{enter}default:{enter}break{;}{enter}{backspace}{}}{UP 5}{End}{Left 3}

	; if, ifelse, else
	:*b0:if ():: {{}{enter}{}}{up}{end}{left 2}
	:*b0:elseif ():: {{}{enter}{}}{up}{end}{left 2}
	:*b0:else {::{enter}{space}{backspace}{enter}{}}{up}{end}
	:O:ifelse::if () {{}}{enter}{tab}{enter}{backspace}{}} else {{}{enter}{tab}{enter}{backspace}{}}{up 4}{end}{left 3}

	; For loop
	:O:mkfl::for ({;}{;}) {{}{enter}{tab}{Backspace}{enter}{Backspace}{}}{up 2}{end}{left 5}

	; While Loop
	:O:mkwl::while () {{}{enter}{tab}{Backspace}{enter}{Backspace}{}}{up 2}{end}{left 3}

	; General function
	:O:newfunc::function () {{}{enter}{tab}{Backspace}{enter}{Backspace}{}}{up 2}{end}{left 4}
	:*O:af+::function(){{}{}}{left}

	; Some CSS
	::fl:l::float: left
	::fl:n::float: none
	::fl:r::float: right
	::ta:r::text-align: right
	::ta:l::text-align: left
	::ta:c::text-align: center
	:O:bg:n::background: transparent none;{left 6}+{left 11}
	:O:fs::font-size:{space}
	:O:fw::font-weight:{space}
	:O:fwb::font-weight: bold;
	:O:fwn::font-weight: normal;

	; HTML

	; - <div>
	!^+d:: send <div id="" class=""></div>{left 6}
	
	; send "clearfix"
	^!c::Send clearfix

	; &gt;
	^+.::Send &gt{;}
	; &lt;
	^+,::Send &lt{;}

	;  target="_blank"
	^+!t::Send  target="_blank"

	; /*jj-ta*/
	^+t::send /*jj-ta*/

	; <style = Complete Style Tag
	:*b0:<style:: type="text/css">{Enter}{TAB}{Backspace}{Enter}{Backspace}</style>{UP}{End}

	; m-r = meta refresh tag
	:O:m-r::<meta http-equiv="refresh" content="0;url=">{left 2}

	+^#h:: send <hr />{enter}

	+^#i::
		ClipSaved := ClipboardAll
		Clipboard :=
		Send ^x
		Sleep 200
		send <li>%Clipboard%</li>
		Clipboard := ClipSaved
		ClipSaved =
	return

	!+c::
		ClipSaved := ClipboardAll
		Clipboard :=
		Send ^x
		send /* ^v */{left 3}
		sleep 150
		Clipboard := ClipSaved
		ClipSaved =
	return

	; IE7 Hack
	:O:ie7h::*:first-child{+}html  {{}{enter}{tab}{Backspace}{}}{up}{end}{left 2}

	; jdready = document.ready
	+^`:: send $(document).ready(function(){{}{}}){;}{left 3}{enter}{enter}{up}{tab}
	; jwload = document.ready
	+!`:: send $(window).load(function(){{}{}}){;}{left 3}{enter}{enter}{up}{tab}

	; Remote Style Sheet
	:O*:rstyle::<link rel="stylesheet" type="text/css" media="all" href=""/>{left 3}
	; Remote Script Sheet
	:O*:rscript::<script type="text/javascript" src=""></script>{left 11}

	; Mac Safari/Google Chrome Hack
	:O:machack::/* Google Chrome/ MAC Safari Hack */{enter}@media screen and (-webkit-min-device-pixel-ratio:0) {{}{enter}{tab}{enter}{}}{up}{End}

	; Misc Tag Speeders
	:O:lia::<li><a href=""></a></li>{left 9}
	:Ob0:<img:: src="" />{Left 4}
	:*b0:<ul::>{Enter}{Tab}<li></li>{enter}{backspace}</ul>{up}{end}{left 5}
	:*b0:<li::></li>{left 5}
	:*b0:<a href::=""></a>{left 4}

	; <script Complete JS Script
	:*b0:<script:: type="text/javascript">{Enter}{TAB}{Enter}{Backspace}</script>{UP}{End}

	:O:ie8meta::<meta http-equiv="X-UA-Compatible" content="IE=8" />
	:O:ie7meta::<meta http-equiv="X-UA-Compatible" content="IE=7" />
	:O:idiv::<div id=""></div>{left 8}
	:O:cdiv::<div class=""></div>{left 8}
	:O:ispan::<span id=""></span>{left 9}
	:O:cspan::<span class=""></span>{left 9}

	!^+i:: send <{!}--{#}include virtual=""-->{left 4}
	!^+c:: send <div class="clear"></div>

	#u::
		send $
		send Last Update: $
	return

	; New Blank HTML Doc
	+^#n::
		Send +^n
		sleep 50
		Send !^+{p}
		sleep 50
		Send {home}{down 3}{enter}
	return

	; Make lowercase AND replace spaces with _
	+^#l::
		StringReplace, clipboard, clipboard, %A_Space%, _, All
		StringLower, clipboard, clipboard
		ToolTip, Lowercased and Underscored!
		SetTimer, RemoveToolTip, 500
	Return

	+^!NumPadAdd::Send {home}{= 80}{enter 2}{= 80}{enter}{up 2}

	^!d::Send if (GLOBAL_FED_DEBUG) {{} console.log(''){;} {}}{left 5}

} ; End Editplus Window Check

; Break out of the window Mode!
#IfWinActive

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Support!
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RemoveToolTip:
SetTimer, RemoveToolTip, Off
ToolTip
return

adjust(ByRef zeit)
{
	formattime,zeit,A_now,dd.MM.yy_HH-mm-ss
	return
}
