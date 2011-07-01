
Namespace GLE
	
	Constructor Particle()
		This.timer_draw = TimerInit()
		This.timer_life = TimerInit()
	End Constructor
	
	Sub Particle.Draw()
		With This
		'========
		'If .tex = 0 Then Return ' must be in the emitter
		If .kill_me = TRUE Then Return
		If TimerDiff(.timer_life) >= .life_time Then
			.kill_me = TRUE
			Return
		EndIf
		If .Start_A = 0 Then
			.kill_me = TRUE
			Return
		EndIf
		'========
		Dim As Double dt = TimerDiff(.timer_draw)
		
		''' Size
		If .SizeVar <> 0 Then
			.Size += .SizeVar * dt
			If .Size <= 0 Then
				.kill_me = TRUE
				Return
			EndIf
		EndIf
		
		''' Accel, Force, Vel
		If .accel.x <> 0 Then .vel.x += (.accel.x * dt)
		If .accel.y <> 0 Then .vel.y += (.accel.y * dt)
		
		If .force.x <> 0 Then .vel.x += (.force.x * dt)
		If .force.y <> 0 Then .vel.y += (.force.y * dt)
		
		.position.x += (.vel.x * dt)
		.position.y += (.vel.y * dt)
		
		''' Spin
		If .SpinVar <> 0 Then .Spin += .SpinVar * dt
		.Angle += .Spin * dt
		
		''' Color
		.Start_R += .Var_R * dt
		.Start_G += .Var_G * dt
		.Start_B += .Var_B * dt
		.Start_A += .Var_A * dt
		
		If .Start_R <= 0 Then .Start_R = 0
		If .Start_R >= 255 Then .Start_R = 255
		If .Start_G <= 0 Then .Start_G = 0
		If .Start_G >= 255 Then .Start_G = 255
		If .Start_B <= 0 Then .Start_B = 0
		If .Start_B >= 255 Then .Start_B = 255
		If .Start_A <= 0 Then .Start_A = 0
		If .Start_A >= 255 Then .Start_A = 255
		
		._color = GLE_RGBA(.Start_R, .Start_G, .Start_B, .Start_A)
		
		''' Draw		
		glPushMatrix()
		'''
		glTranslated(.Position.x, .Position.y, 0)
		glRotated(Angle, 0, 0, 1)
		glColor4ubv(cast(GLUbyte ptr, @._color))
		glBegin(GL_TRIANGLE_FAN)

			glTexCoord2d(This.texRect.x, This.texRect.y)
			glVertex2d(-1 * .Size / 2, -1 * .Size / 2)

			glTexCoord2d(This.texRect.x + This.texRect.w, This.texRect.y)
			glVertex2d((-1 * .Size / 2) + .Size, -1 * .Size / 2)

			glTexCoord2d(This.texRect.x + This.texRect.w, This.texRect.y + This.texRect.h)
			glVertex2d((-1 * .Size / 2) + .Size, (-1 * .Size / 2) + .Size)

			glTexCoord2d(This.texRect.x, This.texRect.y + This.texRect.h)
			glVertex2d(-1 * .Size / 2, (-1 * .Size / 2) + .Size)
			
		glEnd
		'''
		glPopMatrix()
		
		'========
		End With
		
		This.timer_draw = TimerInit()
	End Sub
	
	''=========================================================================================
	''=========================================================================================
	
	Constructor Particle_Emitter()
		For i As Short = 0 To _MAX_PARTICLES_
			This.array(i) = 0
		Next i
		'''
		This.texRect = Rect(0, 0, 1, 1)
	End Constructor
	
	Constructor Particle_Emitter(ByVal tex As Texture Ptr)
		This.tex = tex
		For i As Short = 0 To _MAX_PARTICLES_
			This.array(i) = 0
		Next i
		This.texRect = Rect(0, 0, 1, 1)
		''' à ajouter dans une fonction toggleActif
		This.emitte_timer = TimerInit()
	End Constructor
	
	Constructor Particle_Emitter(ByVal tex As Texture Ptr, ByVal texRect As Rect)
		This.tex = tex
		For i As Short = 0 To _MAX_PARTICLES_
			This.array(i) = 0
		Next i
		This.SetTextureRect(texRect)
		''' à ajouter dans une fonction toggleActif
		This.emitte_timer = TimerInit()
	End Constructor
	
	Sub Particle_Emitter.SetTextureRect(ByVal texRect As Rect)
		If This.tex = 0 Then
			This.texRect = Rect(0, 0, 1, 1)
			Return
		EndIf
		This.texRect = Rect(texRect.x / This.tex->w, texRect.y / This.tex->h, texRect.w / This.tex->w, texRect.h / This.tex->h)
		''' à ajouter dans une fonction toggleActif
		This.emitte_timer = TimerInit()
	End Sub
	
	Sub Particle_Emitter.Spawn()
		Dim As Double diff = TimerDiff(This.emitte_timer)
		Dim As Short nbr
		If diff >= This.emitte_delay Then
			nbr = diff / This.emitte_delay
			For x As UShort = 1 To nbr
				For i As UShort = 1 To This.particlesPerEmitte
					This.__AddParticle()
				Next i
			Next x
			This.emitte_timer = TimerInit()
		EndIf
	End Sub
	
	Sub Particle_Emitter.Spawn(ByVal nbr As UShort)
		Dim As BOOL old_stat = This.Actif
		This.Actif = TRUE
		For i As UShort = 1 To nbr
			This.__AddParticle()
		Next i
		This.Actif = old_stat
	End Sub
		
	Sub Particle_Emitter.Draw()
		This.Spawn()
		'''
		_SetBlendMode(This.blendMode)
		'''
		If This.tex = 0 Then
			__GLOW_Texture.Activate()
		Else
			This.tex->Activate()
		EndIf
		'''
		Dim _ptr_ As Particle Ptr
		For i As UShort = 0 To _MAX_PARTICLES_
			If This.Array(i) <> 0 Then
				_ptr_ = This.Array(i)
				_ptr_->Draw()
				If _ptr_->kill_me = TRUE Then
					Delete This.Array(i)
					This.Array(i) = 0
					This._nbr_particles -= 1
				EndIf
			EndIf
		Next i
		'''
	End Sub
	
	Sub Particle_Emitter.__AddParticle()
		If This.actif = 0 Then Return
		If This._nbr_particles >= This.max_particles Then Return
		If This._nbr_particles >= _MAX_PARTICLES_ Then Return
		'''
		Dim index As Short = This.__GetArrayFreeSlot()
		If index = -1 Then Return
		'''
		Dim _ptr_ As Particle Ptr = New Particle
		'''
		Dim As Single _ANGLE_ = This.__GetAngle()
		Dim As v2d vector
		''==============
		With This
			''' Position
			_ptr_->Position.x = .__SpecialRandom_Int(.Position.x, .PositionVar.x)
			_ptr_->Position.y = .__SpecialRandom_Int(.Position.y, .PositionVar.y)
			
			''' Velocity, Acceleration
			vector.FromAngle(_ANGLE_, .__SpecialRandom_Float(.Vel, .VelVar))
			_ptr_->Vel = vector
			vector.FromAngle(_ANGLE_, .__SpecialRandom_Float(.Accel, .AccelVar))
			_ptr_->Accel = vector
			
			''' Force
			vector.FromAngle(.__SpecialRandom_Float(.force_Angle, .force_AngleVar), .__SpecialRandom_Float(.force, .forceVar))
			_ptr_->Force = vector
			
			''' Spin
			_ptr_->Spin = .__SpecialRandom_Float(.Spin, .SpinVar)
			_ptr_->SpinVar = .SpinFlyVar
			
			''' Size
			_ptr_->Size = .__SpecialRandom_Int(.Size, .SizeVar)
			_ptr_->SizeVar = .sizeFlyVar
			
			''' Color
			_ptr_->start_R = .clr.Get(1)
			_ptr_->start_G = .clr.Get(2)
			_ptr_->start_B = .clr.Get(3)
			_ptr_->start_A = .clr.Get(4)
			
			_ptr_->var_R = .flyVar_R
			_ptr_->var_G = .flyVar_G
			_ptr_->var_B = .flyVar_B
			_ptr_->var_A = .flyVar_A
			
			''' Texture Rect
			_ptr_->texRect = .texRect
			
			''' Life Time
			_ptr_->life_time = .__SpecialRandom_Float(.life_time, .life_timeVar)
			
		End With
		''==============
		'''
		This.Array(index) = _ptr_
		This._nbr_particles += 1
	End Sub
	
	Function Particle_Emitter.__GetArrayFreeSlot() As Short
		For i As Short = 0 To _MAX_PARTICLES_
			If This.array(i) = 0 Then Return i
		Next i
		Return -1
	End Function
	
	Function Particle_Emitter.__GetAngle() As Single
		If This.AngleVar = 0 Then Return This.Angle
		'''
		Dim As Double min, max
		min = This.Angle - This.AngleVar
		max = This.Angle + This.AngleVar
		Dim iAngle As Short
		iAngle = Int((Rnd * (max - min)) + min)
		If iAngle < 0 Then
			iAngle = 360 - (Abs(iAngle) - 360)
		EndIf
		Do While iAngle >= 360
			iAngle -= 360
		Loop
		Return iAngle
	End Function
	
	Function Particle_Emitter.__SpecialRandom_Int(ByVal value As Short, ByVal variation As Short) As Short
		If variation = 0 Then Return value
		Dim As Short min, max
		min = value - variation
		max = value + variation
		Return Random_Int(min, max)
	End Function
	Function Particle_Emitter.__SpecialRandom_Float(ByVal value As Single, ByVal variation As Single) As Single
		If variation = 0 Then Return value
		Dim As Single min, max
		min = value - variation
		max = value + variation
		Return Random_Double(min, max)
	End Function
	
End Namespace
