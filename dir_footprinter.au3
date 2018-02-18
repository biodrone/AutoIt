#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author: biodrone
 Function: To make a list of files and/or folders in a directory and put them in
		   a text file
#ce ----------------------------------------------------------------------------

#include <File.au3>
#include <Array.au3>

Main()
Func Main()
	Local $src = "I:\Movies\"
	Local $txt = "I:\Movies.txt"
	Local $fileList = _FileListToArray($src)

   If @error Then
		 Exit
		 msgbox(0, "", "Error Happened... Oops.")
   Else
	  For $element in $fileList
		 If IsInt($element) = 1 Then
		 Else
			FileOpen($txt, 1)
			FileWrite($txt, $element & @CRLF)
		 EndIf
	  Next
	EndIf
EndFunc