
''===================================
'' UDT: v2d Implementation
''===================================
	
Namespace GLE
	
	' Default Constructor: (0,0)
	Constructor v2d()
		This.x = 0
		This.y = 0
	End Constructor
	
	' Constructor: (x,y)
	Constructor v2d(ByVal x As Single, ByVal y As Single)
		This.x = x
		This.y = y
	End Constructor
	''===================================================================================================
	
	' 
	Sub v2d.FromAngle(ByVal degrees As Single, ByVal lenght As Single)
		'If degrees >= 360 Then degrees = _ReduceAngle(degrees) ' called in _DegToRad
		Select Case degrees
			Case 0
				This.x = lenght
				This.y = 0
				Exit Sub
			Case 90
				This.x = 0
				This.y = lenght
				Exit Sub
			Case 180
				This.x = -1 * lenght
				This.y = 0
				Exit Sub
			Case 270
				This.x = 0
				This.y = -1 * lenght
				Exit Sub
		End Select
		''=================
		Dim As Single rad = _DegToRad(degrees)
		This.x = Cos(rad) * lenght
		This.y = Sin(rad) * lenght
	End Sub
	
	' 
	Function v2d.ToVectAngle(ByRef vect As v2d) As Single
		If This.x = vect.x And This.y = vect.y Then Return 0

		Dim As Single difX = vect.x - This.x
		Dim As Single difY = vect.y - This.y
		Dim As Single tmp = Abs(Atn(difY / difX))

		If difX < 0 Then tmp = _PI - tmp
		If difY < 0 Then tmp = _PI + (_PI - tmp)

		Return _RadToDeg(tmp)
	End Function
	
	' 
	Function v2d.ToVectDist(ByRef vect As v2d) As Single
		Return Sqr(((This.x - vect.x)*(This.x - vect.x)) + ((This.y - vect.y)*(This.y - vect.y)))
	End Function
	
	Function v2d.Grandeur() As Single
		Return Sqr((This.x * This.x) + (This.y * This.y))
	End Function
	
	Function v2d.Angle() As Single
		Dim As Single tmp = Abs(Atn(This.y / This.x))

		If This.x < 0 Then tmp = _PI - tmp
		If This.y < 0 Then tmp = _PI + (_PI - tmp)

		Return _RadToDeg(tmp)
	End Function
	
	''===================================================================================================
	'' Operators
	''===================================================================================================
	
	Operator v2d.Cast() As String
		Return "(" & This.x & " , " & This.y & ")"
	End Operator
	
	Operator +(ByRef _1 As v2d, ByRef _2 As v2d) As v2d
		Return Type(_1.x + _2.x, _1.y + _2.y)
	End Operator
	Operator -(ByRef _1 As v2d, ByRef _2 As v2d) As v2d
		Return Type(_1.x - _2.x, _1.y - _2.y)
	End Operator
	Operator *(ByRef _1 As v2d, ByRef _2 As v2d) As v2d
		Return Type(_1.x * _2.x, _1.y * _2.y)
	End Operator
	
	Operator *(ByRef vect As v2d, ByVal nbr As Single) As v2d
		Return Type(vect.x * nbr, vect.y * nbr)
	End Operator
	Operator *(ByVal nbr As Single, ByRef vect As v2d) As v2d
		Return Type(vect.x * nbr, vect.y * nbr)
	End Operator
	
	Operator =(ByRef _1 As v2d, ByRef _2 As v2d) As BOOL
		If _1.x = _2.x And _1.y = _2.y Then Return TRUE
		Return FALSE
	End Operator
	Operator <>(ByRef _1 As v2d, ByRef _2 As v2d) As BOOL
		If _1.x = _2.x And _1.y = _2.y Then Return FALSE
		Return TRUE
	End Operator
	
End Namespace
