#Include %A_Scriptdir%\TrayIcon.ahk

#SingleInstance force
#Persistent
#InstallKeybdHook
SetTitleMatchMode RegEx
SendMode Input
SetWorkingDir, %A_ScriptDir%
DetectHiddenWindows, On


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Auto Reloader
; Reloads the script automatically on safe
SetTimer, ReloadScriptIfChanged, 4000

; 03/22/2012 Added to Mercurial repo

; !	Alt
; ^	Control
; +	Shift
; #	Win (Windows logo key)

; Setup your Explorer Windows!
GroupAdd, explorerWins, ahk_class CabinetWClass ; Explorer
GroupAdd, explorerWins, ahk_class WorkerW 
GroupAdd, explorerWins, ahk_class Progman ; Desktop
GroupAdd, explorerWins, ahk_class ExploreWClass ; Explorer /e
GroupAdd, explorerWins, ahk_class #32770 ; File > Open Dialog

; Group of Firefox Windows
GroupAdd, firefoxWins, ahk_class MozillaUIWindowClass ; Firefox
GroupAdd, firefoxWins, i)^Firefox ahk_class MozillaWindowClass ; Firefox 8+

; Set up some browser Windows!
GroupAdd, browserWins, ahk_class IEFrame ; Internet Explorer
GroupAdd, browserWins, ahk_group firefoxWins ; Firefox
GroupAdd, browserWins, ahk_class Chrome_WidgetWin_0 ; Google Chrome

; Short Hand Notepad++
GroupAdd, nppWins, i)- notepad\+\+ ahk_class Notepad++ ; Notepad++

; Short Hand PHPStorm
GroupAdd, phpStormWin, i)PhpStorm [0-9\. ]+$ ahk_class SunAwtFrame ; PHPStorm 10.0.3
;GroupAdd, phpStormWin, i)Settings$ ahk_class SunAwtFrame ; PHPStorm Settings
GroupAdd, phpStormWin, ahk_class SunAwtDialog

; Short Hand Komodo IDE
GroupAdd, komodoWin, i)ActiveState Komodo IDE [0-9\.]+$ ahk_class MozillaWindowClass ; Komodo IDE 7.0

; Group of Editor Windows
GroupAdd, editorWins, ^EditPlus ; EditPlus 3
GroupAdd, editorWins, ahk_group komodoWin
GroupAdd, editorWins, ahk_group nppWins
GroupAdd, editorWins, ahk_group phpStormWin
;GroupAdd, editorWins, i)ActiveState Komodo IDE [0-9\.]+$ ahk_class MozillaWindowClass ; Komodo IDE 7.0


; Group of HP Quality Center Windows
GroupAdd, HPQC, i)HP Quality Center

; Group to ignore the FKeys (helps prevent issues with Caffine)
GroupAdd, ignoreFkeys, ahk_class PuTTY
GroupAdd, ignoreFkeys, ahk_class IMWindowClass ; Communicator IM window
GroupAdd, ignoreFkeys, ahk_class mintty

; TortoiseHG Windows
GroupAdd, hgWindows, i)TortoiseHg Workbench ahk_class QWidget ; TortoiseHg Workbench
GroupAdd, hgWindows, i)commit ahk_class QWidget ; TortoiseHg Commit Window



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Variables
EnvGet, UserProfile, USERPROFILE
irfanViewPath = "%A_ProgramFiles%\IrfanView\i_view32.exe"
ScreenShotDir = %UserProfile%\My Documents\AHKScreenshots
localWorkPath = c:\w\active work\hdc_central_repo
remoteWorkPath = /opt/hd/hdc/u1/jxj4280/repo2/
localWorkPathBlinds = c:\w\active work\blinds\
remoteWorkPathBlinds = /opt/hd/hdc/u1/jxj4280/blinds/
defaultTTDur = 3000
myIni = work.ini
mySoundDir = .\sounds\

; Read Ini File
IniRead, EnableMediaKeys, %myIni%, globals, EnableMediaKeys, 1

; Write the default values to ini if it does not exist
if NOT FileExist("%myIni%")
{
	IniWrite, %EnableMediaKeys%, %myIni%, globals, EnableMediaKeys ; Write the ini file in case it doesn't exist
}

; Turn CapsLock Off.
SetCapsLockState, AlwaysOff
; Turn ScrollLock Off.
SetScrollLockState, AlwaysOff
; Turn on Numlock.
;SetNumLockState, AlwaysOn ; Was causing issues in Virtual PC
; Turn Off Insert Button
$Insert::return
!Insert::Send, {Insert} ; Use Alt+Insert to toggle the 'Insert mode'

; Kill these buttons!
Launch_Mail:: send {ESC}
Launch_Media::
Browser_Forward::
Browser_Back::
Browser_Home::
CapsLock::
return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MultiMedia
; Create my own MultiMedia Keyboard
#F1:: toggleMediaKeys()
#F2:: checkMediaKeysStatus()

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

^#LButton::
^#Left::
^+#WheelDown::
!^+WheelDown::
$Media_Prev::
	if ( EnableMediaKeys )
	{
		Send {Media_Prev}
	}
	else
	{
		ToolTip, Media Keys are Disabled
		playSound("error")
		SetTimer, RemoveToolTip, 750
	}
	SetTimer, RemoveToolTip, 750
return

