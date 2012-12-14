#cs ----------------------------------------------------------------------------
Author: squ1r3ll
Script Function:
	Takes media put into a folder and sorts it into another place [media drive]
	so that it can be scanned properly by media streamers
#ce ----------------------------------------------------------------------------

;include timez
#include <File.au3>
#include <Array.au3>

Main()
Func Main()
   ;tell it where to find the media
   Global $dropbox = "E:\Documents\Dropbox\MediaTemp\"
   Global $media = "I:\TV\"
   
   ;do all the file goodness
   Populate($dropbox)
EndFunc

Func Populate($src)
   Local $fileList = _FileListToArray($src)
   Local $i = 0

   ;gets the info for the individual files
   If @error Then
		 Exit
   Else
	  For $element in $fileList
		 If IsInt($element) = 1 Then
		 Else
			Local $filename = StringSplit($element, ".")
			Local $show = $filename[1] ;extract the show title
			Local $season = StringLeft($filename[2], 3) ;extract the season
		 
			move($show, seasonCalc($season), $element) ;move the file
		 EndIf
	  Next
   EndIf
EndFunc

Func seasonCalc($s)
   Select
   Case $s = "S01"
	  Return "Season 1"
   Case $s = "S02"
	  Return "Season 2"
   Case $s = "S03"
	  Return "Season 3"
   Case $s = "S04"
	  Return "Season 4"
   Case $s = "S05"
	  Return "Season 5"
   Case $s = "S06"
	  Return "Season 6"
   Case $s = "S07"
	  Return "Season 7"
   Case $s = "S08"
	  Return "Season 8"
   Case $s = "S09"
	  Return "Season 9"
   Case $s = "S10"
	  Return "Season 10"
   Case $s = "S11"
	  Return "Season 11"
   EndSelect
EndFunc

Func move($show, $season, $name)
   Local $fShow = $show & "\"
   Local $fSeason = $season & "\"
   Local $source = $dropbox & $name
   Local $dest = $media & $fShow & $fSeason & $name

   FileMove($source, $dest)
EndFunc