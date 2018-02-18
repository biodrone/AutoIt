#cs ----------------------------------------------------------------------------
 AutoIt Version: 3.3.8.1
 Author:         biodrone
 Script Version: 0.0.1
 Script Function:
	Made to copy the directory that the script is in to another place
#ce ----------------------------------------------------------------------------

#include <Misc.au3>
#include <File.au3>
#include <Array.au3>
#include <Date.au3>
#NoTrayIcon

Main()

Func Main()
	Global $source = @ScriptDir
	Global $dest = "F:\School Backup\" & _NowDate()

	If DirGetSize($dest) <> -1 Then
		DirCreate($dest)
    EndIf

	DirCopy($source, $dest)
EndFunc