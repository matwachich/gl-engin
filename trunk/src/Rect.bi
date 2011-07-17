
''===================================
'' UDT: Rect
''===================================

Namespace GLE
	
	Constructor Rect()
		With This
			.x = 0
			.y = 0
			.w = 0
			.h = 0
		End With
	End Constructor
	
	Constructor Rect(ByVal x As Single, ByVal y As Single, ByVal w As Single, ByVal h As Single)
		With This
			.x = x
			.y = y
			.w = w
			.h = h
		End With
	End Constructor
	
	Operator Rect.Cast() As String
		Return "(" & This.x & " , " & This.y & " - " & This.w & " , " & This.h & ")"
	End Operator
	
End Namespace
