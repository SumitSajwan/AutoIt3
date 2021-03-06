#include-once

; This routine came from the LiveLinux program and modified by Doug Kaynor

Func _CRC32($InputData, $type, $CRC32 = -1)
	Local $Opcode = '0xC800040053BA2083B8EDB9000100008D41FF516A0859D1E8730231D0E2F85989848DFCFBFFFFE2E78B5D088B4D0C8B451085DB7416E3148A1330C20FB6D2C1E80833849500FCFFFF43E2ECF7D05BC9C21000'
local $Data
	;ConsoleWrite(@ScriptLineNumber & "  " & $type & "  " & $CRC32 &  "  " & $InputData & @CRLF)

	If $type = "file" Then
		Local $Handle = FileOpen($InputData, 16)
		$Data = FileRead($Handle)

		FileClose($Handle)
	ElseIf $type = "string" Then
		$Data = $InputData
	Else
		MsgBox(48, "Type check", "Invalid type secified: " & $type & @CRLF & "Should be file or string")
		Return -1
	EndIf

	Local $CodeBuffer = DllStructCreate("byte[" & BinaryLen($Opcode) & "]")
	DllStructSetData($CodeBuffer, 1, $Opcode)

	Local $Input = DllStructCreate("byte[" & BinaryLen($Data) & "]")
	DllStructSetData($Input, 1, $Data)

	Local $Ret = DllCall("user32.dll", "uint", "CallWindowProc", "ptr", DllStructGetPtr($CodeBuffer), _
			"ptr", DllStructGetPtr($Input), _
			"int", BinaryLen($Data), _
			"uint", $CRC32, _
			"int", 0)

	$Input = 0
	$CodeBuffer = 0
	Return $Ret[0]
EndFunc   ;==>_CRC32