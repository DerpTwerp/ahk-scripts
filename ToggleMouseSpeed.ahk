; Autohotkey script "Toggle Mouse sensitivity"
;=================================================================================
#SingleInstance force
SlowMouseSpeed := 7
NormalMouseSpeed := true ; State of Mouse pointer speed
UserMouseSpeed := 17 ; Speed sensed before slow down
MouseThreshold1 := 6
MouseThreshold2 := 10
MouseEnhance := 0
SPI_GETMOUSESPEED := 0x70
SPI_SETMOUSESPEED := 0x71
SPI_SETMOUSE := 0x04
;=================================================================================
XButton1::
#RButton::
XButton2::
;ScrollLock::
	toggleMouseSpeed()
return
;Control & LWIN::slowMouse()
;Control & LWIN UP::revertMouse()
;=================================================================================
slowMouse()
{
 global
 if ( NormalMouseSpeed ) {
 ; Slow down mouse speed
 DllCall("SystemParametersInfo", UInt,SPI_SETMOUSESPEED, UInt,0, UInt,SlowMouseSpeed, UInt,0)
 ; SENSE AFTER
 DllCall("SystemParametersInfo", UInt,SPI_GETMOUSESPEED, UInt,0, UIntP,currentSpeed, UInt,0)
 ToolTip, Mouse slow: %currentSpeed%/20
 ; REMEMBER CURRENT STATE
 NormalMouseSpeed := false
 SetTimer, RemoveToolTip, 1000
 }
}
revertMouse() {
 global
 if( NOT NormalMouseSpeed ) {
 ; Restore the original speed.
 DllCall("SystemParametersInfo", UInt, SPI_SETMOUSESPEED, UInt,0, UInt,UserMouseSpeed, UInt,0)
 ; SENSE AFTER
 DllCall("SystemParametersInfo", UInt,SPI_GETMOUSESPEED, UInt,0, UIntP,currentSpeed, UInt,0)
 ToolTip, Mouse restored: %currentSpeed%/20
 ; REMEMBER CURRENT STATE
 NormalMouseSpeed := true
 SetTimer, RemoveToolTip, 1000
 }
}
toggleMouseSpeed() {
 global
 ; SET LOW SPEED
 if( NormalMouseSpeed )
 {
	slowMouse()
 }
 ; RESTORE SPEED
 else {
	revertMouse()
 }
 SetTimer, RemoveToolTip, 1000
}
;=================================================================================
InsertInteger(pInteger, ByRef pDest, pOffset = 0, pSize = 4) {
 ; Copy each byte in the integer into the structure as raw binary data.
 Loop %pSize%
 DllCall("RtlFillMemory", "UInt",&pDest + pOffset + A_Index-1, "UInt", 1, "UChar", pInteger >> 8*(A_Index-1) & 0xFF)
}
;=================================================================================
RemoveToolTip:
SetTimer, RemoveToolTip, Off
ToolTip
return
;=================================================================================
