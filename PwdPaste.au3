; This is an Autoit script that's meant to be compiled to an executable.
; PwdPaste Version 1.1
; It sends the text content of the clipboard to a remote session by emulating keystrokes (vs paste).
; This is meant to bypass limitations of where pasting text is not allowed/supported.
;
; This was developed by Yanni Shainsky | yanni@BannermenInc.com
; Please send any bugs or enhancement requests, as well as your compliments and well wishes.
;
; Save this text as a filename with the au3 extension - for example PwdPaste.au3
; Open the Auoit Compiler ("C:\Program Files (x86)\AutoIt3\Aut2Exe\Aut2exe.exe")
; Select the Source File as PWDPAste.au3 (this file). 
; Select the Destination File as the name of the executable you want (PwdPaste.exe) for example.
; For the Options - you can use the included icon file or your own
; You can choose to compile for a x64 system (though a 32 bit executable should work as well).
;
;
;
;Usage: Run the compiled executable on a windows based machine. It should appear as an icon in the system tray.
;Copy the desired password into clipboard (for example out of CyberArk).
;Press ctrl+shift+N on your local desktop - then focus on the password field that you want type into (for example the console of a remote computer)
;The defined combinations are
;		 ctrl+shift+v to type something quickly (with no delay from when typing starts)
;		 ctrl+shift+b to type something slower (with no delay from when typing starts)
;		 ctrl+shift+n to type something slower (with the default delay of 2 seconds before starting to type)
;
; Please don't abuse this script.
; Please attribute this script when using it.
; This script is provided as code, because you should not trust executables compiled by third parties, especially for clipboard, etc.
; This script is provided without any warranty, and is provided as a proof-of-concept with an open-source license.
; Keeping passwords in clipboards is inherently unsafe, as rogue scripts or malicious users can exploit clipboard contents.
; Future refinements (coming in next version): clear the password after x number of seconds.

#include <Clipboard.au3>
#include < Misc.au3 >
#include <MsgBoxConstants.au3>

Opt("TrayAutoPause", 0); do not pause the script when it's clicked on the tray.

HotKeySet("^+v", "TypeClipTextFast") ; ctrl+shift+v
HotKeySet("^+b", "TypeClipTextSlower") ; ctrl+shift+b  (types characters slower)
HotKeySet("^+n", "TypeClipTextDelay") ; ctrl+shift+n (waits 2 seconds before starting to type). This is to give the user opportunity to change focus - for example to full screen app.
HotKeySet("^+q", "Terminate") ; ctrl+shift+q (exits the application)

Global $HostKeyCtrl_Shift_V_speed = 50 ; This is the delay to type text faster - needed by impatient users
Global $HostKeyCtrl_Shift_B_speed = 100 ; This is the delay to type text slower - needed by some applications that restrict typing out passwords quickly
Global $HostKeyCtrl_Shift_N_delay = 2000 ; This is the delay time for ctrl+shift+n - increase it if it's taking longer to focus on another window after executing script
Global $MaxPasswordLength = 40 ; This is biggest number of characters a password can be. Restricted to prevent accidentally pasting an essay into a password field.

While 1
Sleep(100)
WEnd

Func TypeClipTextFast()
$Text = ClipGet()
$Text = StringLeft ( $Text, $MaxPasswordLength ) ; Send only the first 40 characters
$Text = StringRegExpReplace($Text, "\r\n|\r|\n", "") ; Remove any enter keys
opt("sendKeyDownDelay", $HostKeyCtrl_Shift_V_speed)
_SendEx($Text, 1) ;attributes: SendEx function from: https://www.autoitscript.com/forum/topic/161592-sendex-yet-another-alternative-to-the-built-in-send-function/;

ControlSend("", "", "", "", 0) ; this gets gets keys unstuck
EndFunc   ;==>TypeClipText

Func TypeClipTextSlower()
$Text = ClipGet()
$Text = StringLeft ( $Text, $MaxPasswordLength ) ; Send only the first 40 characters
$Text = StringRegExpReplace($Text, "\r\n|\r|\n", "") ; Remove any enter keys
opt("sendKeyDownDelay",  $HostKeyCtrl_Shift_B_speed)
_SendEx($Text, 1)
ControlSend("", "", "", "", 0) ; this gets gets keys unstuck
EndFunc   ;==>TypeClipText


Func TypeClipTextDelay()
$Text = ClipGet()
$Text = StringLeft ( $Text, $MaxPasswordLength ) ; Send only the first 40 characters
$Text = StringRegExpReplace($Text, "\r\n|\r|\n", "") ; Remove any enter keys
opt("sendKeyDownDelay", $HostKeyCtrl_Shift_B_speed)
  Sleep ($HostKeyCtrl_Shift_N_delay) ; WAIT x seconds before sending (to give user opportunity to change focus.)

_SendEx($Text, 1)
ControlSend("", "", "", "", 0) ; this gets gets keys unstuck
EndFunc   ;==>TypeClipText


Func _SendEx($ss, $warn = "")
Local $iT = TimerInit()
 While _IsPressed("10") Or _IsPressed("11") Or _IsPressed("12")
  If $warn <> "" And TimerDiff($iT) > 1000 Then
   MsgBox($MB_TOPMOST, "Warning", $warn)
  EndIf
  Sleep(50)
 WEnd
Send($ss, 1)
EndFunc;==>_SendEx


Func Terminate()
Exit 0
EndFunc   ;==>Terminate
