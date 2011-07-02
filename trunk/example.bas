#Include "glengin.bi"
#Include "perso/dyn_array.bi"

Using GLE

Dim main As Display = Display(1024, 768, FALSE, "Space Ship", 1, 0, 0, TRUE)
main.SetBKColor(128,64,128,255)
''======================================================================

Dim tex_BK As Texture = Texture("res\avion\bk.png")
Dim tex_AVION As Texture = Texture("res\avion\avion.png")
Dim tex_BALLE As Texture = Texture("res\avion\balle.png")

Dim tex_Particles As Texture = Texture("res\avion\particles.png")
''======================================================================

Dim Shared part_FLY As Particle_Emitter
part_FLY = Particle_Emitter(@tex_Particles, Rect(0*32, 3*32, 32, 32))
With part_FLY
	'.Position = v2d(400,300)
	.PositionVar = v2d(3, 3)
	
	.Vel = 200
	.VelVar = 100
	
	.Accel = 0
	.AccelVar = 0
	
	.Angle = 180
	.AngleVar = 10
	
	.Force = 0
	.ForceVar = 0
	.Force_Angle = 0
	.Force_AngleVar = 0
	
	.Spin = 0
	.SpinVar = 1200
	.SpinFlyVar = 0
	
	.Size = 12
	.SizeVar = 4
	.SizeFlyVar = -200
	
	.Clr.Set(255,255,255,64)
	.Clr.SetVar(0,255,255,0)
	.FlyVar_R = 0
	.FlyVar_G = 0
	.FlyVar_B = 0
	.FlyVar_A = -255
	.BlendMode = BM_BLENDED
	
	.Max_Particles = 200
	.ParticlesPerEmitte = 7
	.Emitte_Delay = 0.01
	
	.Life_Time = 0.1
	.Life_TimeVar = 0.05
End With

Dim Shared part_SHOOT As Particle_Emitter
part_SHOOT = Particle_Emitter(@tex_Particles, Rect(0*32, 0*32, 32, 32))
With part_SHOOT
	'.Position = v2d(400,300)
	.PositionVar = v2d(2, 2)
	
	.Vel = 300
	.VelVar = 200
	
	.Accel = 0
	.AccelVar = 0
	
	.Angle = 0
	.AngleVar = 30
	
	.Force = 0
	.ForceVar = 0
	.Force_Angle = 0
	.Force_AngleVar = 0
	
	.Spin = 0
	.SpinVar = 1200
	.SpinFlyVar = 0
	
	.Size = 8
	.SizeVar = 0
	.SizeFlyVar = -150
	
	.Clr.Set(64,128,64,192)
	.Clr.SetVar(0,0,0,0)
	.FlyVar_R = 0
	.FlyVar_G = 0
	.FlyVar_B = 0
	.FlyVar_A = -1000
	.BlendMode = BM_BLENDED
	
	.Max_Particles = 100
	.ParticlesPerEmitte = 5
	.Emitte_Delay = 0.01
	
	.Life_Time = 0.1
	.Life_TimeVar = 0.02
End With

Dim Shared part_SMOKE As Particle_Emitter
part_SMOKE = Particle_Emitter(@tex_Particles, Rect(0*32, 2*32, 32, 32))
With part_SMOKE
	'.Position = v2d(400,300)
	.PositionVar = v2d(5, 5)
	
	.Vel = 2
	.VelVar = 1
	
	.Accel = 0
	.AccelVar = 0
	
	.Angle = 0
	.AngleVar = 180
	
	.Force = 0
	.ForceVar = 0
	.Force_Angle = 0
	.Force_AngleVar = 0
	
	.Spin = 0
	.SpinVar = 0
	.SpinFlyVar = 0
	
	.Size = 8
	.SizeVar = 2
	.SizeFlyVar = 8
	
	.Clr.Set(128,128,128,192)
	.Clr.SetVar(0,0,0,0)
	.FlyVar_R = 0
	.FlyVar_G = 0
	.FlyVar_B = 0
	.FlyVar_A = -64
	.BlendMode = BM_TRANS
	
	.Max_Particles = 500
	.ParticlesPerEmitte = 1
	.Emitte_Delay = 0.01
	
	.Life_Time = 3
	.Life_TimeVar = 0.5
End With

Dim Shared part_BALLE As Particle_Emitter
part_BALLE = Particle_Emitter(@tex_Particles, Rect(0*32, 1*32, 32, 32))
With part_BALLE
	'.Position = v2d(400,300)
	.PositionVar = v2d(0, 0)
	
	.Vel = 8
	.VelVar = 2
	
	.Accel = 0
	.AccelVar = 0
	
	.Angle = 0
	.AngleVar = 180
	
	.Force = 0
	.ForceVar = 0
	.Force_Angle = 0
	.Force_AngleVar = 0
	
	.Spin = 0
	.SpinVar = 1200
	.SpinFlyVar = 0
	
	.Size = 4
	.SizeVar = 2
	.SizeFlyVar = -8
	
	.Clr.Set(128,255,128,255)
	.Clr.SetVar(0,0,0,0)
	.FlyVar_R = 0
	.FlyVar_G = 0
	.FlyVar_B = 0
	.FlyVar_A = 0
	.BlendMode = BM_BLENDED
	
	.Max_Particles = 1000
	.ParticlesPerEmitte = 1
	.Emitte_Delay = 0.01
	
	.Life_Time = 0.5
	.Life_TimeVar = 0.1
End With

''======================================================================

Dim Shared spr_BK As Sprite
spr_BK = Sprite(@tex_BK)
spr_BK.Size = v2d(1024,768)


