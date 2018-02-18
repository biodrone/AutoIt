#cs ----------------------------------------------------------------------------
 AutoIt Version: 3.3.8.1
 Author:         biodrone
 Script Function:
	A script to add wordlists together
#ce ----------------------------------------------------------------------------

#include <File.au3>
#include <Array.au3>

Global $filelist = _FileListToArray("C:\Wordlists")
Global $i = 1
Global $temparr
Global $oFile = ""

If @error = 1 Then
    MsgBox(0, "", "No Folders Found.")
    Exit
 EndIf
 
If @error = 4 Then
    MsgBox(0, "", "No Files Found.")
    Exit
EndIf

$oFile = FileOpen("C:\Wordlists\ALL_WORDS.txt", 1)

For $i = 1 To $filelist[0]
   ConsoleWrite("$i is " & $i & @CR)
   _FileReadToArray("C:\Wordlists\" & $filelist[$i], $temparr)
   _ArraySort($temparr)
   _FileCreate("C:\Wordlists\ALL_WORDS.txt")
   _FileWriteFromArray($oFile, $temparr)
Next
FileClose($oFile)