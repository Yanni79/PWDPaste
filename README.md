# PWDPaste
Compilable utility to type out passwords where paste is not supported (Consoles, locked RDP screens, etc).
This is an Autoit script that's meant to be compiled to an executable.
PwdPaste Version 1.1
It sends the text content of the clipboard to a remote session by emulating keystrokes (vs paste).
This is meant to bypass limitations of where pasting text is not allowed/supported.

PWDPaste was developed by Yanni Shainsky | yanni@BannermenInc.com
Please send any bugs or enhancement requests, as well as your compliments and well wishes.

Not providing a compiled executable to prevent any potential abuse.

 Install AutoIt 3.x (preferably the latest). 
 Save the PWDPaste.au3 to your local machine (or copy/paste text into a similarly named file with an au3 extension).
 Save the ClipPass.ico icon file (included). 
 Open the Auoit Compiler ("C:\Program Files (x86)\AutoIt3\Aut2Exe\Aut2exe.exe")
 Select the Source File as PWDPaste.au3
 Select the Destination File as the name of the executable you want (PwdPaste.exe) for example.
 For the Options - you can use the included icon file or your own
 You can choose to compile for a x64 system (though a 32 bit executable should work as well).

Usage: Run the compiled executable on a windows based machine. It should appear as an icon in the system tray.
Copy the desired password into clipboard (for example out of CyberArk).
Press Ctrl+Shift+N, with the FOCUS being on on your local desktop (IMPORTANT) - then focus on the password field that you want type into (for example the console of a remote computer). 
The expected behavior is that after 2 seconds the keyboard emulation will start typing the password on the "far end". 


The defined combinations are
		 ctrl+shift+v to type something quickly (with no delay from when typing starts)
		 ctrl+shift+b to type something slower (with no delay from when typing starts)
		 ctrl+shift+n to type something slower (with the default delay of 2 seconds before starting to type)
     
Adjust the variables prior to compilation as needed (for example if you want a longer wait time to re-focus where you will type the password). 

TLDR; To get started, you'll need the latest version of Autoit, and the included PWDpaste.au3 file (as well as the optional icon file). 
Follow the directions above, once you have the files.
