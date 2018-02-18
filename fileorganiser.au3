#cs ----------------------------------------------------------------------------
 AutoIt Version: 3.3.8.1
 Author:         biodrone
 Version: 0.0.2
 Script Function:
	Script to search through parsed text files for emails
	And sort these text files by the first field
#ce ----------------------------------------------------------------------------
#include <Array.au3>
#include <File.au3>

Main ()

Func Main()
   Global $tarfile = "C:\antisec-parsed.txt"
   Global $newfile = "" ;StringMid($tarfile, 1, StringLen($tarfile) - 4) & "-parsed.txt"
   Global $linecount = 0
   Global $searchstr = ""
   Global $i = 0
   Global $j = 0
   Global $k = 0
   Global $l = 0
   Global $m = 0
   Global $sortname = ""
   ; email addresses to search for
   Global $emails[7] = ['gmail.com', 'yahoo.com', 'msn.com', 'hotmail.com','hotmail.co.uk', 'aol.com', 'msn.co.uk']
   Global $filenames[7] = ['','','','','','','']
   
   CheckFile()
   For $j = 0 to 6
	  $sortname = "C:\" & $emails[$j]
	  Parse($emails[$j])
	  $filenames[$j] = $newfile
	  ;_ArrayDisplay($filenames)
	  If _FileCountLines($newfile) <= 1 Then
		 FileDelete($newfile)
		 MsgBox(16, "Number of Addresses", "That's " & _FileCountLines($newfile) & " " & $emails[$j] & " Emails! Deleting...", 2)
	  Else
		 MsgBox(0, "Number of Addresses", "That's " & _FileCountLines($newfile) & " " & $emails[$j] & " Emails!", 2)
	  EndIf
   Next
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
   EndIf
EndFunc
; this parses the file
Func Parse($searchstr)
   $email = ""
   $id = ""
   $pass = ""
   $user = ""
   $start = 1
   $end = 0
   $count = 1
   Local $delim = ';' ; change this for a different char between fields (read)
   
   FileOpen($tarfile, 0)
   ;$searchstr = InputBox("Email?", "What Email Would You Like To Search For?")
   $newfile = StringMid($tarfile, 1, StringLen($tarfile) - 4) & "-" & $searchstr & ".txt"
   _FileCreate($newfile)
   
   For $m = 1 to $linecount
	  $alldets = StringReplace(FileReadLine($tarfile, $m), '"', '')
	  If StringInStr($alldets, $searchstr) Then
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
	  Write($email, $pass, $id, $user)
	  EndIf
Next
   Sort()
EndFunc
; write to the file
Func Write($one, $two, $three, $four)
   Local $delim = ';' ; change this for a different char between fields (written)
   Local $writestring = $one & $delim & $two & $delim & $three & $delim & $four & @CR
   Local $usrpas = $one & ":" & $two & @CR
   
   If $one = " " OR $two = " " OR $three = " " OR $four = " " Then
	  ConsoleWrite("Blank Variable Passed to Write!")
   Else
	  FileOpen($newfile, 1)
	  FileWrite($newfile, $writestring)
	  FileClose($newfile)
	  FileOpen($sortname & "-usrpass.txt", 1)
	  FileWrite($sortname & "-usrpass.txt", $usrpas)
	  FileClose($sortname & "-usrpass.txt")
   EndIf
EndFunc

Func Sort()
   Local $sortedfile
   Local $cnt = 0
    
   _FileReadToArray($newfile, $sortedfile)
  _ArraySort($sortedfile)
  _FileCreate($sortname & "-sort.txt")
  _FileWriteFromArray($sortname & "-sort.txt", $sortedfile, 1)
  FileDelete($newfile)
  $cnt += 1
EndFunc
