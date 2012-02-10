
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
	
	Function Rect.Intersect(ByRef other_rect As Rect) As BOOL
		Dim As v2d half1, half2
		half1 = v2d(This.w / 2, This.h / 2)
		half2 = v2d(other_rect.w / 2, other_rect.h / 2)
		''===
		Dim As v2d center1, center2
		center1 = v2d(This.x + half1.x, This.y + half1.y)
		center2 = v2d(other_rect.x + half1.x, other_rect.y + half1.y)
		''===
		Dim As v2d dist
		dist = v2d(Abs(center1.x - center2.x), Abs(center1.y - center2.y))
		''===
		If dist.x <= half1.x + half2.x And dist.y <= half1.y + half2.y Then Return TRUE
		Return FALSE
	End Function

End Namespace
