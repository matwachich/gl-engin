
''===================================
'' UDT: Texture
''===================================

Namespace GLE
	
	Constructor Texture()
		This.glTexture = 0
		This.w = 0
		This.h = 0
	End Constructor
	
	' Simply load a Texture
	Constructor Texture(ByVal FilePath As String)
		Dim As Integer w, h, d
		'''
		Dim As UByte Ptr img_data = SOIL_load_image(@FilePath, @w, @h, @d, SOIL_LOAD_RGBA)
		Dim As GLuint tex = SOIL_create_OGL_texture(img_data, w, h, d, SOIL_CREATE_NEW_ID, SOIL_FLAG_POWER_OF_TWO)
		SOIL_free_image_data(img_data)
		'''
		If tex = 0 Then
			This.glTexture = 0
			This.w = 0
			This.h = 0
		Else
			glBindTexture(GL_TEXTURE_2D, tex)
    		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT)
    		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT)
			'''
			This.glTexture = tex
			This.w = w
			This.h = h
		EndIf
	End Constructor
	
	' Load a Texture, advanced (SOIL Flags)
	Constructor Texture(ByVal FilePath As String, ByVal load_flags As Integer, ByVal texture_flag As Integer)
		Dim As Integer w, h, d
		'''
		Dim As UByte Ptr img_data = SOIL_load_image(@FilePath, @w, @h, @d, load_flags)
		Dim As GLuint tex = SOIL_create_OGL_texture(img_data, w, h, d, SOIL_CREATE_NEW_ID, texture_flag)
		SOIL_free_image_data(img_data)
		'''
		If tex = 0 Then
			This.glTexture = 0
			This.w = 0
			This.h = 0
		Else
			glBindTexture(GL_TEXTURE_2D, tex)
    		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT)
    		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT)
			This.glTexture = tex
			This.w = w
			This.h = h
		EndIf
	End Constructor
	
	' Binds the texture
	Sub Texture.Activate()
		If __Current_Texture = This.glTexture Then Return
		If This.glTexture = 0 Then
			glBindTexture(GL_TEXTURE_2D, 0)
		Else
			glEnable(GL_TEXTURE_2D)
			glBindTexture(GL_TEXTURE_2D, This.glTexture)
			__Current_Texture = This.glTexture
		EndIf
	End Sub
	
	' Cast operator ( to be able to write: glBindTexture(GL_TEXTURE_2D, Texture) )
	Operator Texture.Cast() As GLuint
		Return This.glTexture
	End Operator
	
End Namespace
