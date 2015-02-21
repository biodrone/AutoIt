; Forecourt Pinger

#include <MsgBoxConstants.au3>

Main()

Func Main()
	FindSite()
EndFunc

Func FindSite()
	Local $ip = "localhost"

	If StringInStr(@IPAddress1, "172") Then
		$ip = @IPAddress1
	ElseIf StringInStr(@IPAddress2, "172") Then
		$ip = @IPAddress2
	ElseIf StringInStr(@IPAddress3, "172") Then
		$ip = @IPAddress3
	ElseIf StringInStr(@IPAddress4, "172") Then
		$ip = @IPAddress4
	EndIf

	If (StringCompare($ip, "localhost")) Then
		MsgBox(0, "Error!", "The script has failed to find the IP address. You will now be prompted to find your site.")
		; insert site array finder here so that the site can choose what site they are if autodetect fails

	$siteIP = StringMid($ip, 8, 2)
	Return $siteIP
EndFunc

Func APPing($site)
	; pings the site's APs automagically

	; might be worth having a selection for if the FCT is north or south
	Local $ap1 = "172.16." & $site ".32"
	Local $ap2 = "172.16." & $site ".32"

	; add recursion 4 times if the ping fails to make sure that it's down
	; then let the user know
EndFunc
