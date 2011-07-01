
Namespace GLE
	
	''===================================
	'' Misc Functions
	''===================================
	''' Random Numbers
	Declare Function Random_Int(first As Integer, last As Integer) As Integer
	Declare Function Random_Double(first As Double, last As Double) As Double
	''' Timers
	Declare Function TimerInit() As Double
	Declare Function TimerDiff(ByVal TimeStamp As Double) As Double
	' Internals
	Declare Sub _SetBlendMode(ByVal mode As E_BLEND_MODE = BM_TRANS)
	Declare Function _ReduceAngle(ByVal iAngle As Single) As Single
	Declare Function _RadToDeg(ByVal rad As Single) As Single
	Declare Function _DegToRad(ByVal nDegrees As Single) As Single
	Declare Function _Geo_PtoP_Dist(ByVal p1 As v2d, ByVal p2 As v2d) As Single
	Declare Function _Geo_PtoP_Angle(ByVal p1 As v2d, ByVal p2 As v2d) As Single
	Declare Function _Geo_PtoP_Vect(ByVal p1 As v2d, ByVal p2 As v2d, ByVal grandeur As Short = 0) As v2d
	Declare Function _Geo_AngleToVector(ByVal iAngle As UShort, ByVal iGrandeur As Single = 1) As v2d
	Declare Function _Geo_VectorToAngle(ByVal vect As v2d) As Integer
	''===================================================================================================
	
	Sub _SetBlendMode(ByVal mode As E_BLEND_MODE = BM_TRANS)
		If mode = __Current_BlendMode Then Return
		__Current_BlendMode = mode
		Select Case mode
			Case BM_TRANS
				glEnable(GL_BLEND)    	    
				glEnable(GL_ALPHA_TEST)
				glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
			Case BM_SOLID
				glDisable(GL_BLEND)
				glDisable(GL_ALPHA_TEST)    	    
			Case BM_BLENDED
				glEnable(GL_BLEND)
				glEnable(GL_ALPHA_TEST)    	    
				glBlendFunc(GL_SRC_ALPHA, GL_ONE)
			Case BM_GLOW
				glEnable(GL_BLEND)
				glEnable(GL_ALPHA_TEST)    	    
				glBlendFunc(GL_ONE, GL_ONE)
			Case BM_BLACK
				glEnable(GL_BLEND)
				glEnable(GL_ALPHA_TEST)    	
				glBlendFunc(GL_ZERO, GL_ONE_MINUS_SRC_ALPHA)
			'Case Else ' BM_TRANS
			'	glEnable(GL_BLEND)    	    
			'	glEnable(GL_ALPHA_TEST)
			'	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
		End Select
	End Sub
	
	Function _ReduceAngle(ByVal iAngle As Single) As Single ' OK
		If iAngle < 0 Then
			iAngle = 360 - (Abs(iAngle) - 360)
		EndIf
		Do While iAngle >= 360
			iAngle -= 360
		Loop
		Return iAngle
	End Function
	
	Function _RadToDeg(ByVal rad As Single) As Single ' OK
		Dim ret As Single = rad / (_PI / 180)
		Return _ReduceAngle(ret)
	End Function
	
	Function _DegToRad(ByVal nDegrees As Single) As Single ' OK
		If nDegrees >= 360 Then nDegrees = _ReduceAngle(nDegrees)
		Return _PI * (nDegrees / 180)
	End Function
	''===================================================================================================
	
	
	Function _Geo_PtoP_Dist(ByVal p1 As v2d, ByVal p2 As v2d) As Single ' OK
		Return Sqr(((p1.x - p2.x) * (p1.x - p2.x)) + ((p1.y - p2.y) * (p1.y - p2.y)))
	End Function
	
	Function _Geo_PtoP_Angle(ByVal p1 As v2d, ByVal p2 As v2d) As Single ' OK
		If p1.x = p2.x And p1.y = p2.y Then Return 0

		Dim As Single difX = p2.x - p1.x
		Dim As Single difY = p2.y - p1.y
		Dim As Single tmp = Abs(Atn(difY / difX))

		If difX < 0 Then tmp = _PI - tmp
		If difY < 0 Then tmp = _PI + (_PI - tmp)

		Return _RadToDeg(tmp)
	End Function
	
	Function _Geo_PtoP_Vect(ByVal p1 As v2d, ByVal p2 As v2d, ByVal grandeur As Short = 0) As v2d ' OK
		Dim angle As UShort = _Geo_PtoP_Angle(p1, p2)
		'; ---
		If grandeur <= 0 Then grandeur = _Geo_PtoP_Dist(p1, p2)
		'; ---
		Return _Geo_AngleToVector(angle, grandeur)
	End Function
	''===================================================================================================
	
	
	Function _Geo_AngleToVector(ByVal iAngle As UShort, ByVal iGrandeur As Single = 1) As v2d ' OK
		Dim angleRad As Single = _DegToRad(iAngle)
		'; ---
		Dim ret As v2d
		ret.x = Cos(angleRad) * iGrandeur
		ret.y = Sin(angleRad) * iGrandeur
		'; ---
		Return ret
	End Function
	
	Function _Geo_VectorToAngle(ByVal vect As v2d) As Integer ' OK
		If vect.x = 0 And vect.y = 0 Then Return 0
		'; ---
		Dim tmp As Single = Abs(Atn(vect.y / vect.x))
		'; ---
		If vect.x < 0 Then tmp = _PI - tmp
		If vect.y < 0 Then tmp = _PI + (_PI - tmp)
		'; ---
		Return _RadToDeg(tmp)
	End Function
	''===================================================================================================
	
	
	Function Random_Int(first As Integer, last As Integer) As Integer
	    Function = Rnd * (last - first) + first
	End Function
	
	Function Random_Double(first As Double, last As Double) As Double
	    Function = Rnd * (last - first) + first
	End Function
	''===================================================================================================
	
	
	Function TimerInit() As Double
		Return Timer
	End Function
	
	Function TimerDiff(ByVal TimeStamp As Double) As Double
		Return Timer - TimeStamp
	End Function
	
End Namespace
