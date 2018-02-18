#cs ----------------------------------------------------------------------------
 AutoIt Version: 3.3.8.1
 Author:         biodrone
 Script Version: 0.2.0
 Script Function:
	Copy files from a target machine to a removable drive
	With the presence of a progress bar [optional]
#ce ----------------------------------------------------------------------------

#include <Misc.au3>
#include <File.au3>
#include <Array.au3>
#NoTrayIcon

Main()
Func Main()
   Global $k = 1
   Global $i = 0
   Global $j = 1
   Global $drive_letter = ""
   Global $l = 1
   Global $drive_arr
   Find_Drive()
   ; copy dirs containing only files
   ;Copy(@FavoritesDir)
   ;Copy("C:\Documents and Settings\James\My Documents\Dropbox\Eclipse")
   Copy("D:\Code")
EndFunc

Func Find_Drive()
   ; find all drives with REMOVABLE as their type
   $drive_arr = DriveGetDrive("REMOVABLE")
   _ArrayDisplay($drive_arr)
   ; check for the drive with the right label and set it's letter to $drive_letter
   For $i = 0 to $drive_arr[0]
	  If DriveGetLabel($drive_arr[$i]) = "USBDESTRUCT" Then
		 Global $drive_letter = $drive_arr[$i]
		 ;debug goodness
		 MsgBox(0, "Drive Letter", $drive_letter)
	  EndIf
   ;Next
EndFunc

;Func Progress($srcsz, $trgsz, $newtrgsz)
;   ConsoleWrite('Currently, srcsz = ' & $srcsz & ' and newtrgsz = ' & $newtrgsz & @CR)
;   If $newtrgsz = 0 Then $newtrgsz = 1
;   If @error == 0 Then
;	  If $k < $FileList[0] Then
;			ConsoleWrite('Division equation is ' & $k/$FileList[0] & @CR)
;			ConsoleWrite('Percentage equation is ' & Ceiling($k/$FileList[0]*100) & @CR)
;			ProgressSet($k/$FileList[0]*100, "File " & $k & ": " & Ceiling($k/$FileList[0]*100) & " %" & @CR)
;	  Else
;		 ProgressSet(100, "100 %", "Finished")
;	  EndIf
;   Else
;	  MsgBox(0, "Error!", "Sorry, an error has occured!", 2)
;   EndIf
;EndFunc

Func Copy($src)
   ; check for bad string formatting
   If StringRight($src, 1) <> "\" Then $src = $src & "\"
   ;ConsoleWrite('Source Folder Is: ' & $src & @CR)
   $srcsz = GetFolderSize($src, "mb")
   ; check for required space
   $CopySpace = DriveSpaceFree($drive_letter)
   If $CopySpace < $srcsz Then
	  MsgBox(0, 'Error!', 'Not enough free space! DUCK AND COVER!!', 2)
	  Exit
   EndIf
   ; create target dir and set vars
   $trg = $drive_letter & @UserName & "at" & @ComputerName & '\' & StringStripWS(StringTrimLeft(StringReplace($src, "\", ""), 2), 8)
   If StringRight($trg, 1) <> "\" Then $trg = $trg & "\"
   ;ConsoleWrite('Target Folder Is: ' & $trg & @CR)
   DirCreate($trg)
   $trgsz = GetFolderSize($trg, "mb")
   $newtrgsz = $trgsz
   Global $FileList = _FileListToArray($src, 2)
   _ArrayDisplay($FileList)
   ; check for blank file list
   #cs
   STUFF STARTED HERE!!!!!
   #ce
   If @error = 4 Then
	  MsgBox(0,'Error!','Sorry, an error happened. No files in the source directory!', 2)
   EndIf
   For $l = 1 to $FileList[0]
	  If StringInStr($FileList[$l], ".", 2) = 0 Then
		 DirCopy($src, $trg, 1)
	  EndIf
   Next
   $FileList = _FileListToArray($src, 1)
   _ArrayDisplay($FileList)
   If @error = 4 Then
	  MsgBox(0,'Error!','Sorry, an error happened. No files in the source directory!', 2)
   EndIf
   ; start the progress bar if user wants it
   If MsgBox(32+4, 'Progress Bar?', 'Would You Like A Progress Bar?', 3) = 6 Then
	  ProgressOn("File Copy", "Copying...", "0 %")
   EndIf
   ; copy files
   For $j = 1 to $FileList[0]
	  ;enable progressbar here
	  ;Progress($srcsz, $trgsz, $newtrgsz)
	  FileCopy($src & $FileList[$j], $trg)
	  $newtrgsz = GetFolderSize($trg, "mb")
	  $k = $k + 1
   Next
   ; stop the progress bar
   ProgressOff()
   MsgBox(0,'','Copy Complete',2)
EndFunc

Func GetFolderSize($dir, $units)
   $obj = ObjCreate("Scripting.FileSystemObject")
   $folder = $obj.GetFolder($dir)
   If @error = 0 Then
        Select
        Case $units == "b"
            Return $folder.Size
        Case $units == "kb"
            Return $folder.Size/1024
        Case $units == "mb"
            Return $folder.Size/1024/1024
        Case $units == "gb"
            Return $folder.Size/1024/1024/1024
        Case $units == "tb"
            Return $folder.Size/1024/1024/1024/1024
        EndSelect
   Else
        MsgBox(0,"","An error occurred, " & $dir & " may not exist.", 2)
   EndIf
EndFunc