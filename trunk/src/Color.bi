
Namespace GLE
	
	Constructor T_Color()
		This.r = 255
		This.g = 255
		This.b = 255
		This.a = 255
		This.rVar = 0
		This.gVar = 0
		This.bVar = 0
		This.aVar = 0
	End Constructor
	
	Function T_Color.Get(ByVal who As UByte) As UByte
		Dim As Short min, max
		Dim As Short ret
		Select Case who
			Case 1
				min = This.r - This.rVar
				max = This.r + This.rVar
			Case 2
				min = This.g - This.gVar
				max = This.g + This.gVar
			Case 3
				min = This.b - This.bVar
				max = This.b + This.bVar
			Case 4
				min = This.a - This.aVar
				max = This.a + This.aVar
		End Select
		If min < 0 Then min = 0
		If max > 255 Then max = 256
		ret = (Rnd * (max - min)) + min
		If ret > 255 Then ret = 255
		If ret < 0 Then ret = 0
		Return ret
	End Function
	
	Sub T_Color.set(ByVal r As UByte, ByVal g As UByte, ByVal b As UByte, ByVal a As UByte)
		This.r = r
		This.g = g
		This.b = b
		This.a = a
	End Sub
	
	Sub T_Color.setVar(ByVal r As UShort, ByVal g As UShort, ByVal b As UShort, ByVal a As UShort)
		This.rVar = r
		This.gVar = g
		This.bVar = b
		This.aVar = a
	End Sub
	
End Namespace
