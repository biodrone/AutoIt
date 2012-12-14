#include <File.au3>
#include <Array.au3>

Global $i = 0
Global $file1 = "C:\pwds\email-hashes-emails.txt"
Global $file2 = "C:\pwds\email-hashes-only.txt"
Global $write1 = ""
Global $write2 = ""
Global $array1 = ""
Global $array2 = ""
Global $chars = 46
Global $hash = ""

_FileReadToArray($file1, $array1)
_FileReadToArray($file2, $array2)

For $i = 1 To $array1[0]
   $write1 = $array1[$i]
   $write2 = $array2[$i]
   FileWrite("C:\pwds\email-hashes.txt", $write1 & ":" & $write2 & @CR)
Next