Dim Shared spr_Avion As Sprite
spr_Avion = Sprite(@tex_AVION)
With spr_Avion
	.Size = v2d(48, 48)
	.SetOrigin(O_MID)
End With

Dim Shared dyn_Avion As Dynamique = Dynamique(@spr_Avion)
With dyn_Avion
	.Position = v2d(1024/2,768/2)
	.VelMax = 300
	.AngleVelMax = 180
	.Innertie = 150
	.AngleInnertie = 300
End With
''======================================================================

Declare Sub KeyBoardCallback(ByVal key As Integer, ByVal action As Integer)
glfwSetKeyCallback(@KeyBoardCallback)

Dim Shared shot_array As Dyn_Array
Declare Sub _Shot(ByVal tex As Texture Ptr, ByVal position As v2d, ByVal angle As Single)
Declare Sub _Shot_Draw()

Dim shoot_timer As Double = TimerInit()
Dim vect As v2d

Do
	main.Draw_Begin()
	'''
		spr_BK.Draw()
		
		part_SMOKE.Draw()
		part_FLY.Draw()
		part_SHOOT.Draw()
		part_BALLE.Draw()
		
		_Shot_Draw()
		
		Dyn_Avion.Draw()
	'''	
	main.Draw_End()
	
	If TimerDiff(shoot_timer) >= 0.1 And glfwGetKey(GLFW_KEY_SPACE) = GLFW_PRESS Then
		part_SHOOT.Angle = spr_AVION.angle
		
		part_SHOOT.Position = spr_Avion.GetPoint(0.55,0.19)'v2d(0.55,13))
		_Shot(@tex_BALLE, part_SHOOT.Position, part_SHOOT.Angle)
		part_SHOOT.Spawn(10)
		
		part_SHOOT.Position = spr_Avion.GetPoint(0.55,0.81)'v2d(0.55,51))
		_Shot(@tex_BALLE, part_SHOOT.Position, part_SHOOT.Angle)
		part_SHOOT.Spawn(10)
		'''
		shoot_timer = TimerInit()
	EndIf
	
	If glfwGetKey(GLFW_KEY_UP) = GLFW_PRESS Then
		part_FLY.Angle = spr_Avion.Angle + 180
		part_FLY.Position = spr_Avion.GetPoint(-0.01, 0.5)'v2d(-4,33))
		part_SMOKE.Position = spr_Avion.GetPoint(-0.01, 0.5)'v2d(-4,33))
		part_FLY.actif = TRUE
		part_SMOKE.actif = TRUE
		'''
		vect.FromAngle(Dyn_Avion.Angle, 1000)
		Dyn_Avion.Accel = vect
	ElseIf glfwGetKey(GLFW_KEY_UP) = GLFW_RELEASE Then
		part_FLY.actif = FALSE
		part_SMOKE.actif = FALSE
		'''
		Dyn_Avion.Accel = v2d0
	EndIf
	
	main.SetCaption("Space Ship - FPS: " & main.GetFPS())
	
Loop Until glfwGetKey(GLFW_KEY_ESC) = GLFW_PRESS

For i As Integer = 0 To shot_array.UBound() - 1
	Print "Delete " & i
	Delete Cast(Dynamique Ptr, shot_array.Elem(i))->Spr
	Delete Cast(Dynamique Ptr, shot_array.Elem(i))
Next i

''======================================================================

Sub _Shot(ByVal tex As Texture Ptr, ByVal position As v2d, ByVal angle As Single)
	Dim spr As Sprite Ptr = New Sprite(tex)
	spr->blendMode = BM_BLENDED
	spr->SetOrigin(O_MID)
	'''
	Dim vect As v2d
	Dim Dyn As Dynamique Ptr = New Dynamique(spr)
	Dyn->Position = position
	Dyn->Angle = angle
		
	vect.FromAngle(Random_Double(angle - 1,angle + 1), Random_Int(1150,1250))
	Dyn->Vel = vect
		
	'Dyn->AngleVel = 1200

	'''
	shot_array.Add(Cast(Integer, Dyn))
End Sub

Sub _Shot_Draw()
	Dim _ptr As Dynamique Ptr
	Dim _spr As Dynamique Ptr
	For i As Integer = shot_array.UBound() - 1 To 0 Step -1
		_ptr = Cast(Dynamique Ptr, shot_array.Elem(i))
		_ptr->Draw()
		'''
		part_BALLE.Position = _ptr->Position
		part_BALLE.Spawn(1)
		'''
		If _ptr->Position.IsInRect(Rect(0,0,1024,768)) = FALSE Then
			_spr = _ptr->spr
			Delete _spr
			shot_array.Del(i)
		EndIf
	Next i
End Sub

Sub KeyBoardCallback(ByVal key As Integer, ByVal action As Integer)
	Dim vect As v2d
	If key = GLFW_KEY_LEFT Then
		If action = GLFW_PRESS Then
			Dyn_Avion.AngleAccel = -1000
		Else
			Dyn_Avion.AngleAccel = 0
		EndIf
	EndIf
	If key = GLFW_KEY_RIGHT Then
		If action = GLFW_PRESS Then
			Dyn_Avion.AngleAccel = 1000
		Else
			Dyn_Avion.AngleAccel = 0
		EndIf
	EndIf
	If key = GLFW_KEY_DOWN Then
		If action = GLFW_PRESS Then
			Dyn_Avion.innertie = 400
		Else
			Dyn_Avion.innertie = 200
		EndIf
	EndIf
End Sub