^#RButton::
^#Right::
^+#WheelUp::
!^+WheelUp:: Send {Media_Next}
$Media_Next::
	if ( EnableMediaKeys )
	{
		SendInput {Media_Next}
	}
	else
	{
		ToolTip, Media Keys are Disabled
		playSound("error")
		SetTimer, RemoveToolTip, 750
	}
	SetTimer, RemoveToolTip, 750
return


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Global Hot Keys

^+#Return:: Suspend ; Toggle Suspend

; Remap Win7's #1, #2, & #3 back to my WinAmp Keys.
#1:: send #{tab} ; Show / Hide Winamp
#2:: send #`` ; Show the Toaster Notification
#3:: send {Media_Play_Pause} ; Play/Pause
#4:: send {Media_Prev} ; Play/Pause
#5:: send {Media_Next} ; Play/Pause

; Send Middle click
!^+LButton:: Click Middle


; QuickDebugger, Should be deleted
!^+#a::
	MouseGetPos, , , id, control
	WinGetTitle, title, ahk_id %id%
	WinGetClass, class, ahk_id %id%
	theMsg = `n`tahk_id %id%`t`n`tahk_class %class%`t`n`t%title%`t`n`tControl: %control%`n`t`n
	TimedToolTip(theMsg, 5000)
return

#b:: send 770-826-5042

; Send Dummy Visa number
!#c:: send 4{1 15}


; Toggle Remote and Local path with Clipboard text
!^#c::
	;StringLower, cb, ClipBoard
	cb := Clipboard
	theMsg := ""

	if InStr(cb,localWorkPath)
	{
		theMsg :="Removing local path"
		StringReplace, cb, cb, %localWorkPath%, 
		StringReplace, cb, cb, \, /, All
		Clipboard := cb
	}
	;else if InStr(cb,remoteWorkPath)
	;{
	;	theMsg :="Replacing remote path with local path"
	;	StringReplace, cb, cb, %remoteWorkPath%, %localWorkPath%
	;	StringReplace, cb, cb, /, \, All
	;	Clipboard := cb
	;}
	;else if InStr(cb, localWorkPathBlinds)
	;{
		;theMsg :="Replacing local path with remote path"
		;StringReplace, cb, cb, %localWorkPathBlinds%, %remoteWorkPathBlinds%
		;StringReplace, cb, cb, \, /, All
		;Clipboard := cb
	;}
	;else if InStr(cb, remoteWorkPathBlinds)
	;{
		;theMsg :="Replacing remote path with local path"
		;StringReplace, cb, cb, %remoteWorkPathBlinds%, %localWorkPathBlinds%
		;StringReplace, cb, cb, /, \, All
		;Clipboard := cb
	;}
	else
	{
		theMsg :="No path found to toggle"
	}
	TimedToolTip(theMsg, defaultTTDur)
return

; Open Desktop in explorer.
^+#D::
	ifWinExist Desktop
	{
		WinActivate Desktop
	}
	else 
	{
		run, explorer.exe /e`,/root`,"%UserProfile%\desktop"
	}
return

^+#e::edit ; Edit this script!

!^+F:: ; Run Fiddler
if FileExist("C:\Program Files (x86)\Fiddler2\Fiddler.exe")
	TimedToolTip("Starting Fiddler", 3000)
	Run "C:\Program Files (x86)\Fiddler2\Fiddler.exe"
return

!^+#i:: run control inetcpl.cpl ; Launch Internet Settings.

!^+j:: send jxj4280 ; Send my ldap

; Lowercase Clipboard
+#l::
	myTemp := clipboard
	StringLower, clipboard, clipboard
	ToolTip, Lowercased %myTemp%
	myTemp:=""
	SetTimer, RemoveToolTip, 750
	return

;UpperCase Clipboard
+#u::
	myTemp := Clipboard
	StringUpper Clipboard, Clipboard
	ToolTip, Uppercased %myTemp%
	myTemp:=""
	SetTimer, RemoveToolTip, 750
	return

;Title Case Clipboard
+#t::
	myTemp := Clipboard
	StringUpper Clipboard, Clipboard, T
	ToolTip, Title-Cased %myTemp%
	myTemp:=""
	SetTimer, RemoveToolTip, 750
	return

;!#L::run E:\portableApps\Misc\caffeine\caffeine.exe -replace ; Prevent Sleep/Idle
;!^+#L::run E:\portableApps\Misc\caffeine\caffeine.exe -replace -activefor:20 ; Prevent Sleep/Idle for 20 minutes
;!^#L:: run E:\portableApps\Misc\caffeine\caffeine.exe -appexit ; Kill Caffeine (allows the system to sleep/idle)
;^#L:: run E:\portableApps\Misc\caffeine\caffeine.exe -replace -activefor:5 ; Prevent Sleep/Idle for 5 minutes

^#n:: Send John Jimenez ; My name
+#n::run c:\windows\notepad.exe ; Load Notepad
#n:: send 28091 ; My Phone Number
^+#n:: Send 770-826-5042

;^#p currently used in HDC Section

;!^+r:: run TortoiseProc.exe /command:repobrowser ; Load SVN Repo Browser

^+#r:: ; Reload this script
	Traytip, Reloading Script..., %A_ScriptName%
	Sleep, 1000
	reload
return

; Run the TortoiseHg WorkBench
^+#w::
	IfWinNotExist TortoiseHg Workbench
	{
		run C:\Program Files\TortoiseHg\thgw.exe --nofork workbench -R "C:\w\ACTIVE WORK\hdc_central_repo"
	}
	else
	{
		WinActivate, TortoiseHg Workbench
		return
	}
