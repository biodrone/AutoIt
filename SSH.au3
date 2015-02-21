#cs
   SSH Snippet taken from the webbernets
#ce

Func _Connect($host,$usr,$pass)
    $exec = @ScriptDir & "\PLINK.EXE"
    If Not FileExists($exec) Then _Err("PLINK.EXE Not Found!",0)
    ;If $debug Then
        ;$pid = Run($exec & " -ssh -pw " & $pass & " " & $usr & "@" & $host, @SystemDir, @SW_SHOW, 0x1 + 0x8)  ;Run SSH.EXE
    ;Else
        $pid = Run($exec & " -ssh -pw " & $pass & " " & $usr & "@" & $host, @SystemDir, "", 0x1 + 0x8)  ;Run SSH.EXE
    ;EndIf
    If Not $pid Then _Err("Failed to connect",0)
    $currentpid = $pid
    $rtn = _Read($pid)  ;Check for Login Success - Prompt
    If StringInstr($rtn,"(y/n)") Then
        _Send($pid,"y" & @CR)
        $rtn = _Read($pid)
    EndIf
    If StringInstr($rtn,"yes/no") Then
        _Send($pid,"yes" & @CR)
        $rtn = _Read($pid)
    EndIf
    If StringInstr($rtn,"Access denied") Or StringInstr($rtn,"FATAL")Then _Err($rtn,$pid)
    Return $pid
EndFunc

Func _Read($pid)
    If Not $pid Then Return -1
    Local $dataA
    Local $dataB
    Do
        $dataB = $dataA
        sleep(100)
        $dataA &= StdOutRead($pid)
        If @error Then ExitLoop
    Until $dataB = $dataA And $dataA And $dataB
    ;If $debug Then FileWriteLine(@ScriptDir & "\log.txt",$dataA & @CRLF)
    Return $dataA
EndFunc

Func _Send($pid,$cmd)
    StdinWrite($pid,$cmd)
EndFunc

Func _Err($data,$pid)
    If $data And $data <> -1 Then MsgBox(0,"An Error has Occured",$data,5)
    _Exit($pid)
EndFunc

Func _Exit($pid)
    ProcessClose($pid)
EndFunc