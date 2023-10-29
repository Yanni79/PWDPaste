; This is an AutoIt script that's meant to be compiled to an executable.
; PwdPaste Version 1.2
; It sends the text content of the clipboard to a remote session by emulating keystrokes (vs paste).
; This is meant to bypass limitations where pasting text is not allowed/supported.
;
; This script was co-developed by Yanni Shainsky (yanni@BannermenInc.com) and Matthew Kirby (matt@BannermenInc.com).
; Please send any bugs, enhancement requests, as well as your compliments and well wishes 
;
; Save this text as a filename with the au3 extension - for example PwdPaste.au3
; Open the AutoIt Compiler ("C:\Program Files (x86)\AutoIt3\Aut2Exe\Aut2exe.exe")
; Select the Source File as PwdPaste.au3 (this file).
; Select the Destination File as the name of the executable you want (PwdPaste.exe) for example.
; For the Options - you can use the included icon file or your own.
; You can choose to compile for a x64 system (though a 32-bit executable should work as well).
;  Added functionality to display the command (right click on the menu in the shortcut > Show Commands. Repeat operation to make the pop-up disappear. 
;
;
;Usage: Run the compiled executable on a windows based machine. It should appear as an icon in the system tray.
;Copy the desired password into clipboard (for example out of CyberArk).
;Press Ctrl+Shift+N on your local desktop - then focus on the password field that you want type into (for example the console of a remote computer)
;The defined combinations are
;		 Ctrl+Shift+V to type something quickly (with no delay from when typing starts)
;		 Ctrl+Shift+B to type something slower (with no delay from when typing starts)
;		 Ctrl+Shift+N to type something slower (with the default delay of 10 seconds before starting to type)
;
; Please don't abuse this script.
; Please attribute this script when using it.
; This script is provided as code, because you should not trust executables compiled by third parties, especially for clipboard, etc.
; This script is provided without any warranty, and is provided as a proof-of-concept with an open-source license.
; Keeping passwords in clipboards is inherently unsafe, as rogue scripts or malicious users can exploit clipboard contents.

#include <Clipboard.au3>
#include <Misc.au3>
#include <AutoItConstants.au3>

; Set Options
Opt("TrayMenuMode", 0) ; Tray menu mode - Default menu items (Script Paused/Exit) are appended to the user-created menu; items will automatically be checked/unchecked when clicked
Opt("TrayAutoPause", 0) ; Do not pause the script when it's clicked on the tray.

; Set Hotkeys
HotKeySet("^+v", "TypeClipTextFast") ; Ctrl+Shift+V
HotKeySet("^+b", "TypeClipTextSlower") ; Ctrl+Shift+B (types characters slower)
HotKeySet("^+n", "TypeClipTextDelay") ; Ctrl+Shift+N (waits 10 seconds before starting to type)
HotKeySet("^+q", "Terminate") ; Ctrl+Shift+Q (exits the application)
HotKeySet("^+p", "GetParameters") ; Ctrl+Shift+P (prompt for parameters)

; Variables
Global Const $TIP_CENTER = 2 ; Used for ToolTips
Global Const $TIP_FORCEVISIBLE = 4 ; Used for ToolTips
Global $iScreenHeight = @DesktopHeight ; Screen Height
Global $iScreenWidth = @DesktopWidth ; Screen Width
Global $bShowHelp = False ; This is for toggling 'Show Commands' on and off
Global $bInProgress = False ; If a command has been initiated

; Configurable Variables
Global $iHostKeyCtrl_Shift_V_speed = 50 ; Delay to type text faster - needed by impatient users
Global $iHostKeyCtrl_Shift_B_speed = 100 ; Delay to type text slower - needed by some applications that restrict typing passwords quickly
Global $iHostKeyCtrl_Shift_N_delay = 10 ; Delay time for Ctrl+Shift+N - increase it if it takes longer to focus on another window after executing the script (default 10 seconds)
Global $iMaxPasswordLength = 40 ; Maximum number of characters a password can be to prevent accidentally pasting large amounts of text
Global $iSecondsUntilClipboardClear = 60 ; Seconds until clipboard is cleared after a paste is initiated

; Call Initialization Functions
CreateHelpTray() ; Create 'Show Commands' Help Tray

While 1
Sleep(100)
WEnd

; Creates 'Show Commands' menu item in the Taskbar for this application
Func CreateHelpTray()

    $ShowCommandsMenuItem = TrayCreateItem("Show Commands")
	; Create the menu item with text/title "Show Commands"
	
    TrayItemSetOnEvent(-1, "ShowCommands")
	; Call 'ShowCommands' function when this menu item is clicked. -1 for itemID is used to specify that the event handler should be associated with the most recently created menu item, which is the "Show Commands" menu item created above

    TraySetState()
	; Set the tray state - show the tray icon by default	

    While 1
		Switch TrayGetMsg()
			; Listen for actions on the menu items (e.g., clicks)
			Case $ShowCommandsMenuItem
				; This case block will be executed when the "Show Commands" menu item is clicked
				
				ShowCommands()
				; Display the commands
		EndSwitch
	WEnd

EndFunc ;==>CreateHelpTray

; Clears the clipboard after a specified delay in seconds
Func ClearClipboard($iDelayInSeconds) 
Sleep($iDelayInSeconds * 1000)
ClipPut("")
EndFunc ;==>ClearClipboard

; Prompts the user for configuration parameters such as the paste delay
Func GetParameters()
	If Not $bInProgress Then
	
		$bInProgress = True
		; Set bInProgress to prevent multiple commands from executing simultaneously
		
		$sInputBoxContent = InputBox("Enter Paste Delay", "Please enter number of seconds to wait before pasting (1 - 10):", 10)
		; Prompt the user to enter the paste delay
		 
		If @error = 1 Then
			;User pressed 'Cancel', exit the function
			Return
		EndIf

	ValidatePasteDelayParameter($sInputBoxContent)
	; Validate the entered delay parameter, also converts InputBox input from string to integer
	
	$bInProgress = False
	; Set bInProgress to indicate that the function is complete
	EndIf
EndFunc ;==>GetParameters

; Displays a tooltip with the available commands and removes it on subsequent clicks
Func ShowCommands()
	$bShowHelp = Not $bShowHelp
	; Toggle the value of $bShowHelp
	
	If $bShowHelp Then
		ToolTip("COMMANDS" & @CRLF & @CRLF & "CTRL+SHIFT+V --> FAST PASTE" & @CRLF & "CTRL+SHIFT+B --> SLOW PASTE" & @CRLF & "CTRL+SHIFT+N --> " & $iHostKeyCtrl_Shift_N_delay & " SECOND(S) DELAY PASTE" & @CRLF & "CTRL+SHIFT+P --> SET PREFERENCES" & @CRLF & "CTRL+SHIFT+Q --> EXIT APPLICATION" & @CRLF & @CRLF & "PRESS 'SHOW COMMANDS' AGAIN TO REMOVE HELP MESSAGE", $iScreenWidth * .9, $iScreenHeight * .9, "HELP", 1, $TIP_CENTER + $TIP_FORCEVISIBLE)
		; Display the help tooltip
	Else
		ToolTip("")
		; Remove the tooltip
	EndIf
EndFunc ;==>ShowCommands

Func Terminate()
Exit 0
EndFunc   ;==>Terminate

Func TypeClipTextDelay()
	; Prevent multiple pastes from being called during the waiting period
	IF $bInProgress <> 1 Then
		$bInProgress = 1
		
		$sText = ClipGet()
		; Grab Clipboard Contents
		
		$sText = StringLeft ( $sText, $iMaxPasswordLength )
		; Send only the first 40 characters
		
		$sText = StringRegExpReplace($sText, "\r\n|\r|\n", "")
		; Remove any line breaks
		
		opt("sendKeyDownDelay", $iHostKeyCtrl_Shift_B_speed)
		; Set amount of time key is held down per keystroke
		
		$iPasteDelay = $iHostKeyCtrl_Shift_N_delay * 1000
		; Don't use $iHostKeyCtrl_Shift_N_delay variable directly as we will decrement below, instead assign value to $iPasteDelay and decrement that
		
			While $iPasteDelay > 0
			ToolTip("Pasting in " & $iPasteDelay  / 1000 & " second(s)", $iScreenWidth / 5, $iScreenHeight / 5, "PASTE INITIATED", 1, $TIP_FORCEVISIBLE)
			; Display the countdown
			
			Sleep ( 1000 )
			; Sleep for 1 second
			
			$iPasteDelay -= 1000
			; Decrease the value of $iPasteDelay by one second
			WEnd
			
		ToolTip("", 0, 0)
		; Clear the tooltip
		
		_SendEx($sText, 1)
		; Send the clipboard contents - SendEx function from: https://www.autoitscript.com/forum/topic/161592-sendex-yet-another-alternative-to-the-built-in-send-function/;
		
		ControlSend("", "", "", "", 0)
		; Unstuck any keys
		
		$bInProgress = 0
		; Unlock the process after the text is sent
		
		ClearClipboard($iSecondsUntilClipboardClear)
		; Clear the clipboard after the configured delay - timer restarts after each action
	EndIf
EndFunc   ;==>TypeClipTextDelay


Func TypeClipTextFast()
	; Prevent multiple pastes from being called at the same time
	IF $bInProgress <> 1 Then
		$bInProgress = 1
		
		$sText = ClipGet()
		; Grab Clipboard Contents
		
		$sText = StringLeft ( $sText, $iMaxPasswordLength )
		; Send only the first 40 characters
		 
		$sText = StringRegExpReplace($sText, "\r\n|\r|\n", "")
		; Remove any line breaks
		
		opt("sendKeyDownDelay", $iHostKeyCtrl_Shift_V_speed)
		; Set amount of time key is held down per keystroke
		
		SendEx($sText, 1) 
		; Send the clipboard contents - SendEx function from: https://www.autoitscript.com/forum/topic/161592-sendex-yet-another-alternative-to-the-built-in-send-function/;
		
		ControlSend("", "", "", "", 0)
		; Unstuck any keys
		
		$bInProgress = 0
		; Unlock the process after the text is sent
		
		ClearClipboard($iSecondsUntilClipboardClear)
		; Clear the clipboard after the configured delay - timer restarts after each action
	EndIf
EndFunc   ;==>TypeClipTextFast

Func TypeClipTextSlower()
	; Prevent multiple pastes from being called at the same time
	If $bInProgress <> 1 Then
		$bInProgress = 1
		
		$sText = ClipGet()
		; Grab Clipboard Contents
		
		$sText = StringLeft ( $sText, $iMaxPasswordLength ) 
		; Send only the first 40 characters
		
		$sText = StringRegExpReplace($sText, "\r\n|\r|\n", "") 
		; Remove any line breaks
		
		opt("sendKeyDownDelay",  $iHostKeyCtrl_Shift_B_speed)
		; Set amount of time key is held down per keystroke
		
		_SendEx($sText, 1)
		; Send the clipboard contents - SendEx function from: https://www.autoitscript.com/forum/topic/161592-sendex-yet-another-alternative-to-the-built-in-send-function/;
		
		ControlSend("", "", "", "", 0) 
		; Unstuck any keys
		
		$bInProgress = 0 
		; Unlock the process after the text is sent
		
		ClearClipboard($iSecondsUntilClipboardClear) 
		; Clear the clipboard after the configured delay - timer restarts after each action
	EndIf
EndFunc   ;==>TypeClipTextSlower

; Validate the paste delay parameter
Func ValidatePasteDelayParameter($sContent) 
	; Check if the input is a whole number
	If StringRegExp($sContent, "^\d+$") Then
        $iContent = Number($sContent)
		; Convert from string to number. This is needed because InputBox returns a string
		
		; Check if the input is NOT within the valid range: if so, re-prompt users
        If $iContent < 1 Or $iContent > 10 Then
            ToolTip("The input is NOT a valid number.", MouseGetPos(0), MouseGetPos(1) - 30, "INVALID PARAMETER", 2, $TIP_FORCEVISIBLE)
			; Display that input is not valid
			
			Sleep(2000)
			; Sleep for 2 seconds before removing invalid parameter message
			
		    ToolTip("", 0, 0)
			; Clear the tooltip
			
			$sInputBoxContent = InputBox("Enter Paste Delay", "Please enter number of seconds to wait before pasting (1 - 10):", 10)
			; Prompt the user to enter the paste delay
			
			If @error = 1 Then
				;User pressed 'Cancel', exit the function
				Return
			EndIf
				
			ValidatePasteDelayParameter($sInputBoxContent)
			; Revalidate the newly entered parameter
		Else
			; Input is within valid range
			
			$iHostKeyCtrl_Shift_N_delay = $iContent
			; Assign user entered value to parameter now that it passed validation
		EndIf
	Else
		; The input is not a whole number, re-prompt user
		
		ToolTip("The input is NOT a valid number.", MouseGetPos(0), MouseGetPos(1) - 30, "INVALID PARAMETER", 2, $TIP_FORCEVISIBLE)
		; Display that input is not valid
		
		Sleep(2000)
		; Sleep for 2 seconds before removing invalid parameter message
		
		ToolTip("", 0, 0)
		; Clear the tooltip
		
		$sInputBoxContent = InputBox("Enter Paste Delay", "Please enter number of seconds to wait before pasting (1 - 10):", 10)
		; Prompt the user to enter the paste delay
		
		If @error = 1 Then
			;User pressed 'Cancel', exit the function
			Return
		EndIf
		
		ValidatePasteDelayParameter($sInputBoxContent)
		; Revalidate the newly entered parameter
    EndIf
EndFunc ;==>ValidatePasteDelayParameter

; Send the string $ss
Func _SendEx($ss, $warn = "") 
Local $iT = TimerInit()
  While _IsPressed("10") Or _IsPressed("11") Or _IsPressed("12")
    If $warn <> "" And TimerDiff($iT) > 1000 Then
      ToolTip("Warning", $iScreenWidth / 5, $iScreenHeight / 5, "Warning", 2, $TIP_CENTER + $TIP_FORCEVISIBLE)
	  ; Display warning Tooltip
	  
      Sleep(5000)
	  ; Display the tooltip for 5 seconds
	  
      ToolTip("")
	  ; Remove the tooltip
    EndIf
  WEnd
Send($ss, 1)
; Send the string
EndFunc;==>_SendEx