return

#x:: ; Windows to Unix Slashes in Clipboard
	StringReplace, clipboard, clipboard, \, /, All
	ToolTip, Replaced Windows Slashes with Unix Slashes
	SetTimer, RemoveToolTip, 750
Return

#y:: ; Fix YouTube Embed links in clipboard to Secure full URLs
	cb := ClipBoard
	StringReplace, cb, cb, http://, https://
	cb := RegExReplace(cb,"i)embed/(.*)","watch?v=$1")
	cb := RegExReplace(cb,"i)\/v\/([^\?]*)(\?.*)*","/watch?v=$1")
	Clipboard:= cb
return

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
				StringReplace, thisTitle, thisTitle, Address:%A_SPACE%, , All
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
^PrintScreen:: takeScreenShot(2) ; screenshot of the client area of the active window 
#PrintScreen:: takeScreenShot(1) ; screenshot of the active window (includes taskbar)

#ifWinActive ahk_group explorerWins
	!^+f1::
		WinGetClass, this_class , A
		ToolTip, explorerWins window active "%this_class%"
		SetTimer, RemoveToolTip, 750
	return

	; Kill the Help
	f1::return

	; Creat a new Folder in Explorer window
	;f7:: Send, {APPSKEY}{UP  4}{RIGHT 2}{ENTER}
	f7::
		Send {APPSKEY}
		sleep 100
		Send w
		Sleep 100 
		Send f
	return

	; New Explorer, Current as Root with Folder view.
	; Appears broken in Win 7
;	!^+#e::
;		WinGetActiveTitle, pth
;		cmd = explorer /e,/n,/root,"%pth%"
;		run, %cmd%, %pth%
;	return

	; Display Folder Bar
	#a::
		Send !v
		Sleep, 50
		Send e
		Sleep, 50
		send o
	return

	#c:: ; Copies selected icon's file name to cb
		Send {F2}^{end}^+{home}^{c}{ESC} ; Attempt to copy a selected file's name;
		return

	; copies file's path & filename to the cb
	+#c:: Clipboard = % gst()

	; crtl+l focuses the location bar in explorer
	^l::SendInput !d

	; TortoiseSVN Update
	;+#u:: ; Keep Window Open
	;	WinGetActiveTitle, pth
	;	cmd = c:\program files\TortoiseSVN\bin\TortoiseProc.exe /command:update /path:"%pth%" /notempfile /closeonend:0
	;	run, %cmd%, %pth%
	;Return 
	;#u:: ; Close Window
	;	WinGetActiveTitle, pth
	;	cmd = c:\program files\TortoiseSVN\bin\TortoiseProc.exe /command:update /path:"%pth%" /notempfile /closeonend:2
	;	run, %cmd%, %pth%
	;Return 

; Outlook
#ifWinActive ahk_class rctrl_renwnd32
	; prevent select all by accident
	^a:: return
	; Remapped select all
	+^a:: Send ^a

; Browsers
#ifWinActive ahk_group browserWins
	#F11::
		theMsg = Browser Window!
		TimedToolTip(theMsg, 1000)
		return
	+#c::
	!^+c::
	+#d:: ; Added because I kept hitting it.
		; Firefox
		IfWinActive, ahk_group firefoxWins
		{
			Tooltip, Clearing Cookies & Cache in Firefox.
			filterCookies()
			Sleep, 500
			send ^+{end}
			send {delete}
			send {tab}
			Sleep, 1000
			Send {esc}
			Sleep, 250
			clearBrowserCache()
			SetTimer, RemoveToolTip, 750

		}
	return

	#c:: clearBrowserCache()

	^+#c:: ; Firefox
		IfWinActive, ahk_group firefoxWins
		{
			filterCookies()
		}
	return

	!^+h:: Send HACKED" onmouseover="prompt('Boo','')"

; Specifically Work Firefox Window.
;#ifWinActive ahk_group firefoxWins
;	^+f:: ; Show/hide the form details. Expects "More Tools" & "Web Developer"
;		send !m
;		sleep 200
;		send w
;		sleep 200
;		send f
;		sleep 200
;		send d
;	return


