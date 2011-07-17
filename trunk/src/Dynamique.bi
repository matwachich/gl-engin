
Namespace GLE
	
	Constructor Dynamique()
	End Constructor
	Constructor Dynamique(ByVal spr As Sprite Ptr)
		This.Position = spr->Position ' BUG: Doesn't work
		This.Angle = spr->Angle
		This.spr = spr
	End Constructor
		
	
	Sub Dynamique.Draw()
		This.Draw(FALSE)
	End Sub
	Sub Dynamique.Draw(ByVal _static As BOOL)
		If _static = FALSE Then This.__Move()
		''' Drawing
		If This.spr <> 0 Then
			This.spr->Position = This.Position
			This.spr->Angle = This.Angle
			This.spr->Draw()
		EndIf
	End Sub
	Sub Dynamique.__Move()
		With This
			If .move_timer = 0 Then
				.move_timer = TimerInit()
				Exit Sub
			EndIf
			'''
			Dim dt As Double = TimerDiff(.move_timer)
			'''
			
			' ### Rotation Max ###
			If .AngleVelMax <> 0 Then
				If Abs(.AngleVel) > Abs(.AngleVelMax) Then
					If .AngleVel >= 0 Then
						.AngleVel = Abs(.AngleVelMax)
					Else
						.AngleVel = -1 * Abs(.AngleVelMax)
					EndIf
				EndIf
			EndIf
			
			' ### Application de la rotation ###
			' --- Vitesse
			'If .AngleVel <> 0 Then
				.Angle = .Angle + (.AngleVel * dt)
			'EndIf
			' --- Accélération
			'If .AngleAccel <> 0 Then
				.AngleVel += .AngleAccel * dt
			'EndIf
			' --- Innertie
			Dim tmp As Single = .AngleVel
			If .AngleInnertie <> 0 And .AngleVel <> 0 And .AngleAccel = 0 Then
				If .AngleVel > 0 Then
					.AngleVel -= Abs(.AngleInnertie) * dt
				ElseIf .AngleVel < 0 Then
					.AngleVel += Abs(.AngleInnertie) * dt
				EndIf
				If .AngleVel / tmp < 0 Then .AngleVel = 0
			EndIf
			
			'; ##############################################################
			
			Dim vitGrand As Single = .Vel.Len()
			Dim vitAngle As Single = .Vel.Angle()
			
			'; Vitesse Maximum
			If .VelMax <> 0 And vitGrand >= .VelMax Then
				.Vel.FromAngle(vitAngle, .VelMax)
				'''
				'Dim force As v2d
				'force.FromAngle(vitAngle, 10 * (vitGrand / .VelMax) * (.VelMax - vitGrand))
				'''
				'Locate 3, 1: Print Using "#### , ####"; force.x; force.y
				'.Vel.x += force.x * dt
				'.Vel.y += force.y * dt
				'''
			EndIf
			
			'Locate 4, 1: Print Using "#####          "; .Vel.Len()
			
			'; Accélération
			'.Vel.x += .Accel.x * dt
			'.Vel.y += .Accel.y * dt
			.Vel = .Vel + (.Accel * dt)
			
			'; Position
			'.Position.x += .Vel.x * dt
			'.Position.y += .Vel.y * dt
			.Position = .Position + (.Vel * dt)
			
			'; Innertie
			Dim inner As v2d
			inner.FromAngle(.Vel.Angle(), .Innertie)

			If inner.x <> 0 And .Vel.x <> 0 And .Accel.x = 0 Then '; Innertie X
				tmp = .Vel.x
				If .Vel.x > 0 Then
					.Vel.x -= Abs(inner.x) * dt
				ElseIf .Vel.x < 0 Then
					.Vel.x += Abs(inner.x) * dt
				EndIf
				If .Vel.x / tmp < 0 Then .Vel.x = 0
			EndIf
			If inner.y <> 0 And .Vel.y <> 0 And .Accel.y = 0 Then '; Innertie Y
				tmp = .Vel.y
				If .Vel.y > 0 Then
					.Vel.y -= Abs(inner.y) * dt
				ElseIf .Vel.y < 0 Then
					.Vel.y += Abs(inner.y) * dt
				EndIf
				If .Vel.y / tmp < 0 Then .Vel.y = 0
			EndIf
			
			'; ##############################################################
			
			'; Réinitialisation du timer
			.move_timer = TimerInit()
		End With
	End Sub
	
	Property Dynamique.Angle() As Single
		Return This.PRIVATE_Angle
	End Property
	Property Dynamique.Angle(ByVal value As Single)
		This.PRIVATE_Angle = _ReduceAngle(value)
	End Property
	
End Namespace
