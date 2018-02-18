#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         biodrone

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

#include <Array.au3>

Local $arr1[4] = [1, 2, 1, 2]
Local $Search_Result = _ArrayFindAll($arr1, 1)
;MsgBox(0, "TEST", $Search_Result)
;MsgBox(0, "", "")
_ArrayDisplay($arr1)

#cs
$arr1[0] = "4"
$arr1[1] = "1"
$arr1[2] = "2"
$arr1[3] = "3"
$arr1[4] = "4"
$arr1[5] = "1"
$arr1[6] = "2"
#ce

#cs
For $i = 0 to 6
   If $arr1[$i] = $arr1[$i + 1] Then
	  _ArrayDelete($arr1, $i)
   EndIf
   
Next
#ce