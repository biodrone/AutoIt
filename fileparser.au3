#cs ----------------------------------------------------------------------------
 AutoIt Version: 3.3.8.1
 Author:         squ1r3ll
 Version: 0.0.2
 Script Function:
	Script to parse through text files
#ce ----------------------------------------------------------------------------
#include <Array.au3>
#include <File.au3>

Main ()

Func Main()
   Global $tarfile = "C:\antisec.txt"
   Global $newfile = StringMid($tarfile, 1, StringLen($tarfile) - 4) & "-parsed.txt"
   Global $linecount = 0
   Global $i = 0
   Global $j = 0
   Global $k = 0
   Global $l = 0
   Global $m = 0
   
   _FileCreate($newfile)
   CheckFile()
   Parse()
EndFunc
; checks that the file is parsable
Func CheckFile()
   If FileExists($tarfile) = 0 Then
	  MsgBox(0, 'File Not Found', 'Sorry, File Not Found!')
   Else
	  ConsoleWrite("File Exists" & @CR)
   EndIf
   If StringInStr($tarfile, '.txt') = 0 Then
	  MsgBox('Incorrect Format', 'Sorry, File Format Must Be .txt')
   Else
	  ConsoleWrite("File Format OK" & @CR)
   EndIf
   If @error = 0 Then
	  ; find the lines in the file to set max array limits
	  $linecount = _FileCountLines($tarfile)
	  ConsoleWrite('Lines in file = ' & $linecount & @CR)
   Else
	  Exit
   EndIf
EndFunc
; this parses the file
Func Parse()
   $email = ""
   $id = ""
   $pass = ""
   $user = ""
   $start = 1
   $end = 0
   $count = 1
   Local $delim = ',' ; change this for a different char between fields (read)
   
   FileOpen($tarfile, 0)
   For $m = 1 to $linecount
	  $alldets = StringReplace(FileReadLine($tarfile, $m), '"', '')
	  While $count <= 4
		 If $start = 0 Then
			$end = StringInStr($alldets, $delim, 0,$count + 1)
		 Else
			$end = StringInStr($alldets, $delim, 0,$count)
		 EndIf
		 Select 
		 Case $count = 1
			$email = StringMid($alldets, $start, $end-$start)
		 Case $count = 2
			$id = StringMid($alldets, $start, $end-$start)
		 Case $count = 3
			$pass = StringMid($alldets, $start, $end-$start)
		 Case $count = 4
			$user = StringMid($alldets, $start, $end-$start)
		 EndSelect
		 $start = $end + 1
		 $count += 1
	  WEnd
	  $count = 0
	  Write($email, $id, $pass, $user)
   Next
   
   FileClose($newfile)
EndFunc
; write to the file
Func Write($one, $two, $three, $four)
   Local $delim = ';' ; change this for a different char between fields (written)
   Local $writestring = $one & $delim & $two & $delim & $three & $delim & $four & @CR
   
   FileOpen($newfile, 1)
   FileWrite($newfile, $writestring)
EndFunc
