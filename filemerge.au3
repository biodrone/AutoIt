#cs ----------------------------------------------------------------------------
 AutoIt Version: 3.3.8.1
 Author:         squ1r3ll
 Script Function:
	Merge a bunch of files [from an array] into one file
#ce ----------------------------------------------------------------------------

#include <fileorganiser.au3>
#include <File.au3>
#include <Array.au3>

Local $i = 0
Global $emails[7] = ['gmail.com', 'yahoo.com', 'msn.com', 'hotmail.com','hotmail.co.uk', 'aol.com', 'msn.co.uk']

For $i = 0 to $filenames
   $file = "C:\" & $emails[$i] & "-sort.txt"
Next