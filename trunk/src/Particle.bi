
'File: Particle

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
	
	Constructor Particle_Emitter_Cfg()
	End Constructor
	
	Constructor Particle_Emitter_Cfg(ByVal file_name As String, ByVal section_name As String)
		This.LoadConfig(file_name, section_name)
	End Constructor
	
	Function Particle_Emitter_Cfg.LoadConfig(ByVal file_name As String, ByVal section_name As String) As BOOL
		Print ""
		Print "Loading config: " & file_name & " - Section: " & section_name
		Dim file As inifobj.iniobj = inifobj.iniobj(file_name)
		If file.InitStatus = FALSE Then Return FALSE
		'''
		Dim dummy As Integer
		If file.SectionExists(section_name, dummy) = FALSE Then Return FALSE
		'''
		#Macro _read_(_value, _default)
			Val(file.ReadString(section_name, _value, _default))
		#EndMacro
		''
		Dim tmp_str As String
		ReDim array() As String
		''
		With This
			'' Position Var
			tmp_str = file.ReadString(section_name, "positionVar", "0,0")
			_StringSplit(tmp_str, ",", array())
			If UBound(array) = 2 Then
				.PositionVar = v2d(ValInt(array(1)), ValInt(array(2)))
			Else
				.PositionVar = v2d(0, 0)
			EndIf
			'Print "PosVar: " & .PositionVar
			'' Vel
			.vel = _read_("vel", "0")
			.velVar = _read_("velVar", "0")
			'Print "Vel: " & .vel & " - (" & .velVar & ")"
			'' ==============
			'' Accel
			.accel = _read_("accel", "0")
			.accelVar = _read_("accelVar", "0")
			'Print "Accel: " & .accel & " - (" & .accelVar & ")"
			'' ==============
			'' Angle
			.angle = _read_("angle", "0")
			.angleVar = _read_("angleVar", "180")
			'Print "Angle: " & .angle & " - (" & .angleVar & ")"
			'' ==============
			'' Force
			.force = _read_("force", "0")
			.forceVar = _read_("forceVar", "0")
			'Print "Force: " & .force & " - (" & .forceVar & ")"
			.force_angle = _read_("force_angle", "0")
			.force_angleVar = _read_("force_angleVar", "0")
			'Print "Force Angle: " & .force_angle & " - (" & .force_angleVar & ")"
			'' ==============
			'' Spin
			.spin = _read_("spin", "0")
			.spinVar = _read_("spinVar", "0")
			.spinFlyVar = _read_("spinFlyVar", "0")
			'Print "Spin: " & .spin & " - (" & .spinVar & ") - (" & .spinFlyVar & ")"
			'' ==============
			'' Life time
			.life_time = _read_("life_time", "1")
			.life_timeVar = _read_("life_timeVar", "0")
			'Print "Life: " & .life_time & " - (" & .life_timeVar & ")"
			'' ==============
			'' Size
			.size = _read_("size", "8")
			.sizeVar = _read_("sizeVar", "0")
			.sizeFlyVar = _read_("sizeFlyVar", "0")
			Print "Size: " & .size & " - (" & .sizeVar & ") - (" & .sizeFlyVar & ")"
			'' ==============
			'' Emitte
			.emitte_delay = _read_("emitte_delay", "0.01")
			'Print "Emitte Delay: " & .emitte_delay
			.particlesPerEmitte = _read_("particlesPerEmitte", "1")
			'Print "Parts Per Emitte: " & .particlesPerEmitte
			'' ==============
			'' Max Particles
			.max_particles = _read_("max_particles", "200")
			'Print "Max Parts: " & .max_particles
			'' ==============
			'' Colors
			tmp_str = file.ReadString(section_name, "color", "255,255,255,255")
			_StringSplit(tmp_str, ",", array())
			If UBound(array) = 4 Then
				.clr.Set(CInt(array(1)), CInt(array(2)), CInt(array(3)), CInt(array(4)))
			Else
				.Clr.Set(255,255,255,192)
			EndIf
			'Print "Color: " & .Clr.r & "," & .Clr.g & "," & .Clr.b & "," & .Clr.a
			'' ==============
			'' Color var
			tmp_str = file.ReadString(section_name, "colorVar", "0,0,0,0")
			_StringSplit(tmp_str, ",", array())
			If UBound(array) = 4 Then
				.clr.SetVar(CInt(array(1)), CInt(array(2)), CInt(array(3)), CInt(array(4)))
			Else
				.Clr.SetVar(0,0,0,0)
			EndIf
			'Print "ColorVar: " & .Clr.rVar & "," & .Clr.gVar & "," & .Clr.bVar & "," & .Clr.aVar
			'' ==============
			'' Color fly Var
			tmp_str = file.ReadString(section_name, "colorFlyVar", "0,0,0,0")
			_StringSplit(tmp_str, ",", array())
			If UBound(array) = 4 Then
				.FlyVar_R = CInt(array(1))
				.FlyVar_G = CInt(array(2))
				.FlyVar_B = CInt(array(3))
				.FlyVar_A = CInt(array(4))
			Else
				.FlyVar_R = 0
				.FlyVar_G = 0
				.FlyVar_B = 0
				.FlyVar_A = 0
			EndIf
			'Print "ColorFlyVar: " & .FlyVar_R & "," & .FlyVar_G & "," & .FlyVar_B & "," & .FlyVar_A
			'' ==============
			'' Blend mode
			tmp_str = file.ReadString(section_name, "BlendMode", "BM_TRANS")
			Select Case tmp_str
				Case "BM_TRANS"
					.blendMode = BM_TRANS
				Case "BM_SOLID"
					.blendMode = BM_SOLID
				Case "BM_BLENDED"
					.blendMode = BM_BLENDED
				Case "BM_GLOW"
					.blendMode = BM_GLOW
				Case "BM_BLACK"
					.blendMode = BM_BLACK
				Case Else
					.blendMode = BM_TRANS
			End Select
			'' ==============
		End With
	End Function
	
	''=========================================================================================
	''=========================================================================================
	
	/'	
	#Macro _P_Emitter_Constructor(tex, rect, cfg)
		For i As Short = 0 To _MAX_PARTICLES_
			This.array(i) = 0
		Next i
		'''
		If tex <> 0 Then This.tex = tex
		'''
		This.SetTextureRect(rect)
		'''
		If cfg <> 0 Then This.SetConfig(cfg)
		'''
		This.emitte_timer = TimerInit()
	#EndMacro
	'/
	
	Constructor Particle_Emitter()
		This.__Constructor(0, Rect(0, 0, 0, 0), 0)
	End Constructor
	
	Constructor Particle_Emitter(ByVal tex As Texture Ptr)
		This.__Constructor(tex, Rect(0, 0, 0, 0), 0)
	End Constructor
	
	Constructor Particle_Emitter(ByVal tex As Texture Ptr, ByVal texRect As Rect)
		This.__Constructor(tex, texRect, 0)
	End Constructor
	
	Constructor Particle_Emitter(ByVal tex As Texture Ptr, ByVal cfg_ptr As Particle_Emitter_Cfg Ptr)
		This.__Constructor(tex, Rect(0, 0, 0, 0), cfg_ptr)
	End Constructor
	
	Constructor Particle_Emitter(ByVal tex As Texture Ptr, ByVal texRect As Rect, ByVal cfg_ptr As Particle_Emitter_Cfg Ptr)
		This.__Constructor(tex, texRect, cfg_ptr)
	End Constructor
	
	Sub Particle_Emitter.__Constructor(ByVal tex As Texture Ptr, ByVal texRect As Rect, ByVal cfg_ptr As Particle_Emitter_Cfg Ptr)
		For i As Short = 0 To _MAX_PARTICLES_
			This.array(i) = 0
		Next i
		'''
		If tex <> 0 Then This.tex = tex
		'''
		This.SetTextureRect(texRect)
		'''
		If cfg_ptr <> 0 Then This.SetConfig(cfg_ptr)
		'''
		This.emitte_timer = TimerInit()
	End Sub
	
	Sub Particle_Emitter.SetTextureRect(ByVal texRect As Rect)
		If This.tex = 0 Then
			This.texRect = Rect(0, 0, 1, 1)
			Return
		EndIf
		This.texRect = Rect(texRect.x / This.tex->w, texRect.y / This.tex->h, texRect.w / This.tex->w, texRect.h / This.tex->h)
		''' à ajouter dans une fonction toggleActif
		This.emitte_timer = TimerInit()
	End Sub
	
	Sub Particle_Emitter.SetConfig(ByVal parts_cfg As Particle_Emitter_Cfg Ptr)
		With This
			.PositionVar = parts_cfg->PositionVar
			
			.vel = parts_cfg->vel
			.velVar = parts_cfg->velVar
			.accel = parts_cfg->accel
			.accelVar = parts_cfg->accelVar
			.angle = parts_cfg->angle
			.angleVar = parts_cfg->angleVar
			
			.force = parts_cfg->force
			.forceVar = parts_cfg->forceVar
			.force_angle = parts_cfg->force_angle
			.force_angleVar = parts_cfg->force_angleVar
			
			.spin = parts_cfg->spin
			.spinVar = parts_cfg->spinVar
			.spinFlyVar = parts_cfg->spinFlyVar
			
			.life_time = parts_cfg->life_time
			.life_timeVar = parts_cfg->life_timeVar
			
			.size = parts_cfg->size
			.sizeVar = parts_cfg->sizeVar
			.sizeFlyVar = parts_cfg->sizeFlyVar
			
			.emitte_delay = parts_cfg->emitte_delay
			.particlesPerEmitte = parts_cfg->particlesPerEmitte
			
			.max_particles = parts_cfg->max_particles
			
			.clr.r = parts_cfg->clr.r
			.clr.g = parts_cfg->clr.g
			.clr.b = parts_cfg->clr.b
			.clr.a = parts_cfg->clr.a
			.clr.rVar = parts_cfg->clr.rVar
			.clr.gVar = parts_cfg->clr.gVar
			.clr.bVar = parts_cfg->clr.bVar
			.clr.aVar = parts_cfg->clr.aVar
			.flyVar_R = parts_cfg->flyVar_R
			.flyVar_G = parts_cfg->flyVar_G
			.flyVar_B = parts_cfg->flyVar_B
			.flyVar_A = parts_cfg->flyVar_A
			
			.BlendMode = parts_cfg->BlendMode
		End With
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
		If This.tex = 0 Then ' If no texture Ptr in the emitter, then binds the default glow texture
			__GLOW_Texture->Activate()
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
	
	Function Particle_Emitter.LoadConfig(ByVal file_name As String, ByVal section_name As String) As BOOL
		Print ""
		Print "Loading config: " & file_name & " - Section: " & section_name
		Dim file As inifobj.iniobj = inifobj.iniobj(file_name)
		If file.InitStatus = FALSE Then
			Print "Error: Ini Status"
			Return FALSE
		EndIf
		'''
		Dim dummy As Integer
		If file.SectionExists(section_name, dummy) = FALSE Then
			Print "Error: No such section name"
			Return FALSE
		EndIf
		'''
		#Macro _read_(_value, _default)
			Val(file.ReadString(section_name, _value, _default))
		#EndMacro
		''
		Dim tmp_str As String
		ReDim array() As String
		''
		With This
			'' Position Var
			tmp_str = file.ReadString(section_name, "positionVar", "0,0")
			_StringSplit(tmp_str, ",", array())
			If UBound(array) = 2 Then
				.PositionVar = v2d(ValInt(array(1)), ValInt(array(2)))
			Else
				.PositionVar = v2d(0, 0)
			EndIf
			Print "PosVar: " & .PositionVar
			'' Vel
			.vel = _read_("vel", "0")
			.velVar = _read_("velVar", "0")
			Print "Vel: " & .vel & " - (" & .velVar & ")"
			'' ==============
			'' Accel
			.accel = _read_("accel", "0")
			.accelVar = _read_("accelVar", "0")
			Print "Accel: " & .accel & " - (" & .accelVar & ")"
			'' ==============
			'' Angle
			.angle = _read_("angle", "0")
			.angleVar = _read_("angleVar", "180")
			Print "Angle: " & .angle & " - (" & .angleVar & ")"
			'' ==============
			'' Force
			.force = _read_("force", "0")
			.forceVar = _read_("forceVar", "0")
			Print "Force: " & .force & " - (" & .forceVar & ")"
			.force_angle = _read_("force_angle", "0")
			.force_angleVar = _read_("force_angleVar", "0")
			Print "Force Angle: " & .force_angle & " - (" & .force_angleVar & ")"
			'' ==============
			'' Spin
			.spin = _read_("spin", "0")
			.spinVar = _read_("spinVar", "0")
			.spinFlyVar = _read_("spinFlyVar", "0")
			Print "Spin: " & .spin & " - (" & .spinVar & ") - (" & .spinFlyVar & ")"
			'' ==============
			'' Life time
			.life_time = _read_("life_time", "1")
			.life_timeVar = _read_("life_timeVar", "0")
			Print "Life: " & .life_time & " - (" & .life_timeVar & ")"
			'' ==============
			'' Size
			.size = _read_("size", "8")
			.sizeVar = _read_("sizeVar", "0")
			.sizeFlyVar = _read_("sizeFlyVar", "0")
			Print "Size: " & .size & " - (" & .sizeVar & ") - (" & .sizeFlyVar & ")"
			'' ==============
			'' Emitte
			.emitte_delay = _read_("emitte_delay", "0.01")
			Print "Emitte Delay: " & .emitte_delay
			.particlesPerEmitte = _read_("particlesPerEmitte", "1")
			Print "Parts Per Emitte: " & .particlesPerEmitte
			'' ==============
			'' Max Particles
			.max_particles = _read_("Max_Particles", "200")
			Print "Max Parts: " & .max_particles
			'' ==============
			'' Colors
			tmp_str = file.ReadString(section_name, "color", "255,255,255,255")
			_StringSplit(tmp_str, ",", array())
			If UBound(array) = 4 Then
				.clr.Set(CInt(array(1)), CInt(array(2)), CInt(array(3)), CInt(array(4)))
			Else
				.Clr.Set(255,255,255,192)
			EndIf
			Print "Color: " & .Clr.r & "," & .Clr.g & "," & .Clr.b & "," & .Clr.a
			'' ==============
			'' Color var
			tmp_str = file.ReadString(section_name, "colorVar", "0,0,0,0")
			_StringSplit(tmp_str, ",", array())
			If UBound(array) = 4 Then
				.clr.SetVar(CInt(array(1)), CInt(array(2)), CInt(array(3)), CInt(array(4)))
			Else
				.Clr.SetVar(0,0,0,0)
			EndIf
			Print "ColorVar: " & .Clr.rVar & "," & .Clr.gVar & "," & .Clr.bVar & "," & .Clr.aVar
			'' ==============
			'' Color fly Var
			tmp_str = file.ReadString(section_name, "colorFlyVar", "0,0,0,0")
			_StringSplit(tmp_str, ",", array())
			If UBound(array) = 4 Then
				.FlyVar_R = CInt(array(1))
				.FlyVar_G = CInt(array(2))
				.FlyVar_B = CInt(array(3))
				.FlyVar_A = CInt(array(4))
			Else
				.FlyVar_R = 0
				.FlyVar_G = 0
				.FlyVar_B = 0
				.FlyVar_A = 0
			EndIf
			Print "ColorFlyVar: " & .FlyVar_R & "," & .FlyVar_G & "," & .FlyVar_B & "," & .FlyVar_A
			'' ==============
			'' Blend mode
			tmp_str = file.ReadString(section_name, "BlendMode", "BM_TRANS")
			Select Case tmp_str
				Case "BM_TRANS"
					.blendMode = BM_TRANS
				Case "BM_SOLID"
					.blendMode = BM_SOLID
				Case "BM_BLENDED"
					.blendMode = BM_BLENDED
				Case "BM_GLOW"
					.blendMode = BM_GLOW
				Case "BM_BLACK"
					.blendMode = BM_BLACK
				Case Else
					.blendMode = BM_TRANS
			End Select
			'' ==============
		End With
	End Function
	
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
			
			''' Texture Rect
			_ptr_->texRect = .texRect
			
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
		Dim As Single min, max
		min = This.Angle - This.AngleVar
		max = This.Angle + This.AngleVar
		Dim iAngle As Single = Random_Double(min, max)
		
		Return _ReduceAngle(iAngle)
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
