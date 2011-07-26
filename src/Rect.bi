
'File: Rect

Namespace GLE
	
	/'
	Class: Rect
		Simple 2D rectangle class
	
	Definition:
		(start code)
		Type Rect
			Declare Constructor()
			Declare Constructor(ByVal x As Single, ByVal y As Single, ByVal w As Single, ByVal h As Single)
			
			Declare Operator Cast() As String
			
			As Single x, y, w, h
		End Type
		(end)
	
	Property: x
		x Position of the top-left corner
		
	Property: y
		y Position of the top-left corner
		
	Property: w
		Width
		
	Property: h
		Height
	'/
	
	
	/'
	Constructor: Rect
		Rect Default constructor (0,0,0,0)
	'/
	Constructor Rect()
		With This
			.x = 0
			.y = 0
			.w = 0
			.h = 0
		End With
	End Constructor
	
	/'
	Constructor: Rect
		Rect Constructor
		
	Parameters:
		x - x Position of the top-left corner
		y - y Position of the top-left corner
		w - Width
		h - Height
	'/
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
