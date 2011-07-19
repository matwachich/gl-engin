
''===================================
'' UDT: Display
''===================================

Namespace GLE
	
	Constructor Display()
	End Constructor
	
	' Screen Width, Screen Height
	' FullScreen Mode (True/False), Window Title (If Window mode)
	' Vertical Sync (Tru/False)
	' DepthBits (0 - No depth buffer), StencilBits (0 - No Stencil buffer)
	Constructor Display(ByVal scrW As Short, ByVal scrH As Short, _
						ByVal fullScreen As BOOL, ByVal winTitle As String, _
						ByVal v_sync As BOOL, _
						ByVal DepthBits As UShort, ByVal StencilBits As UShort)
		Randomize Timer
		'''
		glfwInit()
		'''
		Dim As Integer flag = GLFW_WINDOW
		If FullScreen = TRUE Then flag = GLFW_FULLSCREEN
		'''
		glfwOpenWindowHint(GLFW_WINDOW_NO_RESIZE, TRUE)
		
		' I thought i need it for GL_POINT_SPRITE but finally, i don't use them.
		'glfwOpenWindowHint(GLFW_OPENGL_VERSION_MAJOR, 2)
		'glfwOpenWindowHint(GLFW_OPENGL_VERSION_MINOR, 0)
		'''
		glfwOpenWindow(scrW, scrH, 8, 8, 8, 8, DepthBits, StencilBits, flag)
		This._CenterWindow()
		glfwSetWindowTitle(WinTitle)
		'''
		If v_sync = TRUE Then glfwSwapInterval(1)
		'''
		glfwSetWindowCloseCallback(Cast(GLFWWindowCloseFun, @__OnWindowClose))
		'''
		This._InitOpenGL(scrW, scrH)
		'''
		This.scrW = scrW
		This.scrH = scrH
		This.Bpp = 32
		This.FullScreen = fullScreen
		This.WinTitle = winTitle
		This.v_sync = v_sync
		This.DepthBits = DepthBits
		This.StencilBits = StencilBits
		'''
		__GLOW_Texture = Texture("glow.png")
		'__GLOW_Texture.Activate()
    	'glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP)
    	'glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP)
	End Constructor
	
	' Destructor
	Destructor Display()
		'''
		glfwCloseWindow()
		glfwTerminate()
		'''
	End Destructor
	''===================================================================================================
	
	' Clears the buffers to start draws
	Sub Display.Draw_Begin()
		glClear(GL_COLOR_BUFFER_BIT)
	End Sub
	' Flip the buffers, displays what has been drawn
	Sub Display.Draw_End()
		glfwSwapBuffers()
	End Sub
	
	
	' Set the background color
	Sub Display.SetBKColor(ByVal r As UByte, ByVal v As UByte, ByVal b As UByte, ByVal a As UByte)
		glClearColor(r/255, v/255, b/255, a/255)
	End Sub
	''===================================================================================================

	
	' Get a Random position (v2d) within the window
	Function Display.RandomPosition(ByVal min_x As Short, ByVal max_x As Short, ByVal min_y As Short, ByVal max_y As Short) As v2d
		If max_x = 0 Then
			max_x = This.scrW
		ElseIf max_x < 0 Then
			max_x = This.scrW + max_x
		EndIf
		If max_y = 0 Then
			max_y = This.scrH
		ElseIf max_y < 0 Then
			max_y = This.scrH + max_y
		EndIf
		Dim ret As v2d
		ret.x = Random_Int(min_x, max_x)
		ret.y = Random_Int(min_y, max_y)
		Return ret
	End Function
	''===================================================================================================
	
	'
	Sub Display.SetViewPoint(ByVal view_point As v2d)
		glTranslated(-1 * (view_point.x - This.view_point.x), -1 * (view_point.y - This.view_point.y), 0)
		This.view_point = view_point
	End Sub
	
	'
	Function Display.ScreenPosition(ByVal position As v2d) As v2d
		Return v2d(position.x + This.view_point.x, position.y + This.view_point.y)
	End Function
	Function Display.ScreenPosition(ByVal position As Rect) As Rect
		Return Rect(position.x + This.view_point.x, position.y + This.view_point.y, position.w, position.h)
	End Function
	''===================================================================================================
	
	' Take a ScreenShot
	Sub Display.ScreenShot(ByVal FileName As String)
		Dim As String ext = Right(FileName, 4)
		Dim SaveType As Integer
		Select Case ext
			Case ".bmp"
				SaveType = SOIL_SAVE_TYPE_BMP
			Case ".tga"
				SaveType = SOIL_SAVE_TYPE_TGA
			Case ".dds"
				SaveType = SOIL_SAVE_TYPE_DDS
			Case Else
				SaveType = SOIL_SAVE_TYPE_BMP
		End Select
		SOIL_save_screenshot(FileName, SaveType, 0, 0, This.ScrW, This.ScrH)
	End Sub
	
	Sub Display.ScreenShot(ByVal FileName As String, ByVal Region As Rect)
		Dim As String ext = Right(FileName, 4)
		Dim SaveType As Integer
		Select Case ext
			Case ".bmp"
				SaveType = SOIL_SAVE_TYPE_BMP
			Case ".tga"
				SaveType = SOIL_SAVE_TYPE_TGA
			Case ".dds"
				SaveType = SOIL_SAVE_TYPE_DDS
			Case Else
				SaveType = SOIL_SAVE_TYPE_BMP
		End Select
		SOIL_save_screenshot(FileName, SaveType, Region.x, Region.y, Region.w, Region.h)
	End Sub
	
	' Get FPS
	Function Display.GetFPS() As Short
		If This.FPS_Timer = 0 Then
			This.FPS_Timer = TimerInit()
			Return 0
		Else
			Function = (1 / TimerDiff(This.FPS_Timer))
			This.FPS_Timer = TimerInit()
		EndIf
	End Function
	
	' Set window title
	Sub Display.SetCaption(ByVal caption As String)
		glfwSetWindowTitle(caption)
		This.WinTitle = caption
	End Sub
	
	''===================================================================================================
	'' Internals
	''===================================================================================================
	
	Sub Display._InitOpenGL(ByVal scrW As UShort, ByVal scrH As UShort)
		'screen information 
		dim w as integer, h as integer 
		'OpenGL params for gluerspective 
		dim FOVy as double            'Field of view angle in Y 
		dim Aspect as double          'Aspect of screen 
		dim znear as double           'z-near clip distance 
		dim zfar as double            'z-far clip distance 
	
		'using screen info w and h as params 
		glViewport(0, 0, scrW, scrH)
		
		' Pour les coordonnées de textures
		'glMatrixMode(GL_TEXTURE)
		'glLoadIdentity()
		'glScalef(-1, -1, 1)
		'glRotated(180, 0, 0, 1)
		
		'Set current Mode to projection(ie: 3d) 
		'glMatrixMode(GL_PROJECTION)
		
		'Load identity matrix to projection matrix 
		'glLoadIdentity() 
	
		'Set gluPerspective params 
		FOVy = 90/2                                     '45 deg fovy 
		Aspect = scrW / scrH
		znear = 1                                       'Near clip 
		zfar = 500                                      'far clip 
		
		'use glu Perspective to set our 3d frustum dimension up 
		gluPerspective(FOVy * 0.5, aspect, znear, zfar) 
		
		'Modelview mode 
		'ie. Matrix that does things to anything we draw 
		'as in lines, points, tris, etc. 
		'glMatrixMode(GL_MODELVIEW) 
		'load identity(clean) matrix to modelview 
		'glLoadIdentity() 
		
		glShadeModel(GL_SMOOTH)                 'set shading to smooth(try GL_FLAT) 
		glClearColor(0.0, 0.0, 0.0, 1.0)        'set Clear color to BLACK 
		glClearDepth(1.0)                       'Set Depth buffer to 1(z-Buffer) 
		glDisable(GL_DEPTH_TEST)                'Disable Depth Testing so that our z-buffer works 
		
		'compare each incoming pixel z value with the z value present in the depth buffer 
		'LEQUAL means than pixel is drawn if the incoming z value is less than 
		'or equal to the stored z value 
		glDepthFunc(GL_LEQUAL) 
		
		'have one or more material parameters track the current color 
		'Material is your 3d model 
		glEnable(GL_COLOR_MATERIAL) 
	
	    'Enable Texturing 
	    glEnable(GL_TEXTURE_2D) 
	
	   	'Tell openGL that we want the best possible perspective transform 
		glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST) 
	
		'Disable Backface culling
		glDisable (GL_CULL_FACE)
	
		glPolygonMode(GL_FRONT, GL_FILL) 
	
		'' enable blending for transparency 
		glEnable(GL_BLEND)    	    
		glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
		
		' Enable Point Sprite, for particles
		glTexEnvf(GL_POINT_SPRITE, GL_COORD_REPLACE, GL_TRUE)
		glEnable(GL_POINT_SPRITE)
		
		glEnable(GL_ALPHA_TEST)
		glAlphaFunc(GL_GREATER, 0)
	
		'glDisable(GL_STENCIL_TEST)
		glDisable(GL_TEXTURE_1D)
		glDisable(GL_LIGHTING)
		glDisable(GL_LOGIC_OP)
		glDisable(GL_DITHER)
		glDisable(GL_FOG)
	
		glEnable(GL_POINT_SMOOTH)
		glEnable(GL_LINE_SMOOTH)
		
		glHint(GL_POINT_SMOOTH_HINT, GL_NICEST)
		glHint(GL_LINE_SMOOTH_HINT , GL_NICEST)
	
		glPointSize(1)
		glLineWidth(1)
	
		glMatrixMode(GL_PROJECTION)
	    glPushMatrix()
	    glLoadIdentity()
	    glOrtho(0, scrW, scrH, 0, -1, 1)
	
	    glMatrixMode(GL_MODELVIEW)
	    glPushMatrix()
	    glLoadIdentity()
	    'glTranslatef(0.375, 0.375, 0)	'' magic trick
	End Sub
	
	Sub Display._CenterWindow()
		Dim _ptr_ As GLFWvidmode Ptr = New GLFWvidmode
		Dim x As Integer Ptr = New Integer
		Dim y As Integer Ptr = New Integer
		glfwGetDesktopMode(_ptr_)
		glfwGetWindowSize(x, y)
		*x = (_ptr_->Width / 2) - (*x / 2)
		*y = (_ptr_->Height / 2) - (*y / 2)
		glfwSetWindowPos(*x, *y)
		Delete x
		Delete y
		Delete _ptr_
	End Sub
	
	''===================================================================================================
	'' Externals
	''===================================================================================================
	Sub __OnWindowClose()
		_Runing_ = FALSE 
	End Sub
	
End Namespace


