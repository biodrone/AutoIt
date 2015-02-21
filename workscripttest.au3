#cs
   Author: squ1r3ll
   Script Function: Test array searching for work script
#ce

;include all of the things
#include <File.au3>
#include <Array.au3>
#include <Misc.au3>
#include <Inet.au3>
#include <GUIConstantsEx.au3>
#include <MsgBoxConstants.au3>
#include <WindowsConstants.au3>

Main()

Func Main()
   Local $aArray[6][4]
   For $i = 0 To 5
	  For $j = 0 To 3
		 $aArray[$i][$j] = "#" & $i & $j
	  Next
   Next

   Local $hGUI = GUICreate("Example", 400, 200)
   Local $idExit = GUICtrlCreateButton("EXIT", 310, 170, 85, 25)
   Local $idOK = GUICtrlCreateButton("OK", 5, 170, 85, 25)
   Local $txtSearch = GUICtrlCreateInput("", 5, 5, 385)

   ; Display the GUI.
   GUISetState(@SW_SHOW, $hGUI)

   ; Loop until the user exits.
   While 1
	  Switch GUIGetMsg()
         Case $GUI_EVENT_CLOSE, $idExit
			ExitLoop
		 Case $GUI_EVENT_CLOSE, $idOK
			ExitLoop
	  EndSwitch
   WEnd

   ; Delete the previous GUI and all controls.
   GUIDelete($hGUI)

   ;_ArrayDisplay($aArray)

EndFunc