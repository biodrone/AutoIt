;remove gui and automate for device extract

Global Const $WS_CAPTION = 0x00C00000
Global Const $WS_POPUP = 0x80000000
Global Const $WS_POPUPWINDOW = 0x80880000
Global Const $WS_EX_ACCEPTFILES = 0x00000010
Global Const $TCS_FIXEDWIDTH = 0x00000400
Global Const $PBS_SMOOTH = 1
Global Const $SS_CENTER = 1
Global Const $GUI_EVENT_CLOSE = -3
Global Const $GUI_SHOW = 16
Global Const $GUI_BKCOLOR_TRANSPARENT = -2
Global Const $GUI_DROPACCEPTED = 8
Global Const $ES_NUMBER = 8192

$GUI = GUICreate("TCP File Transfer", 321, 228, -1, -1, BitOR($WS_POPUPWINDOW, $WS_CAPTION), $WS_EX_ACCEPTFILES)
GUICtrlCreateTab(10, 10, 300, 145, $TCS_FIXEDWIDTH)

GUICtrlCreateTabItem("Receiver")
GUICtrlSetState(-1, $GUI_SHOW)
$Receiver_Destination = GUICtrlCreateInput("", 24, 90, 187, 22)
GUICtrlCreateLabel("Select a destination directory. If one is not selected, it will be set to the desktop.", 24, 45, 272, 40)
GUICtrlSetFont(-1, 10)
$Receiver_Browse = GUICtrlCreateButton("Browse...", 221, 90, 75, 22, 0)
$Receiver_Wait = GUICtrlCreateButton("Wait for File", 24, 121, 272, 22, 0)

GUICtrlCreateTabItem("Sender")
GUICtrlCreateLabel("Select a file to send.", 29, 50, 262, 20)
GUICtrlSetFont(-1, 10)
$Sender_File = GUICtrlCreateInput("", 29, 80, 177, 22)
GUICtrlSetState(-1, $GUI_DROPACCEPTED)
$Sender_Browse = GUICtrlCreateButton("Browse...", 216, 80, 75, 22, 0)
$Sender_Chunk = GUICtrlCreateInput("5", 142, 113, 65, 22, $ES_NUMBER)
GUICtrlCreateLabel("Chunk Size in kb:", 29, 114, 107, 20)
GUICtrlSetFont(-1, 10)
GUICtrlSetLimit(-1, 2, 1)
$Sender_Send = GUICtrlCreateButton("Send", 216, 113, 75, 22, 0)
GUICtrlCreateTabItem("")

$Progress = GUICtrlCreateProgress(10, 192, 300, 25, $PBS_SMOOTH)
$Bytes_Label = GUICtrlCreateLabel("0kb / 0kb", 10, 168, 300, 20)
GUICtrlSetFont(-1, 10)
$Progress_Label = GUICtrlCreateLabel("0%", 10, 196, 300, 24, $SS_CENTER)
GUICtrlSetFont(-1, 12)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
GUISetState()

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Receiver_Browse
			$Dir = FileSelectFolder("Select a Destination Directory", @HomeDrive)
			If Not @error Then GUICtrlSetData($Receiver_Destination, $Dir)
			GUICtrlSetTip($Dir, GUICtrlRead($Receiver_Destination))
		Case $Receiver_Wait
			Select
				Case GUICtrlRead($Receiver_Destination) = ""
					GUICtrlSetData($Receiver_Destination, @DesktopDir)
				Case DirGetSize(GUICtrlRead($Receiver_Destination)) = -1
					GUICtrlSetData($Receiver_Destination, @DesktopDir)
			EndSelect
			_ReceiveFile(GUICtrlRead($Receiver_Destination), 5 * 1024 * 1024) ;file limit of 5 megabytes
			Switch @error
				Case 0
					MsgBox(262208, "TCP Sender", "Download Complete")
				Case 1
					MsgBox(16, "WSA:" & @error, "Unable to hook port!")
				Case 2
					MsgBox(16, "WSA:" & @error, "Lost connection!")
				Case 3
					MsgBox(16, "WSA:" & @error, "Lost connection!")
			EndSwitch
		Case $Sender_Browse
			$File = FileOpenDialog("Select a File To Send", @DesktopDir, "ALL (*.*)", 1 + 2)
			If Not @error Then GUICtrlSetData($Sender_File, $File)
			;GUICtrlSetTip($Dir, GUICtrlRead($Sender_File))
		Case $Sender_Send
			Select
				Case Not FileExists(GUICtrlRead($Sender_File))
					MsgBox(262192, "ERROR", "Invalid file!")
				Case GUICtrlRead($Sender_Chunk) > 20
					MsgBox(262192, "ERROR", "Chunk size specified is too large!")
				Case GUICtrlRead($Sender_Chunk) < 5
					MsgBox(262192, "ERROR", "Chunk size specified is too small!")
				Case Else
					_SendFile(GUICtrlRead($Sender_File), GUICtrlRead($Sender_Chunk) * 1024)
					Switch @error
						Case 0
							MsgBox(262208, "TCP Sender", "Upload Complete")
						Case 1
							MsgBox(16, "ERROR", "Bad file")
						Case 2
							MsgBox(16, "ERROR", "You can't send directories!")
						Case 3
							MsgBox(16, "WSA:" & @extended, "Unable to connect to the host!")
						Case 4
							MsgBox(16, "WSA:" & @error, "Lost connection!")
						Case 5
							MsgBox(16, "ERROR", "That's odd!" & @CRLF & 'I got: "' & @extended & '" from the socket!')
						Case 6
							MsgBox(16, "WSA:" & @error, "Lost connection!")
						Case 7
							MsgBox(16, "ERROR", "That's odd!" & @CRLF & 'I got: "' & @extended & '" from the socket!')
					EndSwitch
			EndSelect
	EndSwitch
	Sleep(15)