; Coding Strings (will only work in EditPlus)
#ifWinActive EditPlus
;#ifWinActive ahk_group editorWins

	; Hot keys
	; Hot keys - General
	^+#c:: ; - Copy Remote File name to cb
	#c::
		send !^+s
		sleep, 350
		send ^c {esc}
	return

	;#j:: send ^m ^d John Jimenez ; - John Jimenez CTRL+D (11:05:34)

	
	;^+#l:: ; Make lowercase AND replace spaces with _
	;	StringReplace, clipboard, clipboard, %A_Space%, _, All
	;	StringLower, clipboard, clipboard
	;	ToolTip, Lowercased and Underscored!
	;	SetTimer, RemoveToolTip, 500
	;Return
	
	^+#n:: ; New Blank HTML Doc
		Send +^n
		Sleep, 50
		Send !^+{p}
		Sleep, 50
		Send {home}{down 3}{enter}
	return

	; Enable "Before Save" usertool, save, & disable "before save" usertool
	^+#s::
		send !^+e
		send ^s
		send !^+e
	return

	; Print the "Last Update" token that gets parsed by the "Before Save" usertool.
	;#u::
	;	send $
	;	send Last Update: $
	;return

	; - Copy Local File name (with path) to cb
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

	; Makes a box;
	!+^NumPadAdd::Send {home}{= 80}{enter 2}{= 80}{enter}{up 2}


	; Hot keys - Code Related
	; Hot keys - Code Related - HTML
	!^c::Send clearfix ; clearfix
	!^+c:: send <div class="clear"></div>
	;!^+d:: send <div id="" class=""></div>{left 6} ; - <div id="" class=""></div>
	!^+i:: send <{!}--{#}include virtual=""-->{left 4}
	+^#i:: ; <li>%Selected Text%</li>
		ClipSaved := ClipboardAll
		Clipboard :=
		Send ^x
		Sleep, 200
		send <li>%Clipboard%</li>
		Clipboard := ClipSaved
		ClipSaved =
	return
	!+P::send  "":"",{left 5}
	;!^+t::Send  target="_blank" ;  target="_blank"
	^+.::Send &gt{;} ; &gt; HTML Greater than
	^+,::Send &lt{;} ; &lt; HTML Less than


	; Hot keys - Code Related - Shared
	!+c:: ; CSS & JavaScript Comment. Only use for multiLine in Javascript.
		ClipSaved := ClipboardAll
		Clipboard :=
		Send ^x
		send /* ^v */{left 3}
		Sleep, 150
		Clipboard := ClipSaved
		ClipSaved =
	return

	#w::
		send !+i
		send !+o
		send !+l
	return

	; Hot keys - Code Related - jQuery
	; $(window).load()
	!+`:: send $(window).load(function () {{}{}}){;}{left 3}{enter}{enter}{up}{tab}
	; $(document).ready
	^+`:: send $(document).ready(function () {{}{}}){;}{left 3}{enter}{enter}{up}{tab}

	;Hot Keys - Code Related - Javascript
	; Javascript closure
	!+#NumpadAdd:: send {;}(function(window, undefined){{}{enter 2}{}})(window){;}{up}{tab}
	; Quick Text Tokens

	; Shared PHP & JavaScript Structures
	; switch
	:b0O:switch (::) {{}{enter}case '':{enter}{tab}break{;}{enter}{backspace}default:{enter}{tab}break{;}{enter}{backspace}{}}{UP 5}{End}{Left 3}
	:b0O:switch(::) {{}{enter}case '':{enter}{tab}break{;}{enter}{backspace}default:{enter}{tab}break{;}{enter}{backspace}{}}{UP 5}{End}{Left 3}

	; if, ifelse, else
	:*b0:if ():: {{}{enter}{}}{up}{end}{left 2}
	:*b0:elseif ():: {{}{enter}{}}{up}{end}{left 2}
	:*b0:else {::{enter}{space}{backspace}{enter}{}}{up}{end}
	:O:ifelse::if () {{}}{enter}{tab}{enter}{backspace}{}} else {{}{enter}{tab}{enter}{backspace}{}}{up 4}{end}{left 3}


	; Try/Catch
	:*O:tc+::try {{}{enter}{tab}{Backspace}{enter}{}} catch (e){{}{enter}{tab}{Backspace}{enter}{}}{up 3}{end}

	; jQuery CDN
	:*O:cdnjq::http://code.jquery.com/jquery-latest.min.js

;; END EDITPLUS

#ifWinActive ahk_group phpStormWin
	f15:: return
	#F12::
		theMsg = PHPStorm Window!
		TimedToolTip(theMsg, 1000)
		return
		
; END phpStormWin

; Komodo IDE
#ifWinActive ahk_group komodoWin ahk_group phpStormWin

	#F12::
		theMsg = Komodo Window!
		TimedToolTip(theMsg, 1000)
		return
		
	; Hot Keys
	; Hot Keys - General

	^+Space::send &nbsp;

	; Wrap the selected text in an <a> tag
	^+a::
		theText = % gst()
		StringLen, goBack, theText
		goBack := goBack+6
		Send <a href="">
		SendRaw %theText%
		send </a>{left %goBack%}
	return

	; Wrap Selected text in HTML comments
	^+c::
		theText = % gst()
		Send <{!}--{space}
		SendRaw %theText%
		send {space}-->{left 4}
	return

	; Copy Remote File name (with path) to cb
	; Customized for HDC
	^+#c::
		sleep 200
		Send !^+x
		sleep 100
		StringReplace, clipboard, clipboard, sftp://HDC AD, , All
	return

	; - Copy Local File name to cb
	#c:: Send !^+{F12}

	!#p::Send, /**`n`n*/{up}{end}{space}
	^#p::Send, /**`n [short description]`n`n* [long description]`n`n*/{up 4}{end}+{left 19}
	!^#p::Send, /**`n`n* @access`n@param`n@return`n{backspace}/{up 4}{end}{space}


	; - Copy Local File name (with path) to cb
	; Supported in the editor, Set to Alt+Ctrl+Shift+X
	^+#x::
		sleep 200
		Send !^+x
	return

	;Hot Keys - Code Related - PHP
	^+Return::Send <br />

	; Quick Text Tokens

	; Shared PHP & JavaScript Structures
	; switch
	:b0O:switch (::) {{}{}}{left}{enter}case '':{enter}break{;}{enter}default:{enter}break{;}{UP 4}{End}{Left 3}
	:b0O:switch(::) {{}{}}{left}{enter}case '':{enter}break{;}{enter}default:{enter}break{;}{UP 4}{End}{Left 3}

	; if, ifelse, else
	:*b0:if ():: {{}{}}{left}{enter}{up}{end}{left 3}
	:*b0:if():: {left 3}{space}{right 3}{{}{}}{left}{enter}{up}{end}{left 3}
	:*b0:elseif ():: {{}{}}{left}{enter}{up}{end}{left 3}
	:*b0:else {::{}}{left}{enter}
	:O:ifelse::if () {{}{}}{left}{enter}{down}{end} else {{}{}}{left}{enter}{up 3}{end}{left 3}

	; Try/Catch
	:*O:tc+::try {{}{}}{left}{enter}{down}{end} catch (e){{}{}}{left}{enter}{up 2}{end}

	; HTML
	:*b0:<ul::>{Enter}<li></li>{enter}{backspace}</ul>{up}{end}{left 5}
	:*b0:<script:: type="text/javascript">{Enter}{Enter}{Backspace}</script>{UP}{End}
