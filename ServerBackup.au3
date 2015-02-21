;Purpose: Script to backup syncs on the server
;Author: JJ
;Version: 0.5

#include <Date.au3>
#include <MsgBoxConstants.au3>
#include <WindowsConstants.au3>
#include <Array.au3>
#include <File.au3>

Global $src1 = "Z:\Syncs\Code"
Global $src2 = "Z:\Syncs\Uni"
Global $src3 = "Z:\Syncs\General Share"
Global $date
Global $datef
Global $logpath = "C:\backuplog.txt"

GetDate()
Main()
LogWrite()

Func Main()
   MsgBox($MB_SYSTEMMODAL, 'Copy Info', "Copying Code...", 5)
   DirCopy($src1, $dst & "\Code")
   MsgBox($MB_SYSTEMMODAL, 'Copy Info', "Copying Uni...", 5)
   DirCopy($src2, $dst & "\Uni")
   MsgBox($MB_SYSTEMMODAL, 'Copy Info', "Copying General Share...", 5)
   DirCopy($src3, $dst & "\General Share")
   MsgBox($MB_SYSTEMMODAL, 'Copy Info', "Copying Finished...", 5)
EndFunc

Func GetDate()
   ;Get current system time
   $date = StringSplit(_NowDate(), "/")
   $datef = $date[3] & $date[2] & $date[1]
   Global $dst = "Z:\Bak\Syncs_" & $datef
 EndFunc

Func LogWrite()
    ;Create log file if it doesn't exist and write a success message
    If FileExists($logpath) Then
	  Local $loghandle = FileOpen($logpath, 1)
	  FileWrite($loghandle, "Backup Success on " & _NowDate())
    Else
       _FileCreate($logpath)
	   LogWrite()
    EndIf
 EndFunc
