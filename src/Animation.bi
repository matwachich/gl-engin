
'File: Animation

Namespace GLE
	
	/'
	Class: Animation
		Animation is a group of frames with a delay that can be applied to a <Sprite>
	
	Definition:
		(start code)
		Type Animation
			Declare Constructor()
			Declare Destructor()
			Declare Sub AddFrame(ByVal tex As Texture Ptr, ByVal duration As Single)
			Declare Sub AddFrame(ByVal tex As Texture Ptr, ByVal duration As Single, ByVal texRect As Rect)
			Declare Sub AddFrame(ByVal tex As Texture Ptr, ByVal duration As Single, ByVal texRect As Rect, ByVal _color As UInteger)
			'''
			As UShort nbr_frames = 0
			As Anim_Frame Ptr array(1 To _MAX_FRAMES_)
			'''
			Private:
			Declare Sub __AddFrame(ByVal tex As Texture Ptr, ByVal duration As Single, ByVal texRect As Rect, ByVal _color As UInteger)
		End Type
		(end)
	'/
	
	'===============================================================================
	
	/'
	Constructor: Animation
		Default constructor, create an empty <Animation> object.
	'/
	Constructor Animation()
		For i As Short = 0 To _MAX_FRAMES_
			This.array(i) = 0
		Next i
	End Constructor
	
	/'
	Destructor: Animation
	'/
	Destructor Animation()
		For i As Short = 0 To _MAX_FRAMES_
			If This.array(i) <> 0 Then Delete This.array(i)
		Next i
	End Destructor
	
	/'
	Method: AddFrame
		Add a frame to the <Animation>.
	
	Parameters:
		tex (Texture Ptr) - Pointer to a texture object
		duration (Single) - Duration of the frame (in ms)
		texRect (Rect) - Optional, rectangle to take from the texture object (Rect(0,0,0,0) to take the whole texture)
		_color (UInteger) - Optional, color of the frame (use GLE_RGBA macro)
	'/
	Sub Animation.AddFrame(ByVal tex As Texture Ptr, ByVal duration As Single)
		This.__AddFrame(tex, duration, Rect(0,0,0,0), GLE_RGBA(255,255,255,255))
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
	
	''=======================================================================
	''=======================================================================
	
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
	
End Namespace