WEnd

Func _SendFile($File, $MaxLen)
	Local $BytesRead = 0

	$Size = FileGetSize($File)
	If $Size = 0 Then Return SetError(1, 0, -1)

	;get file name
	$Reg = StringRegExp($File, "(.)+\\((.)+)?", 3)
	ConsoleWrite($Reg & @CRLF)
	Select
		Case Not IsArray($Reg)
			$Name = $Reg
		Case UBound($Reg) < 2
			Return SetError(2, 0, -1)
		Case Else
			$Name = $Reg[1]
	EndSelect
	$IP = InputBox("IP Address", "What is the IP address of the server?", "")

	$Socket = TCPConnect($IP, 8081)
	If @error Then Return SetError(3, @error, -1)

	;wait until something is sent
	Do
		$Receive = TCPRecv($Socket, 1000)
		If @error Then Return SetError(4, 0, -1)
		Sleep(10)
	Until $Receive <> ""

	If $Receive <> "Sending Data" Then Return SetError(5, $Receive, -1)

	;Send Name and file size to receiver
	TCPSend($Socket, $Name & ":" & $Size)

	;Wait for confirmation from receiver
	Do
		$Receive = TCPRecv($Socket, 1000)
		If @error Then SetError(6, 0, -1)
	Until $Receive <> ""

	If $Receive <> "Start Upload" Then SetError(7, $Receive, -1)

	;open file to read in binary
	$FileHandle = FileOpen($File, 16)

	;loop until the whole file is received
	While 1
		$Data = FileRead($FileHandle, $MaxLen)
		If @error Then ExitLoop

		$BytesRead += TCPSend($Socket, $Data)

		If GUICtrlRead($Progress) <> Round($BytesRead / $Size * 100) Then
			GUICtrlSetData($Progress, Round($BytesRead / $Size * 100))
			GUICtrlSetData($Bytes_Label, Round($BytesRead / 1024) & " kb / " & Round($Size / 1024) & " kb")
			GUICtrlSetData($Progress_Label, Round($BytesRead / $Size * 100) & "%")
		EndIf
	WEnd
	FileClose($FileHandle)
	TCPCloseSocket($Socket)

	Return SetError(0, 0, 1)
EndFunc   ;==>_SendFile

Func OnAutoItStart()
	TCPStartup()
EndFunc

Func OnAutoItExit()
	TCPShutdown()
EndFunc

Func _ReceiveFile($Destination, $MaxLen)
	Local $Return = False, $Bytes = 0
	TCPStartup()

	$Listen = TCPListen("127.0.0.1", 8081) ;erroring here, not hooking port
	If @error Then Return SetError(1, 0, -1)

	ToolTip("Listening" & @CRLF & @IPAddress1 & @CRLF & 8081, 0, 0)

	;wait for sender to connect
	Do
		$Socket = TCPAccept($Listen)
	Until $Socket <> -1

	$Receive = TCPRecv($Socket, $MaxLen)
	If @error Then Return SetError(2, 0, -1)

	TCPSend($Socket, "Sending Data")

	;get file data
	;wait for file name and size to be sent
	Do
		$Receive = TCPRecv($Socket, 1000)
		If @error Then Return SetError(3, 0, -1)
		Sleep(5)
	Until $Receive <> ""
	$FileData = StringSplit($Receive, ":", 2)

	$Destination &= "\" & $FileData[0]

	$FileHandle = FileOpen($Destination, 16 + 2 + 8)

	;initiate download
	TCPSend($Socket, "Start Upload")

	While 1
		$Data = TCPRecv($Socket, $MaxLen, 1) ;receive data in binary
		If @error Then ExitLoop

		$Bytes += BinaryLen($Data) ;count number of bytes sent

		FileWrite($FileHandle, $Data) ;recreate the file sent

		If GUICtrlRead($Progress) <> Round($Bytes / $FileData[1] * 100) Then
			GUICtrlSetData($Progress, Round($Bytes / $FileData[1] * 100))
			GUICtrlSetData($Bytes_Label, Round($Bytes / 1024) & " kb / " & Round($FileData[1] / 1024) & " kb")
			GUICtrlSetData($Progress_Label, Round($Bytes / $FileData[1] * 100) & "%")
		EndIf
	WEnd
	FileClose($FileHandle)
	TCPCloseSocket($Socket)
	TCPCloseSocket($Listen)
	ToolTip("")

	Return SetError(0, 0, 1)
EndFunc   ;==>_ReceiveFile