;; End Komodo IDE

; Shared between EditPlus and Komodo
#IfWinActive ahk_group editorWins
	#F11::
		theMsg = Editor Window!
		TimedToolTip(theMsg, 1000)
		return



	; Hot keys
	; Hot keys - General
	^+j:: send <script src="//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>

	#s:: send $string.= "\n"{;}{left 4}



	!+d:: send $debug_report[] = ''{;}{left 2}

	^+#u:: send UNTESTED

	;Hot Keys - Code Related - PHP / JS
	#j:: Send // jxj4280 - 

	;Hot Keys - Code Related - PHP
		; Session Cookie Debugging
	!^+c:: Send setcookie('zz_JJDEBUG_',time(),(time(){+}2592000),'/'){;}{left 31}
		; Send PHP callie Debugging
	!^d:: send $callee = next(debug_backtrace()){;}
		; Debug in div tag
	^+d:: codeDebug("var_dump", FALSE)
	^+#d:: codeDebug("var_dump", TRUE)
		; Debug in pre tag
	!^+d:: codeDebug("print_r", FALSE)
	!^+#d:: codeDebug("print_r", TRUE)
		; HDC::validateData
	!^f:: Send HDC::fullyValidate($someVar,'type')
		; Generic Output array entry
	!^+o:: send $op[] = ''{;}{left 2}
	
	!^+m:: prepData()
		; HDC::protectedData
		;!^p:: Send HDC::protectedData('variable','pgcse')
	;!^p:: protectedData()
	!^p:: Send <?php`n`n?>{up}{tab}
	;!^+p:: Send HDC::sanitizeData(HDC::protectedData('variable','pgcse'),'type')
	;!^+p:: Send filter_var([variable],FILTER_SANITIZE_STRING){left 24}+{left 10}
	;!^+p:: Send filter_var([variable],FILTER_SANITIZE_ENCODED, array('flags'=>(FILTER_FLAG_STRIP_LOW|FILTER_FLAG_STRIP_HIGH))){left 89}+{left 10}
	!^+p:: Send filter_var([variable],FILTER_SANITIZE_SPECIAL_CHARS,array('flags'=>(FILTER_FLAG_STRIP_LOW|FILTER_FLAG_STRIP_HIGH))){left 94}+{left 10}
		; HDC::sanitizeData
	;!^s:: Send HDC::sanitizeData($someVar,'type')
	!^s:: sanitizeData()

		; HDC::validateData
	!^v:: Send HDC::validateData($someVar,'type')

	!^+x:: Send setcookie('zz_JJDEBUG_',(test1 === test2)?'Yay{!}':'Boo{!} '){;}{left 36}

		; HTML
	!^+.:: Send &gt{;}
	!^+,:: Send &lt{;}

	;; Some Text Formating
	; Row of Pluses
	^+NumpadAdd::send {+ 80}`n
	; Row of Minuses
	^+NumpadSub::send {- 80}`n
	; Row of Equals
	^+=::send {= 80}`n
	; Row of Underscores
	^+-::send {_ 80}`n
	; box
	^+/::send {/ 80}`n//`n{/ 80}{up}{end}{space}

	; For loops
	:O:mkfl::for ({;} {;}) {{}{enter}{tab}{Backspace}{enter}{Backspace}{}}{up 2}{end}{left 6}
	:O:mkil::for (var i=0,l={;} i<l{;} i{+}{+}) {{}{enter}{tab}{Backspace}{enter}{Backspace}{}}{up 2}{end}{left 13}
	
	; While Loop
	:O:mkwl::while () {{}{enter}{tab}{Backspace}{enter}{Backspace}{}}{up 2}{end}{left 3}

	; General function
	:O:newfunc::function () {{}{enter}{tab}{Backspace}{enter}{Backspace}{}}{up 2}{end}{left 3}

	; JavaScript Anon Function
	:*O:af+::function(){{}  {}}{left 2}

	; Some CSS
	:O:fl:l::float: left
	:O:fl:n::float: none
	:O:fl:r::float: right
	:O:ta:r::text-align: right
	:O:ta:l::text-align: left
	:O:ta:c::text-align: center
	:O:bg:n::background: transparent none;{left 6}+{left 11}
	:O:fs::font-size:{space}
	:O:fw::font-weight:{space}
	:O:fwb::font-weight: bold;
	:O:fwn::font-weight: normal;
	; IE7 Hack
	:O:ie7h::*:first-child{+}html  {{}{enter}{tab}{Backspace}{}}{up}{end}{left 2}
	; Mac Safari/Google Chrome Hack
	:O:machack::/* Google Chrome/ MAC Safari Hack */{enter}@media screen and (-webkit-min-device-pixel-ratio:0) {{}{enter}{tab}{enter}{}}{up}{End}

	; HTML
	; HTML - instant completers
	:Ob0:<img:: src="" />{Left 4}
	:*b0:<ul::>{Enter}{Tab}<li></li>{enter}{backspace}</ul>{up}{end}{left 5}
	:*b0:<li::></li>{left 5}
	:*b0:<a href::=""></a>{left 4}
	:*b0:<script:: type="text/javascript">{Enter}{TAB}{Enter}{Backspace}</script>{UP}{End}
	:*b0:<style:: type="text/css">{Enter}{TAB}{Backspace}{Enter}{Backspace}</style>{UP}{End}
	:O*:rscript::<script type="text/javascript" src=""></script>{left 11}
	:O*:rstyle::<link href="" rel="stylesheet" type="text/css" />{left 37}
	:*O:cdnjq::http://code.jquery.com/jquery-latest.min.js
		; m-r = meta refresh tag
	:O:m-r::<meta http-equiv="refresh" content="0;url=">{left 2}

	; PHP Timer
	:O:phptimer::
		send $start_time = microtime(true){;}{enter}
		send $end_time = microtime(true){;}{enter}
		send $total_time = $end_time - $start_time{;}
		return
	
	; HTML - keyword replacements
	; ]c = class=""
	:*:]c::class=""{left} 
	:*:]i::id=""{left} 
	; m-r = meta refresh tag
	:O:m-r::<meta http-equiv="refresh" content="0;url=">{left 2}
	; Remote Style Sheet
	:O*:rstyle::<link rel="stylesheet" type="text/css" media="all" href=""/>{left 3}
	; Remote Script Sheet
	:O*:rscript::<script type="text/javascript" src=""></script>{left 11}
	:O*:rstyle::<link href="" rel="stylesheet" type="text/css" />{left 37}
	:O:lia::<li><a href=""></a></li>{left 9}
	:O:ie8meta::<meta http-equiv="X-UA-Compatible" content="IE=8" />
	:O:ie7meta::<meta http-equiv="X-UA-Compatible" content="IE=7" />
	:O:idiv::<div id=""></div>{left 8}
	:O:cdiv::<div class=""></div>{left 8}
	:O:ispan::<span id=""></span>{left 9}
	:O:cspan::<span class=""></span>{left 9}

	::_ns::$normalSite
	::_ss::$secureSite
