; #FUNCTION# ====================================================================================================================
; Name ..........: isInsideDiamondXY, isInsideDiamond
; Description ...: This function can test if a given coordinate is inside (True) or outside (False) the village grass borders (a diamond shape).
;                  It will also exclude some special area's like the CHAT tab, BUILDER button and GEM shop button.
; Syntax ........: isInsideDiamondXY($Coordx, $Coordy), isInsideDiamond($aCoords)
; Parameters ....: ($Coordx, $CoordY) as coordinates or ($aCoords), an array of (x,y) to test
; Return values .: True or False
; Author ........: Hervidero (2015-may-21)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================


Func isInsideDiamondXY($Coordx, $Coordy)

	Local $aCoords = [$Coordx, $Coordy]
	Return isInsideDiamond($aCoords)

EndFunc   ;==>isInsideDiamondXY

Func isInsideDiamond($aCoords)
	Local $x = $aCoords[0], $y = $aCoords[1], $xD, $yD
	;Local $Left = 15, $Right = 835, $Top = 30, $Bottom = 645 ; set the diamond shape 860x780
	Local $Left = 0, $Right = 855, $Top = 20, $Bottom = 675 ; set the diamond shape based on reference village
	Local $aDiamond[2][2] = [[$Left, $Top], [$Right, $Bottom]]
	Local $aMiddle = [($aDiamond[0][0] + $aDiamond[1][0]) / 2, ($aDiamond[0][1] + $aDiamond[1][1]) / 2]

	; convert to real diamond compensating zoom and offset
	; top diamond point
	$xD = $aMiddle[0]
	$yD = $Top
	ConvertToVillagePos($xD, $yD)
	$Top = $yD
	; bottom diamond point
	$xD = $aMiddle[0]
	$yD = $Bottom
	ConvertToVillagePos($xD, $yD)
	$Bottom = $yD
	; left diamond point
	$xD = $Left
	$yD = $aMiddle[1]
	ConvertToVillagePos($xD, $yD)
	$Left = $xD
	; right diamond point
	$xD = $Right
	$yD = $aMiddle[1]
	ConvertToVillagePos($xD, $yD)
	$Right = $xD

	;If $debugsetlog = 1 Then SetLog("isInsideDiamond coordinates updated by offset: " & $Left & ", " & $Right & ", " & $Top & ", " & $Bottom, $COLOR_DEBUG)

	Local $aDiamond[2][2] = [[$Left, $Top], [$Right, $Bottom]]
	Local $aMiddle = [($aDiamond[0][0] + $aDiamond[1][0]) / 2, ($aDiamond[0][1] + $aDiamond[1][1]) / 2]
	Local $aSize = [$aMiddle[0] - $aDiamond[0][0], $aMiddle[1] - $aDiamond[0][1]]

	Local $DX = Abs($x - $aMiddle[0])
	Local $DY = Abs($y - $aMiddle[1])

	If ($DX / $aSize[0] + $DY / $aSize[1] <= 1) Then
		If $x < 75 Then ; coordinates where the game will click on the CHAT tab (safe margin)
			If $debugSetlog = 1 Then SetDebuglog("Coordinate Inside Village, but Exclude CHAT")
			Return False
		ElseIf $x < 322 And $y < 70 Then ; coordinates where the game will click on the BUILDER button (safe margin)
			If $debugSetlog = 1 Then SetDebuglog("Coordinate Inside Village, but Exclude BUILDER")
			Return False
		ElseIf $x > 690 And $y < 210 Then ; coordinates where the game will click on the GEMS button (safe margin)
			If $debugSetlog = 1 Then SetDebuglog("Coordinate Inside Village, but Exclude GEMS")
			Return False
		EndIf
		;If $debugSetlog = 1 Then SetDebuglog("Coordinate Inside Village", $COLOR_DEBUG)
		Return True ; Inside Village
	Else
		If $debugSetlog = 1 Then SetDebuglog("Coordinate Outside Village")
		Return False ; Outside Village
	EndIf

EndFunc   ;==>isInsideDiamond

#cs
Global $debugSetlog = 1
Func SetDebugLog($text)
	ConsoleWrite($text & @CRLF)
EndFunc
Local $aTests[2][2] = [[595, 463], [575, 328]]
Local $i, $x, $y
For $i = 0 To UBound($aTests) - 1
	$x = $aTests[$i][0]
	$y = $aTests[$i][1]
	SetDebugLog($x & ", " & $y & ":" & isInsideDiamondXY($x, $y))
Next
#ce