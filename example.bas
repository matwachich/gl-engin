#Include "glengin.bi"

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
	.PositionVar = v2d(5, 5)
	
	.Vel = 300
	.VelVar = 50
	
	.Accel = 0
	.AccelVar = 0
	
	.Angle = 180
	.AngleVar = 5
	
	.Force = 0
	.ForceVar = 0
	.Force_Angle = 0
	.Force_AngleVar = 0
	
	.Spin = 0
	.SpinVar = 1200
	.SpinFlyVar = 0
	
	.Size = 16
	.SizeVar = 2
	.SizeFlyVar = -200
	
	.Clr.Set(255,255,255,96)
	.Clr.SetVar(0,255,255,0)
	.FlyVar_R = 0
	.FlyVar_G = 0
	.FlyVar_B = 0
	.FlyVar_A = -255
	.BlendMode = BM_BLENDED
	
	.Max_Particles = 200
	.ParticlesPerEmitte = 5
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
	
	.Size = 10
	.SizeVar = 0
	.SizeFlyVar = -200
	
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
	.SizeFlyVar = 0
	
	.Clr.Set(128,128,128,192)
	.Clr.SetVar(0,0,0,0)
	.FlyVar_R = 0
	.FlyVar_G = 0
	.FlyVar_B = 0
	.FlyVar_A = 0
	.BlendMode = BM_BLACK
	
	.Max_Particles = 500
	.ParticlesPerEmitte = 1
	.Emitte_Delay = 0.01
	
	.Life_Time = 2
	.Life_TimeVar = 0.5
End With

Dim Shared part_LUEUR As Particle_Emitter
part_LUEUR = Particle_Emitter(@tex_Particles, Rect(2*32, 2*32, 32, 32))
With part_LUEUR
	'.Position = v2d(400,300)
	.PositionVar = v2d(4, 4)
	
	.Vel = 0
	.VelVar = 0
	
	.Accel = 0
	.AccelVar = 0
	
	.Angle = 0
	.AngleVar = 0
	
	.Force = 0
	.ForceVar = 0
	.Force_Angle = 0
	.Force_AngleVar = 0
	
	.Spin = 0
	.SpinVar = 360
	.SpinFlyVar = 0
	
	.Size = 32
	.SizeVar = 0
	.SizeFlyVar = -5
	
	.Clr.Set(64,192,64,128)
	.Clr.SetVar(0,0,0,0)
	.FlyVar_R = 0
	.FlyVar_G = 0
	.FlyVar_B = 0
	.FlyVar_A = 0
	.BlendMode = BM_BLENDED
	
	.Max_Particles = 1000
	.ParticlesPerEmitte = 1
	.Emitte_Delay = 0.01
	
	.Life_Time = 3
	.Life_TimeVar = 0
End With
''======================================================================

Dim Shared spr_BK As Sprite
spr_BK = Sprite(@tex_BK)
spr_BK.Size = v2d(1024,768)


Dim Shared spr_Avion As Sprite
spr_Avion = Sprite(@tex_AVION)
With spr_Avion
	.Size = v2d(64, 64)
	.SetOrigin(O_MID)
End With

Dim Shared dyn_Avion As Dynamique = Dynamique(@spr_Avion)
With dyn_Avion
	.Position = v2d(1024/2,768/2)
	.VelMax = 300
	.AngleVelMax = 180
	.Innertie = 200
	.AngleInnertie = 360
End With
''======================================================================

Declare Sub KeyBoardCallback(ByVal key As Integer, ByVal action As Integer)
glfwSetKeyCallback(@KeyBoardCallback)

Dim shoot_timer As Double = TimerInit()
Dim vect As v2d

Do
	main.Draw_Begin()
	'''
		spr_BK.Draw()
		
		part_SMOKE.Draw()
		part_FLY.Draw()
		part_SHOOT.Draw()
		
		'part_LUEUR.Draw()
		Dyn_Avion.Draw()
	'''	
	main.Draw_End()
	
	If TimerDiff(shoot_timer) >= 0.1 And glfwGetKey(GLFW_KEY_SPACE) = GLFW_PRESS Then
		part_SHOOT.Angle = spr_AVION.angle
		part_SHOOT.Position = spr_Avion.GetPoint(v2d(35,13))
		part_SHOOT.Spawn(10)
		part_SHOOT.Position = spr_Avion.GetPoint(v2d(35,51))
		part_SHOOT.Spawn(10)
		shoot_timer = TimerInit()
	EndIf
	
	If glfwGetKey(GLFW_KEY_UP) = GLFW_PRESS Then
		part_FLY.Angle = spr_Avion.Angle + 180
		part_FLY.Position = spr_Avion.GetPoint(v2d(-4,33))
		part_SMOKE.Position = spr_Avion.GetPoint(v2d(-4,33))
		part_LUEUR.Position = spr_Avion.GetPoint(v2d(-4,33))
		'part_LUEUR.Position = spr_Avion.GetPoint(v2d(16,3))
		part_FLY.actif = TRUE
		part_SMOKE.actif = TRUE
		part_LUEUR.actif = TRUE
		'''
		vect.FromAngle(Dyn_Avion.Angle, 1000)
		Dyn_Avion.Accel = vect
	ElseIf glfwGetKey(GLFW_KEY_UP) = GLFW_RELEASE Then
		part_FLY.actif = FALSE
		part_SMOKE.actif = FALSE
		part_LUEUR.actif = FALSE
		Dyn_Avion.Accel = v2d0
	EndIf
	
	main.SetCaption("Space Ship - FPS: " & main.GetFPS())
	
Loop' Until glfwGetKey(GLFW_KEY_ESC) = GLFW_PRESS

''======================================================================


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

