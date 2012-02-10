
'File: System

Namespace GLE
	
	/'
	Class: Display
		Main program object, creating an instance of it will create a render window.
		
		Contains common functions.
	
	Property: scrW, scrH (UShort)
		Contains current screen Width and Height
	
	Property: FullScreen (BOOL)
		*True* if runing in full screen mode, *False* otherwise
	
	Property: WinTitle (String)
		Contains the window title
	
	Property: v_sync (BOOL)
		*True* if vertical synchronisation is activated, *False* otherwise
	
	Property: DepthBits (UShort)
		Contains number of Depth buffer bits
	
	Property: StencilBits (UShort)
		Contains number of Stencil buffer bits
	
	Property: view_rect (Rect)
		Contains the actual viewable rectangle on the screen.
		
		for example, when you just launched your app, and never called yet <Display.CenterAndZoom>, then
		view_rect = Rect(0, 0, <Display.scrW>, <Display.scrH>)
	
	Property: zoom (Single)
		Contains the current zoom factor. A value of 1 means no zoom.
	'/
	
	Constructor Display()
	End Constructor
	
	/'
	Constructor: Display
		Main constructor
	
	Prototype:
		>Display(ByVal scrW As Short, ByVal scrH As Short, _
		>			ByVal fullScreen As BOOL, ByVal winTitle As String, _
		>			ByVal v_sync As BOOL, _
		>			ByVal DepthBits As UShort, ByVal StencilBits As UShort)
	
	Parameters:
		scrW (Short) - Window/screen width
		scrH (Short) - Window/screen height
		fullScreen (BOOL) - Toggles full screen mode (True/False)
		winTitle (String) - Window title (caption)
		v_sync (BOOL) - Toggles vertical synchronisation
		DepthBits (UShort) - Depth buffer bits (0 - no depth buffer)
		StencilBits (UShort) - Stencil buffer bits (0 - No Stencil buffer)
	'/
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
		__GLOW_Texture = New Texture("glow.png")
		'__GLOW_Texture.Activate()
    	'glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP)
    	'glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP)
	End Constructor

	Destructor Display()
		'''
		Delete __GLOW_Texture
		glfwCloseWindow()
		glfwTerminate()
		'''
	End Destructor
	''===================================================================================================
	
	/'
	Method: Draw_Begin
		Clears the buffers to start draws
	
	Prototype:
		>Sub Display.Draw_Begin()
	'/
	Sub Display.Draw_Begin()
		glClear(GL_COLOR_BUFFER_BIT)
	End Sub
	
	/'
	Method: Draw_End
		Flip the buffers, and displays what has been drawn
	
	Prototype:
		>Sub Display.Draw_End()
	'/
	Sub Display.Draw_End()
		glfwSwapBuffers()
	End Sub
	
	/'
	Method: SetBKColor
		Set the background color, that will fill the screen after <Display.Draw_Begin>
	
	Prototype:
		>Sub Display.SetBKColor(ByVal r As UByte, ByVal v As UByte, ByVal b As UByte, ByVal a As UByte)
	
	Parameters:
		r (UByte) - Red (0 - 255)
		v (UByte) - Green (0 - 255)
		b (UByte) - Blue (0 - 255)
		a (UByte) - Alpha (0 - 255)
	'/
	Sub Display.SetBKColor(ByVal r As UByte, ByVal v As UByte, ByVal b As UByte, ByVal a As UByte)
		glClearColor(r/255, v/255, b/255, a/255)
	End Sub
	''===================================================================================================

	/'
	Method: RandomPosition
		Return a random position within the screen
	
	Prototype:
		>Function Display.RandomPosition(ByVal min_x As Short, ByVal max_x As Short, ByVal min_y As Short, ByVal max_y As Short) As v2d
	
	Parameters:
		min_x (Short) - Minimum x value
		max_x (Short) - Maximum x value
		min_y (Short) - Minimun y value
		max_y (Short) - Maximum y value
	
	Return:
		Position as <v2d>
	
	Remarks:
		If you have scrolled the view using <Display.CenterAndZoom>, or zoomed using <Display.SetZoom>, you must use <Display.ScreenToWorld> to get the position
		in you current view area
	'/
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
	'Sub Display.SetViewPoint(ByVal view_point As v2d)
		'glMatrixMode(GL_PROJECTION)
	'	view_point = view_point - v2d(This.scrW / (2 * This.zoom), This.scrH / (2 * This.zoom))
		'Print "view: " & view_point
	'	glTranslated(-1 * (view_point.x - This.view_point.x), -1 * (view_point.y - This.view_point.y), 0)
	'	This.view_point = view_point' + v2d(This.scrW / 2, This.scrH / 2)
		'glMatrixMode(GL_MODELVIEW)
	'End Sub
	
	'Sub Display.SetZoom(ByVal zoom As Single)
	'	Dim scale As Single = zoom / This.zoom
		'glLoadIdentity()
	'	glTranslated(This.view_point.x, This.view_point.y, 0)
	'	glScalef(scale, scale, 1)
	'	glTranslated(-(This.view_point.x), -(This.view_point.y), 0)
	'	This.zoom = zoom
	'End Sub
	
	/'
	Method: SetZoom
		Zoom in/out on the current centered point in the screen
	
	Prototype:
		>Sub Display.SetZoom(ByVal zoom As Single)
	
	Parameters:
		zoom (Single) - Zoom factor
	'/
	Sub Display.SetZoom(ByVal zoom As Single)
		This.CenterAndZoom(This.GetViewCenter(), zoom)
	End Sub
	
	/'
	Method: CenterAndZoom
		Center the view on a point, and zoom.
	
	Prototype:
		>Sub Display.CenterAndZoom(ByVal position As v2d, ByVal zoom As Single)
	
	Parameters:
		position (v2d) - The position to center
		zoom (Single) - The zoom ratio (1 means no zoom)
	'/
	Sub Display.CenterAndZoom(ByVal position As v2d, ByVal zoom As Single)
		Dim LeftGL As Single = position.x - ((This.scrW / Zoom) / 2)
		Dim RightGL As Single = position.x + ((This.scrW / Zoom) / 2)
		Dim ButtomGL As Single = position.y + ((This.scrH / Zoom) / 2)
		Dim TopGL As Single = position.y - ((This.scrH / Zoom) / 2)	
		glMatrixMode 	(GL_PROJECTION)
		glLoadIdentity	()
		'Print "Center at: " & LeftGL; RightGL; ButtomGL; TopGL
		gluOrtho2D		(LeftGL, RightGL, ButtomGL, TopGL)
		glMatrixMode 	(GL_MODELVIEW)
		'''
		This.zoom = zoom
		'This.view_rect = position - v2d(This.scrW / (2 * zoom), This.scrH / (2 * zoom))
		This.view_rect = Rect(LeftGL, TopGL, RightGL - LeftGL, ButtomGL - TopGL)
	End Sub
	
	/'
	Method: GetViewCenter
		Return the currently centered point in the screen
	
	Prototype:
		>Function Display.GetViewCenter() As v2d
	
	Returns:
		Centered position as <v2d>
	'/
	Function Display.GetViewCenter() As v2d
		Return v2d(This.view_rect.x + (This.view_rect.w / 2), This.view_rect.y + (This.view_rect.h / 2))
	End Function
	
	/'
	Method: PointIsVisible
		Check if a given point is visible
	
	Prototype:
		>Function Display.PointIsVisible(ByVal _point As v2d) As BOOL
	
	Parameters:
		_point (v2d) - Point to check
	
	Returns:
		*True* if the point is visible, *False* otherwise
	'/
	Function Display.PointIsVisible(ByVal _point As v2d) As BOOL
		Return _point.IsInRect(This.view_rect)
	End Function
		
	/'
	Method: ScreenToWorld
		Converts a screen relative position to world relative position
	
	Prototype:
		>Function Display.ScreenToWorld(ByVal position As v2d) As v2d
		>Function Display.ScreenToWorld(ByVal position As Rect) As Rect
	
	Parameters:
		position (v2d or Rect) - Position or Rectangle to convert
	
	Returns:
		According to the parameter passed <v2d> or <Rect>
	'/
	Function Display.ScreenToWorld(ByVal position As v2d) As v2d
		Dim ret As v2d
		ret.x = This.View_Rect.x + (This.View_Rect.w * (position.x / This.scrW)) ' vive les maths!
		ret.y = This.View_Rect.y + (This.View_Rect.h * (position.y / This.scrH))
		Return ret
		'Return v2d(position.x + This.view_rect.x, position.y + This.view_rect.y)
	End Function
	Function Display.ScreenToWorld(ByVal position As Rect) As Rect
		Dim ret As Rect
		ret.x = This.View_Rect.x + (This.View_Rect.w * (position.x / This.scrW)) ' vive les maths!
		ret.y = This.View_Rect.y + (This.View_Rect.h * (position.y / This.scrH))
		ret.w = position.w
		ret.h = position.h
		Return ret
		'Return Rect(position.x + This.view_rect.x, position.y + This.view_rect.y, position.w, position.h)
	End Function
	
	/'
	Method: WorldToScreen
		Converts a world relative position to screen relative position
	
	Prototype:
		>Function Display.WorldToScreen(ByVal position As v2d) As v2d
		>Function Display.WorldToScreen(ByVal position As Rect) As Rect
	
	Parameters:
		position (v2d or Rect) - Position or Rectangle to convert
	
	Returns:
		According to the parameter passed <v2d> or <Rect>
	'/
	Function Display.WorldToScreen(ByVal position As v2d) As v2d
		Dim ret As v2d
		ret.x = (position.x - This.View_Rect.x) * (This.scrW / This.View_Rect.w) ' vive les maths!
		ret.y = (position.y - This.View_Rect.y) * (This.scrH / This.View_Rect.h)
		Return ret
	End Function
	Function Display.WorldToScreen(ByVal position As Rect) As Rect
		Dim ret As Rect
		ret.x = (position.x - This.View_Rect.x) * (This.scrW / This.View_Rect.w) ' vive les maths!
		ret.y = (position.y - This.View_Rect.y) * (This.scrH / This.View_Rect.h)
		ret.w = position.w
		ret.h = position.h
		Return ret
	End Function

	''===================================================================================================

	/'
	Method: ScreenShot
		Takes a screen shot
	
	Prototype:
		>Sub Display.ScreenShot(ByVal FileName As String)
		>Sub Display.ScreenShot(ByVal FileName As String, ByVal Region As Rect)
	
	Parameters:
		FileName (String) - The file name of the screen shot
		Region (Rect) - *Optional* the region of the screen to take as a screen shot
	'/
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
	
	/'
	Method: GetFPS
		Return the current FPS (Frames Per Second)
	
	Prototype:
		>Function Display.GetFPS() As Short
	
	Return:
		Value of the FPS as Short
	'/
	Function Display.GetFPS() As Short
		If This.FPS_Timer = 0 Then
			This.FPS_Timer = TimerInit()
			Return 0
		Else
			Function = (1 / TimerDiff(This.FPS_Timer))
			This.FPS_Timer = TimerInit()
		EndIf
	End Function
	
	/'
	Method: SetCaption
		Change the window title (caption)
	
	Prototype:
		>Sub Display.SetCaption(ByVal caption As String)
	
	Parameters:
		caption (String) - Window title
	'/
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
		
		glEnable(GL_SCISSOR_TEST)
		glScissor(0, 0, scrW, scrH)
		
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
	   ' glOrtho(0, scrW, scrH, 0, -1, 1)
	    gluOrtho2d(0, scrW, scrH, 0)
	
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


