
''===================================
'' UDT: Sprite
''===================================

Namespace GLE
	
	' Default Constructor
	Constructor Sprite()
		This.tex = 0
	End Constructor
	' Constructor
	Constructor Sprite(ByVal tex As Texture Ptr)
		This.tex = tex
		This.Size = v2d(tex->w, tex->h)
		This.SetTextureRect(Rect(0, 0, 0, 0))
	End Constructor
	''===================================================================================================
	
	' Property angle
	Property Sprite.Angle() As Single
		Return This.PRIVATE_Angle
	End Property
	Property Sprite.Angle(ByVal value As Single)
		This.PRIVATE_Angle = _ReduceAngle(value)
	End Property
	''===================================================================================================
	
	' Drawing method
	Sub Sprite.Draw()
		If This.tex = 0 Then Exit Sub
		'''
		glEnable(GL_TEXTURE_2D)
		This.tex->Activate()
		'''
		_SetBlendMode(This.blendMode)
		glPushMatrix()
		'''
		glTranslated(This.Position.x, This.Position.y, 0)
		glRotated(This.PRIVATE_Angle, 0, 0, 1)
		glColor4ubv(Cast(GLUbyte ptr, @This.Color))
		glBegin(GL_TRIANGLE_FAN)
			
			glTexCoord2d(This.texRect.x, This.texRect.y)
			glVertex2d(-1 * This.Origin.x, -1 * This.Origin.y)

			glTexCoord2d(This.texRect.x + This.texRect.w, This.texRect.y)
			glVertex2d((-1 * This.Origin.x) + This.Size.x, -1 * This.Origin.y)

			glTexCoord2d(This.texRect.x + This.texRect.w, This.texRect.y + This.texRect.h)
			glVertex2d((-1 * This.Origin.x) + This.Size.x, (-1 * This.Origin.y) + This.Size.y)

			glTexCoord2d(This.texRect.x, This.texRect.y + This.texRect.h)
			glVertex2d(-1 * This.Origin.x, (-1 * This.Origin.y) + This.Size.y)
			
		glEnd
		'''
		glPopMatrix()
	End Sub
	
	' Draw and Animate
	Sub Sprite.Draw(ByVal anim As Animation Ptr)
		This.Animate(anim, 0)
		This.Draw()
	End Sub
	' Draw and animate, and return FALSE when stop_frame is reached
	Function Sprite.Draw(ByVal anim As Animation Ptr, ByVal stop_frame As Short) As BOOL
		Function = This.Animate(anim, stop_frame)
		This.Draw()
	End Function
	 
	' Change texture (Without changing the current sprite size)
	Sub Sprite.SetTexture(ByVal tex As Texture Ptr)
		This.tex = tex
		This.SetTextureRect(Rect(0,0,0,0))
	End Sub
	
	' Change texture with or without changing the current sprite size
	Sub Sprite.SetTexture(ByVal tex As Texture Ptr, ByVal changeSize As BOOL)
		This.tex = tex
		If changeSize = TRUE Then This.Size = v2d(tex->w, tex->h)
		This.SetTextureRect(Rect(0,0,0,0))
	End Sub
	
	' Change texture without changing the current sprite size, and specifying a Texture Rect
	Sub Sprite.SetTexture(ByVal tex As Texture Ptr, ByVal _rect_ As Rect)
		This.tex = tex
		This.SetTextureRect(_rect_)
	End Sub
	
	' Change texture with or without changing the current sprite size, and specifying a Texture Rect
	Sub Sprite.SetTexture(ByVal tex As Texture Ptr, ByVal _rect_ As Rect, ByVal changeSize As BOOL)
		This.tex = tex
		If changeSize = TRUE Then This.Size = v2d(tex->w, tex->h)
		This.SetTextureRect(_rect_)
	End Sub
	''===================================================================================================
		
	' Set Origin
	Sub Sprite.SetOrigin(ByVal flag As E_ORIGIN)
		Dim As UShort x, y
		Select Case flag
			Case O_MID
				x = This.Size.x / 2
				y = This.Size.y / 2
			Case O_UL
				x = 0
				y = 0
			Case O_UR
				x = This.Size.x
				y = 0
			Case O_BL
				x = 0
				y = This.Size.y
			Case O_BR
				x = This.Size.x
				y = This.Size.y
			Case Else
				x = This.Size.x / 2
				y = This.Size.y / 2
		End Select
		This.Origin = v2d(x,y)
	End Sub
	
	' Set Texture Rect
	Sub Sprite.SetTextureRect(ByVal _rect_ As Rect)
		If _rect_.w = 0 Or _rect_.h = 0 Then
			_rect_.w = 1
			_rect_.h = 1
		Else
			_rect_.x /= This.tex->w
			_rect_.y /= This.tex->h
			_rect_.w /= This.tex->w
			_rect_.h /= This.tex->h
		EndIf
		This.texRect = _rect_
	End Sub
	''===================================================================================================
		
	' Get Fixed Point
	Function Sprite.GetPoint(ByVal _point As v2d) As v2d
		Dim As Integer imgX, imgY
		Dim dist As Single
		'; --- ; position par rapport à l'origine
		imgX = _point.x - This.origin.x
		imgY = _point.y - This.origin.y
		'; --- ; distance entre origine et point
		dist = Sqr((imgX*imgX) + (imgY*imgY))
		If dist = 0 Then '; Car _GEng_PointToPoint_Angle bug si les 2 point on la même position
			Return This.position
		EndIf
		'; --- ; Angle entre l'origine et le point
		Dim _angle As UShort = _Geo_PtoP_Angle(v2d(0,0), v2d(imgX, imgY)) + This.PRIVATE_Angle
		'; ---
		Return _Geo_AngleToVector(_angle, dist) + This.position
	End Function
	
	Function Sprite.GetPoint(ByVal ratioX As Single, ByVal ratioY As Single) As v2d
		Dim As v2d vect
		vect.x = This.Size.x * ratioX
		vect.y = This.Size.y * ratioY
		Return This.GetPoint(vect)
	End Function
	''===================================================================================================
		
	' Geometry Functions
	Function Sprite.ToPoint_Dist(ByVal _point As v2d) As Single
		Return _Geo_PtoP_Dist(This.Position, _point)
	End Function
	Function Sprite.ToPoint_Angle(ByVal _point As v2d) As Single
		Return _Geo_PtoP_Angle(This.Position, _point)
	End Function
	Function Sprite.ToPoint_Vect(ByVal _point As v2d) As v2d
		Return _Geo_PtoP_Vect(This.Position, _point)
	End Function
	Function Sprite.ToPoint_Vect(ByVal _point As v2d, ByVal lenght As Single) As v2d
		Return _Geo_PtoP_Vect(This.Position, _point, lenght)
	End Function
	
	Function Sprite.ToSprite_Dist(ByRef sprite As Sprite) As Single
		Return _Geo_PtoP_Dist(This.Position, sprite.Position)
	End Function
	Function Sprite.ToSprite_Angle(ByRef sprite As Sprite) As Single
		Return _Geo_PtoP_Angle(This.Position, sprite.Position)
	End Function
	Function Sprite.ToSprite_Vect(ByRef sprite As Sprite) As v2d
		Return _Geo_PtoP_Vect(This.Position, sprite.Position)
	End Function
	Function Sprite.ToSprite_Vect(ByRef sprite As Sprite, ByVal lenght As Single) As v2d
		Return _Geo_PtoP_Vect(This.Position, sprite.Position, lenght)
	End Function
	
	' Animation Function
	Sub Sprite.AnimRewind(ByVal frame As UShort)
		If frame < 1 Then frame = 1
		This.Anim_Frame = frame
		This.Anim_Timer = -1
		This.Anim_CurrFramDuration = 0
	End Sub
	
	Function Sprite.Animate(ByVal anim As Animation Ptr) As BOOL
		Return This.Animate(anim, 0) ' stop_frame will not be checked because frame nbr 0 doesn't exists! :p
	End Function
	
	Function Sprite.Animate(ByVal anim As Animation Ptr, ByVal stop_frame As Short) As BOOL
		If anim->Nbr_Frames <= 0 Then Return FALSE
		If This.Anim_Frame > anim->Nbr_Frames Then This.Anim_Frame = 1
		If stop_frame > anim->Nbr_Frames Then stop_frame = anim->Nbr_Frames
		'''
		If This.Anim_Timer = -1 Then
			anim->Array(This.Anim_Frame)->__ApplyFrame(@This)
			This.Anim_Timer = TimerInit()
		Else
			If TimerDiff(This.Anim_Timer) >= This.Anim_CurrFramDuration Then
				This.Anim_Frame += 1
				If This.Anim_Frame > anim->nbr_Frames Then This.Anim_Frame = 1
				'''
				anim->Array(This.Anim_Frame)->__ApplyFrame(@This)
				This.Anim_Timer = TimerInit()
			EndIf
			'''
			If This.Anim_Frame = stop_frame Then Return FALSE
		EndIf
		'''
		Return TRUE
	End Function
	
End Namespace
