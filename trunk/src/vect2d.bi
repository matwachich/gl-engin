
'File: vect2d

Namespace GLE
	
	/'
	Class: v2d
		2D Vector class
	
	Definition:
		(start code)
		Type v2d
			Declare Constructor()
			Declare Constructor(ByVal x As Single, ByVal y As Single)
			Declare Constructor(ByVal angle As Single, ByVal _len As Single, ByVal from_angle As Byte)
			
			Declare Sub FromAngle(ByVal degrees As Single, ByVal lenght As Single)
			
			Declare Sub Scale(ByVal ratio As Single)
			Declare Sub SetLen(ByVal new_len As Single)
			Declare Sub SetAngle(ByVal new_angle As Single)
			
			Declare Function ToVect_Angle(ByRef vect As v2d) As Single
			Declare Function ToVect_Len(ByRef vect As v2d) As Single
			
			Declare Function Len() As Single
			Declare Function Angle() As Single
			
			Declare Function IsInRect(ByVal test As Rect) As BOOL
			Declare Function IsInCircle(ByVal center As v2d, ByVal radius As Single) As BOOL
			
			Declare Operator Cast() As String
	
			As Single x, y
		End Type
		(end)
	
	Property: x
	
	Property: y
	'/
	
	/'
	Constructor: v2d
		v2d Default constructor (0,0)
	'/
	Constructor v2d()
		This.x = 0
		This.y = 0
	End Constructor
	
	/'
	Constructor: v2d
		v2d constructor (x,y)
	
	Parameters:
		x, y - Vector
	'/
	Constructor v2d(ByVal x As Single, ByVal y As Single)
		This.x = x
		This.y = y
	End Constructor
	
	/'
	Constructor: v2d
		Overloaded constructor, takes an Angle and a Lenght as parameters.
		The last parameter is here just to make the a difference with the first constructor.
	
	Parameters:
		angle (Single) - Angle
		_len (Single) - Lenght
		from_angle (Byte) - Dummy parameter, can be what you want!
	'/
	'Constructor v2d(ByVal angle As Single, ByVal _len As Single, ByVal from_angle As Byte)
	'	This.FromAngle(angle, _len)
	'End Constructor
	''===================================================================================================
	
	/'
	Method: FromAngle
		Set the values of x, y according to an Angle (degrees) and a vector lenght
	
	Parameters:
		degrees - Angle (in degrees)
		lenght - Lenght of the desired vector
	'/ 
	Sub v2d.FromAngle(ByVal degrees As Single, ByVal lenght As Single)
		If lenght = 0 Then
			This.x = 0
			This.y = 0
			Return
		EndIf
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
	
	/'
	Method: Scale
		Scale the lenght of a vector
	
	Parameters:
		ratio (Single) - Scale ratio
	'/
	Sub v2d.Scale(ByVal ratio As Single)
		This.FromAngle(This.Angle(), This.Len() * ratio)
	End Sub
	
	/'
	Method: SetLen
		Change the lenght of a vector without changing it's angle
	
	Parameters:
		new_len (Single) - New vector's lenght
	'/
	Sub v2d.SetLen(ByVal new_len As Single)
		This.FromAngle(This.Angle(), new_len)
	End Sub
	
	/'
	Method: SetAngle
		Change a vector's angle without changing it's lenght
	
	Parameters:
		angle (Single) - New vector's angle
	'/
	Sub v2d.SetAngle(ByVal new_angle As Single)
		This.FromAngle(new_angle, This.Len())
	End Sub
	
	/'
	Method: ToVect_Angle
		Returns the angle (in degrees) between *This* point and another point (v2d)
	
	Parameters:
		vect - v2d instance
	
	Returns:
		Single - Angle (in degrees)
	'/
	Function v2d.ToVect_Angle(ByRef vect As v2d) As Single
		If This.x = vect.x And This.y = vect.y Then Return 0

		Dim As Single difX = vect.x - This.x
		Dim As Single difY = vect.y - This.y
		Dim As Single tmp = Abs(Atn(difY / difX))

		If difX < 0 Then tmp = _PI - tmp
		If difY < 0 Then tmp = _PI + (_PI - tmp)

		Return _RadToDeg(tmp)
	End Function
	
	/'
	Method: ToVect_Len
		Returns the lenght between *This* point and another point (v2d)
	
	Parameters:
		vect - v2d instance
	
	Returns:
		Single - Lenght
	'/
	Function v2d.ToVect_Len(ByRef vect As v2d) As Single
		Return Sqr(((This.x - vect.x)*(This.x - vect.x)) + ((This.y - vect.y)*(This.y - vect.y)))
	End Function
	
	/'
	Method: Len
		Returns the lenght of *This* vector
	
	Returns:
		Single - Lenght
	'/
	Function v2d.Len() As Single
		Return Sqr((This.x * This.x) + (This.y * This.y))
	End Function
	
	/'
	Method: Angle
		Returns the angle (in degrees) of *This* vector
	
	Returns:
		Single - Angle (in degrees)
	'/
	Function v2d.Angle() As Single
		If This.x = 0 And This.y = 0 Then Return 0
		Dim As Single tmp = Abs(Atn(This.y / This.x))

		If This.x < 0 Then tmp = _PI - tmp
		If This.y < 0 Then tmp = _PI + (_PI - tmp)

		Return _RadToDeg(tmp)
	End Function
	
	/'
	Method: IsInRect
		Checks if *This* point is IN a specified *Rect*
	
	Parameters:
		test - Rect instance
	
	Returns:
		BOOL - *True* If point in rect, otherwise *False*
	'/
	Function v2d.IsInRect(ByVal test As Rect) As BOOL
		If This.x > test.x And This.x < (test.x + test.w) And This.y > test.y And This.y < (test.y + test.h) Then Return TRUE
		Return FALSE
	End Function
	
	/'
	Method: IsInCircle
		Checks if *This* point is IN a circle specified by its center and radius
	
	Parameters:
		center (v2d) - Center point of the circle
		radius (Single) - Radius of the circle
	
	Returns:
		BOOL - *True* if point in circle, otherwise *False*
	'/
	Function v2d.IsInCircle(ByVal center As v2d, ByVal radius As Single) As BOOL
		If This.ToVect_Len(center) < radius Then Return TRUE
		Return FALSE
	End Function
	
	''===================================================================================================
	'' Operators
	''===================================================================================================
	
	/'
	Operator: Cast
		Returns a string: "(x , y)"
	'/
	Operator v2d.Cast() As String
		Return "(" & This.x & " , " & This.y & ")"
	End Operator
	
	/'
	Operator: v2d + v2d
		Returns v2d(1.x + 2.x, 1.y + 2.y)
	'/
	Operator +(ByRef _1 As v2d, ByRef _2 As v2d) As v2d
		Return Type(_1.x + _2.x, _1.y + _2.y)
	End Operator
	
	/'
	Operator: v2d - v2d
		Returns v2d(1.x - 2.x, 1.y - 2.y)
	'/
	Operator -(ByRef _1 As v2d, ByRef _2 As v2d) As v2d
		Return Type(_1.x - _2.x, _1.y - _2.y)
	End Operator
	
	/'
	Operator: v2d * v2d
		Returns v2d(1.x * 2.x, 1.y * 2.y)
	'/
	Operator *(ByRef _1 As v2d, ByRef _2 As v2d) As v2d
		Return Type(_1.x * _2.x, _1.y * _2.y)
	End Operator
	
	/'
	Operator: v2d * nbr Or nbr * v2d
		Returns v2d(x * nbr, y * nbr)
	'/
	Operator *(ByRef vect As v2d, ByVal nbr As Single) As v2d
		Return Type(vect.x * nbr, vect.y * nbr)
	End Operator
	Operator *(ByVal nbr As Single, ByRef vect As v2d) As v2d
		Return Type(vect.x * nbr, vect.y * nbr)
	End Operator
	
	/'
	Operator: v2d / v2d
		Returns v2d(1.x / 2.x, 1.y / 2.y)
	'/
	Operator /(ByVal v1 As v2d, ByVal v2 As v2d) As v2d
		Return Type(v1.x / v2.x, v1.y / v2.y)
	End Operator
	
	/'
	Operator: v2d / nbr
		Returns v2d(1.x / nbr, 1.y / nbr)
	'/
	Operator /(ByVal vect As v2d, ByVal nbr As Single) As v2d
		Return Type(vect.x / nbr, vect.y / nbr)
	End Operator
	
	/'
	Operator: v2d =/<> v2d
		Check equality between 2 <v2d>
	'/
	Operator =(ByRef _1 As v2d, ByRef _2 As v2d) As BOOL
		If _1.x = _2.x And _1.y = _2.y Then Return TRUE
		Return FALSE
	End Operator
	Operator <>(ByRef _1 As v2d, ByRef _2 As v2d) As BOOL
		If _1.x = _2.x And _1.y = _2.y Then Return FALSE
		Return TRUE
	End Operator
	
End Namespace
