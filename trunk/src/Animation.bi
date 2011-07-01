
Namespace GLE
	
	Constructor Anim_Frame(ByVal tex As Texture Ptr, ByVal duration As Single, ByVal texRect As Rect, ByVal _color As UInteger)
		With This
			.tex = tex
			.texRect = texRect
			.duration = duration
			._color = _color
		End With
	End Constructor
	Sub Anim_Frame.__ApplyFrame(ByVal spr As Any Ptr)
		Dim _ptr As Sprite Ptr = spr
		_ptr->SetTexture(This.tex)
		_ptr->setTextureRect(This.texRect)
		_ptr->Color = This._color
		_ptr->Anim_CurrFramDuration = This.duration
	End Sub
	
	''=======================================================================
	''=======================================================================
	
	Constructor Animation()
		For i As Short = 0 To _MAX_FRAMES_
			This.array(i) = 0
		Next i
	End Constructor
	Destructor Animation()
		For i As Short = 0 To _MAX_FRAMES_
			If This.array(i) <> 0 Then Delete This.array(i)
		Next i
	End Destructor
	
	Sub Animation.AddFrame(ByVal tex As Texture Ptr, ByVal duration As Single)
		This.__AddFrame(tex, duration, Rect(0,0,1,1), GLE_RGBA(255,255,255,255))
	End Sub
	Sub Animation.AddFrame(ByVal tex As Texture Ptr, ByVal duration As Single, ByVal texRect As Rect)
		This.__AddFrame(tex, duration, texRect, GLE_RGBA(255,255,255,255))
	End Sub
	Sub Animation.AddFrame(ByVal tex As Texture Ptr, ByVal duration As Single, ByVal texRect As Rect, ByVal _color As UInteger)
		This.__AddFrame(tex, duration, texRect, _color)
	End Sub
	Sub Animation.__AddFrame(ByVal tex As Texture Ptr, ByVal duration As Single, ByVal texRect As Rect, ByVal _color As UInteger)
		If This.nbr_frames >= _MAX_FRAMES_ Then Return
		'''
		This.array(This.nbr_frames + 1) = New Anim_Frame(tex, duration, texRect, _color)
		This.nbr_frames += 1
	End Sub
	
End Namespace
