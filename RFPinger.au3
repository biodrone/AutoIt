#cs
Author: JJ
Script Function: Ping both ends of a forecourt RF link easily
#ce

#include <File.au3>
#include <Array.au3>

Global $sites[29][2]

Main()

Func Main()
	InitSites()
	For $i = 0 To 28
		;MsgBox(0, "test", "i is " & $i)
		;MsgBox(0, "test", "172.16." & $sites[0][1] & ".32")
		$ap1 = "172.16." & $sites[$i][1] & ".32"
		PingSite($ap1, $sites[$i][0])
		$ap2 = "172.16." & $sites[$i][1] & ".33"
		PingSite($ap2, $sites[$i][0])
	Next
EndFunc

Func InitSites()
	$sites[0][0] = "Abington"
	$sites[0][1] = 69
	$sites[1][0] = "Burtonwood"
	$sites[1][1] = 91
	$sites[2][0] = "Charnock"
	$sites[2][1] = 55
	$sites[3][0] = "Corley"
	$sites[3][1] = 75
	$sites[4][0] = "Derby"
	$sites[4][1] = 84
	$sites[5][0] = "Gretna"
	$sites[5][1] = 50
	$sites[6][0] = "Hartshead"
	$sites[6][1] = 61
	$sites[7][0] = "Hopwood"
	$sites[7][1] = 82
	$sites[8][0] = "Keele"
	$sites[8][1] = 60
	$sites[9][0] = "LFE"
	$sites[9][1] = 56
	$sites[10][0] = "Newport"
	$sites[10][1] = 51
	$sites[11][0] = "Telford"
	$sites[11][1] = 86
	$sites[12][0] = "Woodall"
	$sites[12][1] = 64
	$sites[13][0] = "Birchanger"
	$sites[13][1] = 66
	$sites[14][0] = "Cardiff"
	$sites[14][1] = 88
	$sites[15][0] = "Cobham"
	$sites[15][1] = 54
	$sites[16][0] = "Fleet"
	$sites[16][1] = 85
	$sites[17][0] = "Gordano"
	$sites[17][1] = 90
	$sites[18][0] = "LGW"
	$sites[18][1] = 65
	$sites[19][0] = "Membury North"
	$sites[19][1] = 53
	$sites[20][0] = "Membury South"
	$sites[20][1] = 57
	$sites[21][0] = "Michaelwood"
	$sites[21][1] = 58
	$sites[22][0] = "Oxford"
	$sites[22][1] = 80
	$sites[23][0] = "Peartree"
	$sites[23][1] = 81
	$sites[24][0] = "Sarn"
	$sites[24][1] = 82
	$sites[25][0] = "Sedgemoor"
	$sites[25][1] = 95
	$sites[26][0] = "South Mimms"
	$sites[26][1] = 67
	$sites[27][0] = "Warwick North"
	$sites[27][1] = 76
	$sites[28][0] = "Warwick South"
	$sites[28][1] = 77

	; _ArrayDisplay($sites)

EndFunc

Func PingSite($ip, $sSite)

	Local $file = FileOpen("C:\temp\test.txt", 1)

	; Check if file opened for writing OK
	If $file = -1 Then
		MsgBox(0, "Error", "Unable to open file.")
		Exit
	EndIf

	For $j = 0 to 3

		Local $var = Ping($ip)

		If $var Then ; also possible:  If @error = 0 Then ...
			FileWriteLine($file, $sSite & ": Online, roundtrip was:" & $var)
		Else
			FileWriteLine($file, $sSite & ": An error occured with number: " & @error)
			; MsgBox(0, "Status", "An error occured with number: " & @error)
		EndIf
	Next

	FileClose($file)

EndFunc