;; End editorWindows


; WinMerge
#IfWinActive ahk_class WinMergeWindowClassW
esc:: return
#a:: ; Expand all trees
	send {alt}v
	sleep 250
	send x
return

; HP Quality Control
#IfWinActive ahk_group HPQC
!^+f:: Send This has been fixed and will be part of the next QA release.
!^+o:: Send Taking Ownership of this defect.
!^+r:: Send Ready for QA

; Group of Random Windows to Ignore the Fkeys on
#IfWinActive ahk_group ignoreFkeys
F1::
F2::
F3::
F4::
F5::
F6::
F7::
F8::
F9::
F10::
F11::
F12::
F15:: return

; TortoiseHG
#IfWinActive ahk_group hgWindows
#a::Send, Komodo Automated:`nClean Up of EOL & Trailing Spaces`nUntabify
#u::Send, Updating Build Tag
#r::Send, Readability Cleanup

; Break out of the window Mode!
#IfWinActive
!^+f1::
	;WinGetClass, this_class , A
	;InputBox, throwaway, Copy it!, This Window is not in exploreWins, , ,300, , , , , %this_class%
	MouseGetPos, , , id, control, 2
	WinGetTitle, title, ahk_id %id%
	WinGetClass, class, ahk_id %id%
	msgbox,  ahk_id %id%`nahk_class %class%`n%title%`nControl: %control%
	return

; Toggle Alays on top
#SPACE::  Winset, Alwaysontop, , A

; GithubToken
!^+t:: Send e0e5f80776de89bd542d4b546f5d390637bafe54
return



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Support!
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RemoveToolTip:
	SetTimer, RemoveToolTip, Off
	ToolTip
return

filterCookies(){
	MouseGetPos, origX, origY
	; Clear cookies (Relies on Cookie Manager button Addon and specific location of the button. Move the button and you need to update this script.)
	MouseMove, 395, 35
	click
	MouseMove, %origX%, %origY%
	Sleep, 500
	send homedecorators.com
	Sleep, 500
	send {tab}
}


ReloadScriptIfChanged:
{
	FileGetAttrib, FileAttribs, %A_ScriptFullPath%
	IfInString, FileAttribs, A
	{
		FileSetAttrib, -A, %A_ScriptFullPath%
		TrayTip, Reloading Script..., %A_ScriptName%, , 1
		Sleep, 1000
		Reload
		TrayTip
	}
	Return
}

adjust(ByRef zeit) {
	formattime,zeit,A_now,dd.MM.yy_HH-mm-ss
	return
}

gst() {   ; GetSelectedText or FilePath in Windows Explorer  by Learning one
   IsClipEmpty := (Clipboard = "") ? 1 : 0
   if !IsClipEmpty {
      ClipboardBackup := ClipboardAll
      While !(Clipboard = "") {
         Clipboard =
         Sleep, 10
      }
   }
   Send, ^c
   ClipWait, 0.1
   ToReturn := Clipboard, Clipboard := ClipboardBackup
   if !IsClipEmpty
   ClipWait, 0.5, 1
   Return ToReturn
}

clearBrowserCache() {
	send +^{delete}
	Sleep, 500

	; Firefox
	IfWinActive, ahk_class MozillaDialogClass
	{
		send {enter}
		ToolTip, Waiting for CacheClear window to close.
		WinWaitClose, Clear All History 
		sleep, 500
		send ^{F5}
		SetTimer, RemoveToolTip, 750
	}

	; IE
	ifWinActive, ahk_class #32770
	{
		Sleep, 500
		Send {TAB}
		Sleep, 100
		Send {TAB}
		Sleep, 100
		Send {TAB}
		Sleep, 100
		Send {TAB}
		Sleep, 100
		Send {TAB}
		Sleep, 100
		Send {TAB}
		Sleep, 100
		Send {TAB}
		Sleep, 100
		Send {enter}
		sleep, 500
		WinWaitActive, Delete Browsing History,,2
		if ErrorLevel = 0 ; i.e. it's not blank or zero.
		{
			Tooltip, Clearing IE History... Please wait!
			sleep, 400
			WinWaitClose, Delete Browsing History
		}
		WinActivate, ahk_class IEFrame
		SetTimer, RemoveToolTip, 750
		sleep, 500
		send ^{F5}
		
	}
}

takeScreenShot(mode) {
	global irfanViewPath
	global ScreenShotDir
	FilePath = %ScreenShotDir%
	; if there is not already a folder c:\screenshot create one
	ifnotexist, %FilePath%
	{
		fileCreateDir, %FilePath%
	}
	adjust(zeit)
	; /capture=0 takes a screenshot of the whole desktop
	; /capture=1 takes a screenshot of the active window
	; /capture=2 takes a screenshot of the client area of the active window
	Run, %irfanViewPath% /capture=%mode% /convert="%FilePath%\capture_%Zeit%.png"
	Loop
	{
		IfExist, %FilePath%\capture_%Zeit%.png
		{
			Sleep, 1000
			Run, "%FilePath%\capture_%Zeit%.png"
			break
		}
		
		Sleep, 500
		
		IF a_index > 10
		{
			MSGBOX, Screenshot Error! %FilePath%\capture_%Zeit%.png
			break
		}
	}
}

TimedToolTip(ByRef msg, dur) {
	ToolTip, %msg%
	SetTimer, RemoveToolTip, %dur%
}

codeDebug(tag, capture) {
	IsClipEmpty := (Clipboard = "") ? 1 : 0
	if !IsClipEmpty {
		ClipboardBackup := ClipboardAll
		While !(Clipboard = "") {
			Clipboard =
			Sleep, 10
		}
	}

	indentClip := % getIndent()
	outPut := "// jxj4280 DEBUG - REMOVE START`n"
	outPut.= indentClip
	if (capture) {
		outPut.= "ob_start();`n"
		outPut.= indentClip
	}
	outPut.= tag
	outPut.= "();`n"
	outPut.= indentClip
	outPut.= "flush();`n"
	if (capture) {
		outPut.= indentClip
		outPut.= "`$jjdebug_output=ob_get_clean();`n"
		outPut.= indentClip
		outPut.= "ob_end_clean();`n"
		outPut.= indentClip
	}
	;outPut.= "echo '<pre class=\'jjDebug\'>',htmlentities(`$jjdebug_output,ENT_QUOTES),'</pre>';`n"
	outPut.= indentClip
	outPut.= "// jxj4280 DEBUG - REMOVE END`n"

	
	Clipboard = %outPut%
	ClipWait, 0.1
	send ^v
	send {up 3}{end}{left 2}
	sleep, 500
	Clipboard := ClipboardBackup
	if !IsClipEmpty
	ClipWait, 0.5, 1
}

