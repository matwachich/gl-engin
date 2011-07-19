
Namespace GLE
	
	Type Char_Font
		As UByte id
		As Rect texRect
		As v2d size
		As v2d offset
		As Byte advance
	End Type
	
	Type Font
		Declare Constructor(ByVal fontPath As String, ByVal texturePath As String)
		Declare Destructor()
		Declare Sub Draw(ByVal Position As v2d, ByVal text As String, ByVal size As UShort, ByVal _color As UInteger)
		Declare Function StringWidth(ByVal text As String, ByVal size As UShort) As Short
		
		Private:
		As Texture tex
		As Short lineHeight, Base, fontSize
		As UByte chars_nbr = 0
		As Char_Font Ptr Array(0 To 255)
		Declare Function __GetChar(ByVal id As UByte) As Char_Font Ptr
		Declare Sub __ParseLine(ByVal _line As String)
		Declare Sub __WriteChar(ByRef Position As v2d, ByVal char As Char_Font Ptr, sizeRatio As Single)
	End Type
	
	''==================================
	''==================================
	''==================================
	
	Constructor Font(ByVal fontPath As String, ByVal texturePath As String)
		This.tex = Texture(texturePath)
		''===
		Dim readLine As String
		Dim file As Integer = FreeFile
		Open fontPath For Input As #file
		Do
			Line Input #file, readLine
			This.__ParseLine(readLine)
		Loop Until Eof(file)
		Close file
		''===
	End Constructor
	
	Destructor Font()
		For i As Short = 0 To chars_nbr
			Delete This.Array(i)
		Next i
	End Destructor
	
	Sub Font.Draw(ByVal Position As v2d, ByVal text As String, ByVal size As UShort, ByVal _color As UInteger)
		Dim text_len As Short = Len(text)
		If text_len < 1 Then Return
		'''
		If size < 1 Then Return
		'''
		glEnable(GL_TEXTURE_2D)
		glColor4ubv(Cast(GLubyte Ptr, @_color))
		This.tex.Activate()
		'''
		Dim originalPosX As Single = Position.x
		Dim sizeRatio As Single = size / This.fontSize
		'''
		Dim char As String
		Dim charPtr As Char_Font Ptr
		For i As Short = 1 To text_len
			char = Mid(text, i, 1)
			If char = "\" And Mid(text, i + 1, 1) = "n" Then
				Position.x = originalPosX
				Position.y += This.lineHeight * sizeRatio
				i += 1
			Else
				charPtr = This.__GetChar(Asc(char))
				If charPtr <> 0 Then
					This.__WriteChar(Position, charPtr, sizeRatio)
				Else
					This.__WriteChar(Position, This.__GetChar(Asc(" ")), sizeRatio) ' if the char is not found, writes a blank space
				EndIf
			EndIf
		Next i
	End Sub
	
	Sub Font.__WriteChar(ByRef Position As v2d, ByVal char As Char_Font Ptr, ByVal sizeRatio As Single)
		Dim caret_pos As v2d = Position
		caret_pos.x += char->offset.x * sizeRatio
		caret_pos.y += char->offset.y * sizeRatio
		'''
		glBegin(GL_TRIANGLE_FAN)
			glTexCoord2d(char->texRect.x, char->texRect.y)
			glVertex2d(caret_pos.x, caret_pos.y)

			glTexCoord2d(char->texRect.x + char->texRect.w, char->texRect.y)
			glVertex2d(caret_pos.x + (char->size.x * sizeRatio), caret_pos.y)

			glTexCoord2d(char->texRect.x + char->texRect.w, char->texRect.y + char->texRect.h)
			glVertex2d(caret_pos.x + (char->size.x * sizeRatio), caret_pos.y + (char->size.y * sizeRatio))

			glTexCoord2d(char->texRect.x, char->texRect.y + char->texRect.h)
			glVertex2d(caret_pos.x, caret_pos.y + (char->size.y * sizeRatio))
		glEnd()
		'''
		Position.x += char->advance * sizeRatio
	End Sub
	
	Function Font.StringWidth(ByVal text As String, ByVal size As UShort) As Short
		Dim text_len As Short = Len(text)
		If text_len < 1 Then Return -1
		'''
		If size < 1 Then Return -1
		'''
		Dim lenght As Short = 0
		Dim sizeRatio As Single = size / This.fontSize
		Dim charPtr As Char_Font Ptr
		For i As Short = 1 To text_len
			charPtr = This.__GetChar(Asc(Mid(text, i, 1)))
			If charPtr <> 0 Then
				lenght += charPtr->advance * sizeRatio
			Else
				charPtr = This.__GetChar(Asc(" "))
				lenght += charPtr->advance * sizeRatio
			EndIf
		Next i
		Return lenght
	End Function
	
	Sub Font.__ParseLine(ByVal _line As String)
		If Left(_line, 4) = "info" Then
			This.fontSize = Abs(CInt(Mid(_line, 26, 4)))
			Return
		EndIf
		''===
		If Left(_line, 6) = "common" Then
			This.lineHeight = CInt(Mid(_line, 19, 3))
			This.Base = CInt(Mid(_line, 27, 3))
			Return
		EndIf
		''===
		Dim As Integer id, x, y, w, h, ox, oy, advance
		If Left(_line, 7) = "char id" Then
			This.Array(This.chars_nbr) = New Char_Font
			''===
			id = CUByte(Mid(_line, 9, 5))
			x = CInt(Mid(_line, 16, 6))
			y = CInt(Mid(_line, 24, 6))
			w = CInt(Mid(_line, 36, 6))
			h = CInt(Mid(_line, 49, 6))
			ox = CInt(Mid(_line, 63, 6))
			oy = CInt(Mid(_line, 77, 6))
			advance = CByte(Mid(_line, 92, 6))
			''===
			This.Array(This.chars_nbr)->id = id
			This.Array(This.chars_nbr)->texRect = Rect(x / This.tex.w, y / This.tex.h, w / This.tex.w, h / This.tex.h)
			This.Array(This.chars_nbr)->size = v2d(w, h)
			This.Array(This.chars_nbr)->offset = v2d(ox, oy)
			This.Array(This.chars_nbr)->advance = advance
			''===
			This.chars_nbr += 1
			Return
		EndIf
	End Sub
	
	Function Font.__GetChar(ByVal id As UByte) As Char_Font Ptr
		For i As Short = 0 To chars_nbr
			If This.Array(i)->id = id Then Return This.Array(i)
		Next i
		Return 0
	End Function
		
End Namespace
