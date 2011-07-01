#Include "GLEngin.bi"
Using GLE

Dim root As Display = Display(800, 600, FALSE, "Matwachich!", 1, 0, 0, 1)
	root.SetBKColor(128,128,64,0)
	
Dim tex As Texture = Texture("res\test.png")
Dim texP As Texture = Texture("res\particles.png")
Dim texAnim As Texture = Texture("res\anim.png")
Dim texAnim2 As Texture = Texture("res\anim2.png")

Dim As Sprite spr = Sprite(@tex)
With spr
	.Size = v2d(128,128)
	.SetTextureRect(Rect(0,0,0,0))
	.Position = v2d(400,300)
	.Color = GLE_RGBA(255,255,255,255)
	.SetOrigin(O_MID)
	'.SetTextureRect(0,0,512,512)
End With
	
Dim As Sprite spr2 = Sprite(@texP)
With spr2
	.Size = v2d(48,48)
	.SetTextureRect(Rect(0,0,32,32))
	.Position = v2d(0,0)
	.Color = GLE_RGBA(255,255,255,255)
	.SetOrigin(O_MID)
End With

Dim As Sprite animated = Sprite()
With animated
	.Size = v2d(40, 40)
	.Position = v2d(80, 80)
	.SetOrigin(O_MID)
End With

Dim As Sprite animated2 = Sprite()
With animated2
	.Size = v2d(102, 102)
	.Position = v2d(400, 80)
	.SetOrigin(O_MID)
End With

Dim As Animation anim = Animation()
With anim
	For i As Short = 0 To 4
		For j As Short = 0 To 4
			.AddFrame(@texAnim, 0.02, Rect(j*40,i*40,40,40))
		Next j
	Next i
End With

Dim As Animation anim2 = Animation()
With anim2
	For i As Short = 0 To 7
		.AddFrame(@texAnim2, 0.02, Rect(i*102,0,102,102))
	Next i
End With

Dim Shared emitter As Particle_Emitter
'emitter = Particle_Emitter()
emitter = Particle_Emitter(@texP, Rect(0*32, 0*32, 32, 32))
With emitter
	
	.Position = v2d(400,300)
	.PositionVar = v2d(10, 10)
	
	.Vel = 400
	.VelVar = 100
	
	.Accel = -200
	.AccelVar = 0
	
	.Angle = 0
	.AngleVar = 0
	
	.Force = 0
	.ForceVar = 0
	.Force_Angle = 0
	.Force_AngleVar = 0
	
	.Spin = 0
	.SpinVar = 1200
	.SpinFlyVar = 0
	
	.Size = 48
	.SizeVar = 8
	.SizeFlyVar = -100
	
	.Clr.Set(255,255,255,255)
	.Clr.SetVar(0,255,255,0)
	.FlyVar_R = 0
	.FlyVar_G = 0
	.FlyVar_B = 0
	.FlyVar_A = -255
	.BlendMode = BM_BLENDED
	
	.Max_Particles = 200
	.ParticlesPerEmitte = 5
	.Emitte_Delay = 0.01
	
	.Life_Time = 0.3
	.Life_TimeVar = 0.1
	
End With

	
Dim As Integer x, y
Dim As Integer partTexRect_X = 0, partTexRect_Y = 0

Dim As v2d p = v2d(0,0)

Dim As Double _timer_ = TimerInit()

Dim Shared is_anim As BOOL = FALSE

Declare Sub MouseCallback(ByVal but As Integer, ByVal action As Integer)
glfwSetMouseButtonCallback(@MouseCallback)

Do
	
	p = spr.GetPoint(0, 0.5)
	emitter.Position = p
	emitter.Angle = spr.Angle + 180
	
	p = spr.GetPoint(1.1, 0.5)
	spr2.Position = p
	spr.Angle = spr.Angle - 1
	
	glfwGetMousePos(@x, @y)
	spr.Position = v2d(x,y)
	
	If is_anim = TRUE Then
		is_anim = animated.Animate(@anim, 100)
		Locate 2, 1: Print is_anim
	Else
		animated.tex = 0
		animated.AnimRewind(1)
	EndIf
	
	'animated2.Animate(@anim2)
	
	If TimerDiff(_timer_) >= 1 Then
		partTexRect_X += 1
		If partTexRect_X = 4 Then
			partTexRect_X = 0
			partTexRect_Y += 1
		EndIf
		If partTexRect_Y = 4 Then partTexRect_Y = 0
		'''
		Locate 1, 1: Print partTexRect_X, partTexRect_Y
		emitter.SetTextureRect(Rect(partTexRect_X * 32, partTexRect_Y * 32, 32, 32))
		spr2.SetTextureRect(Rect(partTexRect_X * 32, partTexRect_Y * 32, 32, 32))
		_timer_ = TimerInit()
	EndIf
	
	root.Draw_Begin()
	'''
		emitter.draw()
		
		Draw_LineGlow(v2d(0,0), spr.Position, GLE_RGBA(255,255,255,255), 20)
		
		spr.Draw()
		spr2.Draw()
		animated.Draw()
		animated2.Draw(@anim2)
	'''	
	root.Draw_End()
	
	root.SetCaption("Matwachich! - FPS: " & root.GetFPS() & " - Particles: " & emitter._nbr_particles)

Loop Until glfwGetKey(GLFW_KEY_ESC) = GLFW_PRESS

End



Sub MouseCallback(ByVal but As Integer, ByVal action As Integer)
	Select Case but
		Case GLFW_MOUSE_BUTTON_LEFT
			Select Case action
				Case GLFW_PRESS
					emitter.Actif = TRUE
				Case GLFW_RELEASE
					emitter.Actif = FALSE
			End Select
		Case GLFW_MOUSE_BUTTON_RIGHT
			If action = GLFW_PRESS Then emitter.Spawn(500)
			is_anim = TRUE
	End Select
End Sub