getIndent() {
	IsClipEmpty := (Clipboard = "") ? 1 : 0
	if !IsClipEmpty {
		ClipboardBackup := ClipboardAll
		While !(Clipboard = "") {
			Clipboard =
			Sleep, 10
		}
	}
	Send +{HOME}
	Send ^c
	ClipWait, 0.5
	Send {right}
	indentClip := Clipboard
	Clipboard := ClipboardBackup
	if !IsClipEmpty
	ClipWait, 0.5, 1
	return indentClip
}

prepData() {
	IsClipEmpty := (Clipboard = "") ? 1 : 0
	if !IsClipEmpty {
		ClipboardBackup := ClipboardAll
		While !(Clipboard = "") {
			Clipboard =
			Sleep, 10
		}
	}

	indentClip := % getIndent()

	outPut := "// jxj4280 - PCI 2012`n"
	outPut.= indentClip
	outPut .= "`$prepData = array();`n"
	outPut.= indentClip
	outPut .= "`$prepData[''] = '';`n"
	outPut.= indentClip
	outPut .= "["
	outPut .= "VAR"
	outPut .="] = "
	outPut .= "connFactory"
	outPut .= "::runQuery(`$SQL,`$prepData);`n"
	outPut.= indentClip
	outPut.= "// DELETE THIS SECTION V WHEN DONE TESTING!`n"
	outPut.= indentClip
	outPut.= "`$jj_PCITest = ($rs2 === $rs)?'Yay!':'Boo!';`n"
	outPut.= indentClip
	outPut.= "`$jj_PCIName = 'zz_JJDEBUG_PCI_TEST_'.time();`n"
	outPut.= indentClip
	outPut.= "if (!headers_sent()) {`n"
	outPut.= indentClip
	outPut.= "	setcookie(`$jj_PCIName,`$jj_PCITest);`n"
	outPut.= indentClip
	outPut.= " } else {`n"
	outPut.= indentClip
	outPut.= "	ob_start();`n"
	outPut.= indentClip
	outPut.= "	echo `$jj_PCIName, ' : ', `$jj_PCITest;`n"
	outPut.= indentClip
	outPut.= "	$jjdebug_output=ob_get_clean();`n"
	outPut.= indentClip
	outPut.= "	ob_flush();`n"
	outPut.= indentClip
	outPut.= "	echo '<pre class=\'jjDebug\'>',htmlentities($jjdebug_output,ENT_QUOTES),'</pre>';`n"
	outPut.= indentClip
	outPut.= "}`n"
	outPut.= indentClip
	outPut.= "// DELETE THIS SECTION ^ WHEN DONE TESTING!`n"
	outPut.= indentClip
	outPut .= "`$prepData = NULL;`n"
	outPut.= indentClip
	outPut .= "/// PCI 2012`n"

	Clipboard = %outPut%
	ClipWait, 0.1
	send ^v
	Send {up 16}
	Send {end}
	Send {home}
	Send ^+{right 3}
	Send +{left}
	Clipboard := ClipboardBackup
	if !IsClipEmpty
	ClipWait, 0.5, 1
}

