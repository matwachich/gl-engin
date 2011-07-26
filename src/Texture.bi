
'File: Texture

Namespace GLE
	
	/'
	Class: Texture
		Texture object
	
	Definition:
		(start code)
		Type Texture
			Declare Constructor()
			Declare Constructor(ByVal FilePath As String)
			Declare Constructor(ByVal FilePath As String, ByVal load_flags As Integer, ByVal texture_flag As Integer)
			Declare Destructor()

			Declare Sub Activate()

			Declare Operator Cast() As GLuint

			As GLuint glTexture
			As Short w, h
		End Type
		(end)
		
	Property: glTexture (GLUint)
		Contains the glTexture identifier
	
	Property: w, h (Short)
		Dimensions of the texture (width and height)
	'/
	
	Constructor Texture()
		This.glTexture = 0
		This.w = 0
		This.h = 0
	End Constructor
	
	/'
	Constructor: Texture
		Load an image file into a <Texture> instance
	
	Prototype:
		>Constructor Texture(ByVal FilePath As String)
	
	Parameters:
		FilePath (String) - File path of the image to load (supported: bmp, png, jpg, tga, dds, psd, hdr)
	'/
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
	
	/'
	Constructor: Texture
		Advanced constructor, can take some SOIL specific parameters (see SOIL doc for more details)
	
	Prototype:
		>Constructor Texture(ByVal FilePath As String, ByVal load_flags As Integer, ByVal texture_flag As Integer)
	
	Parameters:
		FilePath (String) - File path of the image to load (supported: bmp, png, jpg, tga, dds, psd, hdr)
		load_flags (Integer) - Combination of the followings:
		
			- *SOIL_LOAD_AUTO* leaves the image in whatever format it was found.
			- *SOIL_LOAD_L* forces the image to load as Luminous (greyscale)
			- *SOIL_LOAD_LA* forces the image to load as Luminous with Alpha
			- *SOIL_LOAD_RGB* forces the image to load as Red Green Blue
			- *SOIL_LOAD_RGBA* forces the image to load as Red Green Blue Alpha
		
		texture_flag (Integer) - Combination of the followings:
		
			- *SOIL_FLAG_POWER_OF_TWO* force the image to be POT
			- *SOIL_FLAG_MIPMAPS* generate mipmaps for the texture
			- *SOIL_FLAG_TEXTURE_REPEATS* otherwise will clamp
			- *SOIL_FLAG_MULTIPLY_ALPHA* for using (GL_ONE,GL_ONE_MINUS_SRC_ALPHA) blending
			- *SOIL_FLAG_INVERT_Y* flip the image vertically
			- *SOIL_FLAG_COMPRESS_TO_DXT* if the card can display them, will convert RGB to DXT1, RGBA to DXT5
			- *SOIL_FLAG_DDS_LOAD_DIRECT* will load DDS files directly without _ANY_ additional processing
			- *SOIL_FLAG_NTSC_SAFE_RGB* clamps RGB components to the range [16,235]
			- *SOIL_FLAG_CoCg_Y* Google YCoCg; RGB=>CoYCg, RGBA=>CoCgAY
			- *SOIL_FLAG_TEXTURE_RECTANGE* uses ARB_texture_rectangle ; pixel indexed & no repeat or MIPmaps or cubemaps
	'/
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
	
	' Destructor (glDeleteTextures)
	Destructor Texture()
		Print "Destroy Texture"
		glDeleteTextures(1, @This.glTexture)
	End Destructor
	
	/'
	Method: Activate
		Bind the texture
	
	Prototype:
		>Sub Texture.Activate()
	'/
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
