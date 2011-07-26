
'File: Sprite

Namespace GLE
	
	/'
	Class: Sprite
		Class that is used to display <Texture>s on the screen.
		
		Can be scaled, rotated, and moved (using <Dynamique> class)
	
	Definition:
		(start code)
		
		(end)
	
	Property: 
	'/
	
	/'
	Constructor: Sprite
		Default constructor, makes an empty sprite (without any <Texture> associated)
	
	Prototype:
		>Constructor Sprite()
	'/
	Constructor Sprite()
		This.tex = 0
	End Constructor
	
	/'
	Constructor: Sprite
		Most common constructor, makes a sprite with a specific texture.
	
	Prototype:
		>Constructor Sprite(ByVal tex As Texture Ptr)
	
	Parameters:
		tex (Texture Ptr) - Pointer to a <Texture> instance
	
	Remarks:
		When a sprite is created, it takes the texture size.
	'/
	Constructor Sprite(ByVal tex As Texture Ptr)
		This.tex = tex
		This.Size = v2d(tex->w, tex->h)
		This.SetTextureRect(Rect(0, 0, 0, 0))
	End Constructor
	
	/'
	Constructor: Sprite
		Overloaded constructor, takes a picture file path rather than a Texture pointer
	
	Prototype:
		>Constructor Sprite(ByVal tex_path As String)
	
	Parameters:
		tex_path (String) - Path to a picture file
	
	Remarks:
		The file format supported are the same as in <Texture> class.
	'/
	Constructor Sprite(ByVal tex_path As String)
		This.tex = New Texture(tex_path)
		This._delete_tex = TRUE
		This.Size = v2d(tex->w, tex->h)
		This.SetTextureRect(Rect(0, 0, 0, 0))
	End Constructor
	
	' Destructor
	Destructor Sprite()
		If This._delete_tex Then Delete This.tex
	End Destructor
	''===================================================================================================
	
	' Property angle
	Property Sprite.Angle() As Single
		Return This.PRIVATE_Angle
	End Property
	Property Sprite.Angle(ByVal value As Single)
		This.PRIVATE_Angle = _ReduceAngle(value)
	End Property
	''===================================================================================================
	
	/'
	Method: Draw
		Draw the sprite at <Sprite.Position>, with <Sprite.Angle> and <Sprite.Size>.
	
	Prototype:
		>Sub Sprite.Draw()
	
	Remarks:
		Must be called for every frame, between <Display.Draw_Begin> and <Display.Draw_End>.
	'/
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
	
	/'
	Method: Draw (Overloaded)
		Draw a sprite and animate it (using an <Animation> object)
	
	Prototype:
		>Sub Sprite.Draw(ByVal anim As Animation Ptr)
		Or:
		>Function Sprite.Draw(ByVal anim As Animation Ptr, ByVal stop_frame As Short) As BOOL
	
	Parameters:
		anim (Animation Ptr) - Pointer to an Animation Object
		stop_frame (Short) - (Optional) frame number of the animation that when it is reached, the function returns *False*
	
	Remarks:
		- When specifying the second parameter, the method becomes a Function and returns a BOOL.
		- This BOOL returned is usefull for testing when the animation should stop. See the next example
		- If you specify stop_frame = 1, and your animation starts at frame 1, don't worry! your sprite will animate
		it self, until he makes ONE loop, and then, when reaching (again) the frame 1, then the function will returns *False*
	
	Example:
		(start code)
		Dim animated As Sprite(@some_texture)
		Dim anim As Animation()
		With anim
			.AddFram(... ' Frame 1
			.AddFram(... ' Frame 2
			.AddFram(... ' Frame 3
			.AddFram(... ' Frame 4
		EndWith
		Dim is_anim As BOOL
		...
		'Main loop'
		
		' a mouse click or something else...
		If some_event Then is_anim = TRUE
		
		Display.Draw_Begin()
		...
		If is_anim = TRUE Then
			is_anim = animated.Animate(@anim, 1)
			' here, when the animation loops one time (reaches again frame 1), then is_anim is set to *False*
			' and the animation will stop.
		Else
			animated.AnimRewind(1)
			' here, the animation is reinitiated at frame 1
		EndIf
		...
		Display.Draw_End()
		
		'End main loop'
		(end)
	'/
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
	/'
	Method: SetTexture
		Change the current Sprite's texture, with/without changin it's size
	
	Protoype:
		>Sub Sprite.SetTexture(ByVal tex As Texture Ptr, ByVal changeSize As BOOL)
		Or
		>Sub Sprite.SetTexture(ByVal tex As Texture Ptr, ByVal _rect_ As Rect, ByVal changeSize As BOOL)
	
	Parameters:
		tex (Texture Ptr) - Pointer to a <Texture> object
		_rect_ (Rect) - (Optional) New texture's rectange to assign
		changeSize (BOOL) - (Optional) change or not the size of the sprite to the size of the texture (default: False)
	'/
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
	/'
	Method: SetOrigin
		Set the origin point of a sprite at some preset values
	
	Prototype:
		>Sub Sprite.SetOrigin(ByVal flag As E_ORIGIN)
	
	Parameters:
		flag (E_ORIGIN) - See <GLE.E_ORIGIN> values
	'/
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
	/'
	Method; SetTextureRect
		Display a specific rectangle of the assigned texture
	
	Prototype:
		>Sub Sprite.SetTextureRect(ByVal _rect_ As Rect)
	
	Parameters:
		_rect_ (Rect) - Rectangle of the texture.
		
		Set to Rect(0,0,0,0) to take the entire texture
	
	Remarks:
		_rect_.w and _rect_.h can be greater than the texture's width and height to make tiled texture. (see OpenGl texturing)
	'/
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
	/'
	Method: GetPoint
		Get the world's relative position of a fixed point in the sprite (sprite's relative position)
	
	Prototype:
		>Function Sprite.GetPoint(ByVal _point As v2d) As v2d
	
	Parameters:
		_point (v2d) - Sprite's relative position of the point we want
	
	Returns:
		World's relative position of the point (As v2d)
	
	Remarks:
		The point in the sprite is always at the same position in the sprite, even of the sprite is rotated.
	'/
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
	
	/'
	Method: GetPoint (Overloaded)
		Same as <Sprite.GetPoint> but the point is specified as ratio
	
	Protoype:
		>Function Sprite.GetPoint(ByVal ratioX As Single, ByVal ratioY As Single) As v2d
	
	Parameters:
		ratioX, ratioY (Single) - X and Y ratio (see example)
	
	Remarks:
		This function is usefull for sprites that often change size.
	
	Example:
		(start code)
		Sprite.GetPoint(0.5, 0.5)
		' will allways return the center point of the sprite
		
		Sprite.GetPoint(1, 1)
		' will allways return the bottom right corner position of the sprite
		(end)
	'/
	Function Sprite.GetPoint(ByVal ratioX As Single, ByVal ratioY As Single) As v2d
		Dim As v2d vect
		vect.x = This.Size.x * ratioX
		vect.y = This.Size.y * ratioY
		Return This.GetPoint(vect)
	End Function
	''===================================================================================================
		
	' Geometry Functions
	/'
	Method: ToPoint_Dist
		Return the distance between This sprite and a point
	
	Prototype:
		>Function Sprite.ToPoint_Dist(ByVal _point As v2d) As Single
	
	Parameters:
		_point (v2d) - A point
	
	Returns:
		The distance as Single
	'/
	Function Sprite.ToPoint_Dist(ByVal _point As v2d) As Single
		Return _Geo_PtoP_Dist(This.Position, _point)
	End Function
	
	/'
	Method: ToPoint_Angle
		Returns the absolute angle between the origin of a Sprite and a point
	
	Prototype:
		>Function Sprite.ToPoint_Angle(ByVal _point As v2d) As Single
	
	Parameters:
		_point (v2d) - A point
	
	Returns:
		The angle as Single (in degrees)
	
	Remarks:
		The returned angle is always positive, and between 0 and 359
	'/
	Function Sprite.ToPoint_Angle(ByVal _point As v2d) As Single
		Return _Geo_PtoP_Angle(This.Position, _point)
	End Function
	
	/'
	Method: ToPoint_AngleDiff
		Return the difference between the sprite's angle, and the absolute angle between the sprite and a point
	
	Protoype:
		>Function Sprite.ToPoint_AngleDiff(ByVal _point As v2d) As Single
	
	Parameters:
		_point (v2d) - A Point
	
	Returns:
		The relative angle. It can be négative (if the point is at the left of the sprite) (see remarks)
	
	Remarks:
		The returned value is between -179 and +179.
		
		- If the point is in front of the sprite, then 0 is returnd
		- If the point is at the left of the sprite, then a negative angle is returned (from -1 to -179)
		- If the point is at the right of the sprite, then a positive angle is returned (from 1 to 179)
	'/
	Function Sprite.ToPoint_AngleDiff(ByVal _point As v2d) As Single
		Dim angleDiff As Single = This.ToPoint_Angle(_point)
		Dim angleCurr As Single = This.Angle
		If angleCurr = 0 Then angleCurr = 360
		' ---
		Dim angleInverse As Single = _ReduceAngle(angleCurr + 180)
		' ---
		Dim result As Single = 0
		If angleCurr >= 180 Then
			If angleDiff < angleCurr And angleDiff > angleInverse Then ' -
				result = -1 * Abs(angleCurr - angleDiff)
			Else ' +
				If angleDiff > angleCurr Then
					result = Abs(angleDiff - angleCurr)
				Else
					result = Abs(Abs(360 - angleCurr) + angleDiff)
				EndIf
			EndIf
		Else
			If angleDiff > angleCurr And angleDiff < angleInverse Then ' +
				result = Abs(angleDiff - angleCurr)
			Else ' -
				If angleDiff < angleCurr Then
					result = -1 * Abs(angleCurr - angleDiff)
				ElseIf angleDiff > angleInverse And angleDiff < 360 Then
					result = -1 * Abs(angleCurr + Abs(360 - angleDiff))
				EndIf
			EndIf
		EndIf
		' ---
		' NE JAMAIS appliquer ici _ReduceAngle(), car elle retourne toujour un angle (+)
		If result = 360 Then result = 0 ' cas spécial ou l'algoritme se trompe en retournant 360
		' ---
		Return result
	End Function
	
	/'
	Method: ToPoint_Vect
		Return a vector (v2d) between the sprite's origin and a point
	
	Prototype:
		>Function Sprite.ToPoint_Vect(ByVal _point As v2d, ByVal lenght As Single) As v2d
	
	Parameters:
		_point (v2d) - A point
		lenght (Single) - (Optional) the lenght of the desired vector. If omited, then the lenght 
			will be the distance between the sprite and the point
	
	Returns:
		The vector As <v2d>
	'/
	Function Sprite.ToPoint_Vect(ByVal _point As v2d) As v2d
		Return _Geo_PtoP_Vect(This.Position, _point)
	End Function
	Function Sprite.ToPoint_Vect(ByVal _point As v2d, ByVal lenght As Single) As v2d
		Return _Geo_PtoP_Vect(This.Position, _point, lenght)
	End Function
	
	/'
	Method: ToSprite_Dist
		Return the distance between This sprite and another origins. Same as <Sprite.ToPoint_Dist>
	
	Prototype:
		>Function Sprite.ToSprite_Dist(ByRef sprite As Sprite) As Single
	
	Parameters:
		sprite (Sprite) - A sprite object
	
	Returns:
		Distance As Single
	'/	
	Function Sprite.ToSprite_Dist(ByRef sprite As Sprite) As Single
		Return _Geo_PtoP_Dist(This.Position, sprite.Position)
	End Function
	
	/'
	Method: ToSprite_Angle
		Return the absolute angle between a sprite and another. Same as <Sprte.ToPoint_Angle>
	
	Prototype:
		>Function Sprite.ToSprite_Angle(ByRef sprite As Sprite) As Single
	
	Parameters:
		sprite (Sprite) - A Sprite object
	
	Returns:
		The angle As Single (In degrees)
	
	Remarks:
		Same as <Sprite.ToPoint_Angle>
	'/
	Function Sprite.ToSprite_Angle(ByRef sprite As Sprite) As Single
		Return _Geo_PtoP_Angle(This.Position, sprite.Position)
	End Function
	
	/'
	Method: ToSprite_AngleDiff
		Return the difference between the sprite's angle, and the absolute angle between the sprite and another
	
	Prototype:
		>Function Sprite.ToSprite_AngleDiff(ByRef sprite As Sprite) As Single
	
	Parameters:
		sprite (Sprite) - A Sprite object
	
	Returns:
		The angle As Single
	
	Remarks:
		Same as <Sprite.ToPoint_AngleDiff>
	'/
	Function Sprite.ToSprite_AngleDiff(ByRef sprite As Sprite) As Single
		Return This.ToPoint_AngleDiff(sprite.Position)
	End Function
	
	/'
	Method: ToSprite_Vect
		Return a vector (v2d) between the 2 sprite's origins
	
	Prototype:
		>Function Sprite.ToSprite_Vect(ByRef sprite As Sprite, ByVal lenght As Single) As v2d
	
	Parameters:
		sprite (Sprite) - A Sprite object
		lenght (Single) - (Optional) the lenght of the desired vector. If omited, then the lenght 
			will be the distance between the 2 sprites
	
	Returns:
		The vector As <v2d>
	'/
	Function Sprite.ToSprite_Vect(ByRef sprite As Sprite) As v2d
		Return _Geo_PtoP_Vect(This.Position, sprite.Position)
	End Function
	Function Sprite.ToSprite_Vect(ByRef sprite As Sprite, ByVal lenght As Single) As v2d
		Return _Geo_PtoP_Vect(This.Position, sprite.Position, lenght)
	End Function
	
	' Animation Function
	/'
	Method: AnimRewind
		Initiate the animation timer, and the current frame to the specified in parameter
	
	Prototype:
		>Sub Sprite.AnimRewind(ByVal frame As UShort)
	
	Parameters:
		frame (UShort) - The animation frame to initiate to
	
	Remarks:
		- After calling this method, all animation applied to this sprite will start at the frame specified.
		- An animation starts at frame 1
	'/
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