protectedData() {

	inp = % gst()

	if inp
	{
		found := RegExMatch(inp, "\$_(GET|POST|COOKIE|SERVER|ENV|REQUEST)\[['""]?([^""'\]]*)['""]?\]", myParts)

		if found > 0
		{
			IsClipEmpty := (Clipboard = "") ? 1 : 0
			if !IsClipEmpty {
				ClipboardBackup := ClipboardAll
				While !(Clipboard = "") {
					Clipboard =
					Sleep, 10
				}
			}


			
			;Send {right} %myParts1% %myParts2%
			opType := ""
			if (myParts1 = "SERVER") {
				opType .= "s"
			}
			if (myParts1 = "ENV") {
				opType .= "e"
			}
			if (myParts1 = "REQUEST" or myParts1 = "POST") {
				opType .= "p"
			}
			if (myParts1 = "REQUEST" or myParts1 = "GET") {
				opType .= "g" 
			}
			if (myParts1 = "COOKIE") {
				opType .= "c"
			}

			hasVar := InStr(myParts2, "$")

			if (hasVar = 0)
			{
				opVar := "'"
				opVar .= myParts2
				opVar .= "'"
			}
			else
			{
				opVar := myParts2
			}

			;send {right} %opType%
			opComplete := "HDC::protectedData("
			opComplete .= opVar
			opComplete .= ",'"
			opComplete .= opType
			opComplete .= "')"
			;Send {right} %opComplete%

			Clipboard = %opComplete%
			ClipWait, 0.5
			send ^v
			Sleep, 500
			Clipboard := ClipboardBackup
			if !IsClipEmpty
			ClipWait, 0.5, 1
		}

	}
	else
	{
		Send HDC::protectedData('variable','pgcse')
	}

}

sanitizeData() {

	inp = % gst()

	if inp
	{

		IsClipEmpty := (Clipboard = "") ? 1 : 0
		if !IsClipEmpty {
			ClipboardBackup := ClipboardAll
			While !(Clipboard = "") {
				Clipboard =
				Sleep, 10
			}
		}

		;send {right} %opType%
		opComplete := "HDC::sanitizeData("
		opComplete .= inp
		opComplete .= ",'type')"
		;Send {right} %opComplete%

		Clipboard = %opComplete%
		ClipWait, 0.5
		send ^v
		Sleep, 500
		Clipboard := ClipboardBackup
		if !IsClipEmpty
		ClipWait, 0.5, 1
		Send {left 2}+{left 4}

	}
	else
	{
		Send HDC::sanitizeData($someVar,'type')
		Send {left 8}+{left 8}
	}

}

toggleMediaKeys() {
	global
	if ( EnableMediaKeys )
	{
		; Turn them off
		EnableMediaKeys := false
		playSound("MediaKeysOff")
		ToolTip, Toggled Media Keys Off
	}
	else
	{
		; Turn them On
		EnableMediaKeys := true
		playSound("MediaKeysOn")
		ToolTip, Toggled Media Keys On
	}
	IniWrite, %EnableMediaKeys%, %myIni%, globals, EnableMediaKeys
	SetTimer, RemoveToolTip, 750
}

checkMediaKeysStatus() {
	global
	if ( EnableMediaKeys )
	{
		playSound("MediaKeysOn")
		ToolTip, Media Keys are On
	}
	else
	{
		playSound("MediaKeysOff")
		ToolTip, Media Keys are Off
	}
	SetTimer, RemoveToolTip, 750
}

playSound(action) {
	global
	StringLower, action, action
	if (action = "mediakeyson")
	{
		SoundPlay, %mySoundDir%\dooropen.wav
		return
	}
	if (action = "mediakeysoff")
	{
		SoundPlay, %mySoundDir%\doorslam.wav
		return
	}
	if (action = "error")
	{
		SoundPlay, %mySoundDir%\howler.wav
		return
	}
	
}