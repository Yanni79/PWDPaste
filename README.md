# PWDPaste
Compilable utility to type out passwords where paste is not supported (Consoles, locked RDP screens, etc).
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
; Select the Source File as PassClip.au3
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
