
'File: Parallax

Namespace GLE
	
	Type Parallax_Layer
		Declare Constructor(ByVal Display_Obj As Display Ptr, ByVal tex As Texture Ptr, ByVal texScale As v2d, ByVal roomSize As v2d, ByVal ratio As Single)
		Declare Destructor()
		Declare Sub Draw(ByVal scrollSpeedRatio As v2d)
		'''
		spr As Sprite Ptr
		roomSize As v2d
		ratio As Single
		'''
		Private:
		texScale As v2d
		Display_Obj As Display Ptr
		Declare Sub __CorrectPosition(ByRef position As v2d)
	End Type
	
	Constructor Parallax_Layer(ByVal Display_Obj As Display Ptr, ByVal tex As Texture Ptr, ByVal texScale As v2d, ByVal roomSize As v2d, ByVal ratio As Single)
		With This
			.Display_Obj = Display_Obj
			'''
			.spr = New Sprite(tex)
			.spr->Size = roomSize
			.spr->SetTextureRect(Rect(0, 0, .spr->Size.x / texScale.x, .spr->Size.y / texScale.y))
			.spr->SetOrigin(O_MID)
			'.spr.Position = v2d(Display_Obj->scrW / 2, Display_Obj->scrH / 2)
			'''
			.roomSize = roomSize
			.texScale = texScale
			.ratio = ratio
		End With
	End Constructor
	
	Destructor Parallax_Layer()
		Delete This.spr
	End Destructor
	
	Sub Parallax_Layer.Draw(ByVal position As v2d)
		With This
			Dim drw As v2d
			Dim pos_ratio As v2d = position / .roomSize
			
			drw.x = (.Display_Obj->ScrW * (1 - pos_ratio.x) * .ratio)
			drw.y = (.Display_Obj->ScrH * (1 - pos_ratio.y) * .ratio)
			
			.__CorrectPosition(drw)
			drw = .Display_Obj->ScreenToWorld(drw)

			.spr->Position = drw
			.spr->Draw()
		End With
	End Sub
	
	Sub Parallax_Layer.__CorrectPosition(ByRef position As v2d)
		With This
			If Position.IsInRect(Rect(0, 0, .Display_Obj->ScrW, .Display_Obj->ScrH)) = TRUE Then Return
			'''
			Dim substract As v2d = v2d(.spr->tex->w * .texScale.x, .spr->tex->h * .texScale.y)
			'''
			If Position.x > .spr->Size.x / 2 Then ' depasse a droite
				Do
					Position.x -= substract.x
				Loop Until Position.x < .spr->Size.x / 2
			EndIf
			If Position.x < (-1 * .spr->Size.x / 2) + .Display_Obj->scrW Then ' depasse a gauche
				Do
					Position.x += substract.x
				Loop Until Position.x > (-1 * .spr->Size.x / 2) + .Display_Obj->scrW
			EndIf
			'''
			If Position.y > .spr->Size.y / 2 Then ' depasse en bas
				Do
					Position.y -= substract.y
				Loop Until Position.y < .spr->Size.y / 2
			EndIf
			If Position.y < (-1 * .spr->Size.y / 2) + .Display_Obj->scrH Then ' depasse en haut
				Do
					Position.y += substract.y
				Loop Until Position.y > (-1 * .spr->Size.y / 2) + .Display_Obj->scrH
			EndIf
		End With
	End Sub
	
	''===================================
	'' Parallax Layers UDT
	''===================================
	/'
	Type Parallax_Layer
		Declare Constructor()
		Declare Constructor(ByVal Display_Obj As Display Ptr, ByVal Scene_Size As v2d, ByVal Tex As Texture Ptr, ByVal TexScale As v2d, ByVal ratio As Single)
		'''
		Declare Sub Draw(ByVal Position As v2d)
		'''
		Display_Obj As Display Ptr
		Scene_Size As v2d
		Tex As Texture Ptr
		ratio As Single
		'''
		'_color As UInteger = GLE_RGBA(255,255,255,255)
		'Blend As E_BLEND_MODE = BM_TRANS
		'''
		'Private:
		Spr As Sprite
		Private:
			As BOOL ok = FALSE
	End Type
	
	Constructor Parallax_Layer()
	End Constructor
	
	Constructor Parallax_Layer(ByVal Display_Obj As Display Ptr, ByVal Scene_Size As v2d, ByVal Tex As Texture Ptr, ByVal TexScale As v2d, ByVal ratio As Single)
		With This
			.Display_Obj = Display_Obj
			'If ratio > 1 Then
			'	.Scene_Size = Scene_Size * ratio
			'Else
				.Scene_Size = Scene_Size
			'EndIf
			.Tex = Tex
			.ratio = ratio
			'''==========
			
			.Spr = Sprite(Tex)
			.Spr.Size = Scene_Size
			.Spr.SetOrigin(O_MID)
			.Spr.SetTextureRect(Rect(0, 0, Scene_Size.x / TexScale.x, Scene_Size.y / TexScale.y))
			
			.ok = TRUE
		End With
	End Constructor
	
	'''
	Sub Parallax_Layer.Draw(ByVal Position As v2d)
		If This.ok = FALSE Then Exit Sub
		Locate 1, 1: Print Position
		
		With This
			Dim drw As v2d
			Dim pos_ratio As v2d = v2d(Position.x / .Scene_Size.x, Position.y / .Scene_Size.y)
			
			Locate 2, 1: Print pos_ratio
		
			drw.x = (.Display_Obj->ScrW * (1 - pos_ratio.x) * .ratio)
			drw.y = (.Display_Obj->ScrH * (1 - pos_ratio.y) * .ratio)
			
			'If .ratio > 1 Then
			'	drw.x -= (.Display_Obj->ScrW / .ratio)
			'	drw.y -= (.Display_Obj->ScrH / .ratio)
			'EndIf
			
			Locate 3, 1: Print "Draw: " & drw
			
			.spr.Position = .Display_Obj->ScreenPosition(drw)

			Locate 4, 1: Print "Spr Pos: " & .spr.Position
			
			.spr.Draw()
		End With
	End Sub
	'/
	
	
End Namespace
