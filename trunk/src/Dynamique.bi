
Namespace GLE
	
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
			If .AngleVel <> 0 Then
				.Angle = .Angle + (.AngleVel * dt)
			EndIf
			' --- Acc�l�ration
			If .AngleAccel <> 0 Then
				.AngleVel += .AngleAccel * dt
			EndIf
			' --- Innertie
			Dim tmp As Single = .AngleVel
			If .AngleInnertie <> 0 And .AngleVel <> 0 Then
				If .AngleVel > 0 Then
					.AngleVel -= Abs(.AngleInnertie) * dt
				ElseIf .AngleVel < 0 Then
					.AngleVel += Abs(.AngleInnertie) * dt
				EndIf
				If .AngleVel / tmp < 0 Then .AngleVel = 0
			EndIf
			
			'; ##############################################################
			
			'; Acc�l�ration
			.Vel.x += .Accel.x * dt
			.Vel.y += .Accel.y * dt
			Dim vitGrand As Single = .Vel.Grandeur()
			Dim vitAngle As Single = .Vel.Angle()
			
			'; Vitesse Maximum
			If .VelMax <> 0 And vitGrand > .VelMax Then
				.Vel.FromAngle(vitAngle, .VelMax)
			EndIf
			
			'; Position
			If .Vel.x <> 0 Then
				.Position.x += .Vel.x * dt
			EndIf
			If .Vel.y <> 0 Then
				.Position.y += .Vel.y * dt
			EndIf
			
			'; Innertie
			If .Innertie <> 0 And .Vel.x <> 0 And .Accel.x = 0 Then '; Innertie X
				tmp = .Vel.x
				If .Vel.x > 0 Then
					.Vel.x -= Abs(.Innertie) * dt
				ElseIf .Vel.x < 0 Then
					.Vel.x += Abs(.Innertie) * dt
				EndIf
				If .Vel.x / tmp < 0 Then .Vel.x = 0
			EndIf
			If .Innertie <> 0 And .Vel.y <> 0 And .Accel.y = 0 Then '; Innertie Y
				tmp = .Vel.y
				If .Vel.y > 0 Then
					.Vel.y -= Abs(.Innertie) * dt
				ElseIf .Vel.y < 0 Then
					.Vel.y += Abs(.Innertie) * dt
				EndIf
				If .Vel.y / tmp < 0 Then .Vel.y = 0
			EndIf
			
			'; ##############################################################
			
			'; R�initialisation du timer
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