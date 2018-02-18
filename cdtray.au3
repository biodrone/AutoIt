#cs ----------------------------------------------------------------------------
 AutoIt Version: 3.3.8.1
 Author:         biodrone
 Script Function:
	Opens and closes the CD tray infinitely
#ce ----------------------------------------------------------------------------

$on = True ; infinite loop variable
$CD = DriveGetDrive("CDROM") ; check if there is a cdrom drive


If $CD[0] Then ; if there is a cdrom drive
   While $on = True ; infinite loop
	   CDTray($CD[1], "open") ; open the tray
	   CDTray($CD[1], "closed") ; close the tray again
   WEnd
EndIf