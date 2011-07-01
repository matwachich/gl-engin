#Define TRUE 1
#Define FALSE 0

#Define _PI 3.14159265358979323846
#Define v2d0 v2d(0,0)

#Define _MAX_PARTICLES_ 1000 ' Per one emitter
#Define _MAX_FRAMES_ 30 ' Per one anim object

#define GLE_RGBA(r, g, b, a)	RGBA((b), (g), (r), (a))

#Include "gl/gl.bi"
#Include "gl/glu.bi"
#Include "gl/glext.bi"
#Include "gl/glfw.bi"
#Include "perso/soil.bi"
	
Namespace GLE
	
	''===================================
	'' Enums and data types
	''===================================
	Type BOOL As UByte
	
	Enum E_BLEND_MODE
		BM_TRANS = 0
		BM_SOLID
		BM_BLENDED
		BM_GLOW
		BM_BLACK
	End Enum
	
	Enum E_ORIGIN
		O_MID = 0
		O_UL
		O_UR
		O_BL
		O_BR
	End Enum
	
	''===================================
	'' Globals
	''===================================
	Dim Shared As GLuint __Current_Texture = 0
	Dim Shared As E_BLEND_MODE __Current_BlendMode = 0
	
	''===================================
	'' Internal UDT
	''===================================
	Type v2d
		Declare Constructor()
		Declare Constructor(ByVal x As Single, ByVal y As Single)
		Declare Sub FromAngle(ByVal degrees As Single, ByVal lenght As Single)
		Declare Function ToVectAngle(ByRef vect As v2d) As Single
		Declare Function ToVectDist(ByRef vect As v2d) As Single
		Declare Function Grandeur() As Single
		Declare Function Angle() As Single
		Declare Operator Cast() As String
		
		As Single x, y
	End Type
	
	Type Rect
		Declare Constructor()
		Declare Constructor(ByVal x As Single, ByVal y As Single, ByVal w As Single, ByVal h As Single)
		Declare Operator Cast() As String
		As Single x, y, w, h
	End Type
	
	Type T_Color
		Declare Constructor()
		Declare Sub set(ByVal r As UByte, ByVal g As UByte, ByVal b As UByte, ByVal a As UByte)
		Declare Sub setVar(ByVal r As UShort, ByVal g As UShort, ByVal b As UShort, ByVal a As UShort)
		Declare Function Get(ByVal who As UByte) As UByte
		
		Private:
		As UByte r, g, b, a
		As Short rVar, gVar, bVar, aVar

	End Type
	
	''===================================
	'' Main UDT
	''===================================
	Declare Sub __OnWindowClose()
	
	Type Display
		' Screen Width, Screen Height
		' FullScreen Mode (True/False), Window Title (If Window mode)
		' Vertical Sync (Tru/False)
		' DepthBits (0 - No depth buffer), StencilBits (0 - No Stencil buffer)
		Declare Constructor(ByVal scrW As Short, ByVal scrH As Short, _
							ByVal fullScreen As BOOL, ByVal winTitle As String, _
							ByVal v_sync As BOOL, _
							ByVal DepthBits As UShort, ByVal StencilBits As UShort, _
							ByVal ExitOnWinClose As BOOL)
							
		' Destructor
		Declare Destructor()
		''===================================================================================================
		
		' Clears the buffers to start draws
		Declare Sub Draw_Begin()
		' Flip the buffers, displays what has been drawn
		Declare Sub Draw_End()
		
		' Set the background color
		Declare Sub SetBKColor(ByVal r As UByte, ByVal v As UByte, ByVal b As UByte, ByVal a As UByte)
		''===================================================================================================
		
		' Get a Random position (v2d) within the window
		Declare Function RndPos(ByVal min_x As Short, ByVal max_x As Short, ByVal min_y As Short, ByVal max_y As Short) As v2d
		''===================================================================================================
		
		' Take a ScreenShot
		Declare Sub ScreenShot(ByVal FileName As String)
		Declare Sub ScreenShot(ByVal FileName As String, ByVal Region As Rect)
		
		' Get FPS
		Declare Function GetFPS() As Short
		
		' Set window title
		Declare Sub SetCaption(ByVal caption As String)
		
		''===================================================================================================
		'' Internals
		''===================================================================================================

		Declare Sub _InitOpenGL(ByVal scrW As UShort, ByVal scrH As UShort)
		Declare Sub _CenterWindow()
		
		As UShort scrW, scrH
		As UByte Bpp
		As BOOL FullScreen
		As String WinTitle
		As BOOL v_sync
		As UShort DepthBits, StencilBits
		
		As Double FPS_Timer = 0
		
	End Type
	
	''===================================
	'' Texture object
	''===================================
	
	Type Texture
		Declare Constructor()
		' Simply load a Texture
		Declare Constructor(ByVal FilePath As String)
		' Load a Texture, advanced (SOIL Flags)
		Declare Constructor(ByVal FilePath As String, ByVal load_flags As Integer, ByVal texture_flag As Integer)
		' Binds the texture
		Declare Sub Activate()
		' Cast operator ( to be able to write: glBindTexture(GL_TEXTURE_2D, Texture) )
		Declare Operator Cast() As GLuint
		'''
		As GLuint glTexture
		As Short w, h
	End Type
	
	''===================================
	'' Internals
	''===================================
	Dim As Texture __GLOW_Texture

	''===================================
	'' Sprite and animation
	''===================================
	
	'' === Internal ===
	Type Anim_Frame
		Declare Constructor(ByVal tex As Texture Ptr, ByVal duration As Single, ByVal texRect As Rect, ByVal _color As UInteger)
		Declare Sub __ApplyFrame(ByVal spr As Any Ptr) ' Must be a Sprite Ptr
		'''
		As Texture Ptr tex = 0
		As Rect texRect = Rect(0,0,0,0)
		As Single duration = 0.2 ' 200 ms
		As GLuint _color = GLE_RGBA(255,255,255,255)
	End Type
	'' === End ===
	
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
	
	''=======================================================================================================
	
	Type Sprite
		' Default Constructor
		Declare Constructor()
		' Constructor
		Declare Constructor(ByVal tex As Texture Ptr)
		''===================================================================================================
		
		' Property angle
		Declare Property Angle() As Single
		Declare Property Angle(ByVal value As Single)
		''===================================================================================================
		
		' Drawing method
		Declare Sub Draw()
		' Draw and Animate
		Declare Sub Draw(ByVal anim As Animation Ptr)
		' Draw and animate, and return FALSE when stop_frame is reached
		Declare Function Draw(ByVal anim As Animation Ptr, ByVal stop_frame As Short) As BOOL
		
		' Change texture (Without changing the current sprite size)
		Declare Sub SetTexture(ByVal tex As Texture Ptr)
		' Change texture with or without changing the current sprite size
		Declare Sub SetTexture(ByVal tex As Texture Ptr, ByVal changeSize As BOOL)
		' Change texture without changing the current sprite size, and specifying a Texture Rect
		Declare Sub SetTexture(ByVal tex As Texture Ptr, ByVal _rect_ As Rect)
		' Change texture with or without changing the current sprite size, and specifying a Texture Rect
		Declare Sub SetTexture(ByVal tex As Texture Ptr, ByVal _rect_ As Rect, ByVal changeSize As BOOL)
		
		' Set Texture Rect
		Declare Sub SetTextureRect(ByVal _rect_ As Rect)
		''===================================================================================================
		
		' Set Origin
		Declare Sub SetOrigin(ByVal flag As E_ORIGIN)
		''===================================================================================================
		
		' Get Fixed Point
		Declare Function GetPoint(ByVal _point As v2d) As v2d
		Declare Function GetPoint(ByVal ratioX As Single, ByVal ratioY As Single) As v2d
		''===================================================================================================
		
		' Geometry Functions
		Declare Function ToPoint_Dist(ByVal _point As v2d) As Single
		Declare Function ToPoint_Angle(ByVal _point As v2d) As Single
		Declare Function ToPoint_Vect(ByVal _point As v2d) As v2d
		Declare Function ToPoint_Vect(ByVal _point As v2d, ByVal lenght As Single) As v2d
		
		Declare Function ToSprite_Dist(ByRef sprite As Sprite) As Single
		Declare Function ToSprite_Angle(ByRef sprite As Sprite) As Single
		Declare Function ToSprite_Vect(ByRef sprite As Sprite) As v2d
		Declare Function ToSprite_Vect(ByRef sprite As Sprite, ByVal lenght As Single) As v2d
		
		' Animation Function
		' Makes the next animation that will be applied to This start from the begining
		Declare Sub AnimRewind(ByVal frame As UShort)
		
		' Animates a sprite, with (optional) stop_frame, that if it is reached, the function returns FALSE
		Declare Function Animate(ByVal anim As Animation Ptr) As BOOL
		Declare Function Animate(ByVal anim As Animation Ptr, ByVal stop_frame As Short) As BOOL
		
		''===================================================================================================
		As v2d Position = v2d0, Size = v2d0, Origin = v2d0
		As Single PRIVATE_Angle = 0
		As Rect texRect = Rect(0,0,1,1)
		As GLuint Color = GLE_RGBA(255,255,255,255)
		As E_BLEND_MODE blendMode = BM_TRANS
		As Texture Ptr tex = 0
		'''
		As Short Anim_Frame = 1
		As Double Anim_Timer = -1
		As Double Anim_CurrFramDuration = 0
	End Type
	
	''===================================
	'' Dynamique Obj. (Sprite Extension)
	''===================================
	
	Type Dynamique
		Declare Constructor(ByVal spr As Sprite Ptr)
		Declare Sub Draw()
		Declare Sub Draw(ByVal _static As BOOL)
		
		As v2d Position = v2d0, Vel = v2d0, Accel = v2d0
		As Single VelMax = 0
		
		Declare Property Angle() As Single
		Declare Property Angle(ByVal value As Single)
		As Single AngleVel = 0, AngleVelMax = 0, AngleAccel = 0
		
		As Single Innertie = 0, AngleInnertie = 0
		
		As Sprite Ptr spr = 0
		
		Private:
		Declare Sub __Move()
		As Single PRIVATE_Angle = 0
		As Double move_timer = 0
	End Type
	
	''===================================
	'' Particles Engin UDT
	''===================================
	Type Particle ' Internal use only
		Declare Constructor()
		Declare Sub Draw()
		
		As v2d position = v2d0
		As v2d vel = v2d0
		As v2d accel = v2d0
		As v2d force = v2d0
		
		As Single Size = 1, SizeVar = 0
		As Single Spin = 0, SpinVar = 0
		
		As Double life_time = 1
		
		As Short start_R = 255, start_G = 255, start_B = 255, start_A = 255
		As Short var_R = 0, var_G = 0, var_B = 0, var_A = 0
		
		As Rect texRect
		
		As BOOL kill_me = FALSE
		
		Private:
		As Double timer_draw, timer_life
		As UInteger _color
		As Single Angle = 0
		
	End Type
	
	Type Particle_Emitter
		Declare Constructor()
		Declare Constructor(ByVal tex As Texture Ptr)
		Declare Constructor(ByVal tex As Texture Ptr, ByVal texRect As Rect)
		
		Declare Sub SetTextureRect(ByVal texRect As Rect)
		Declare Sub Spawn()
		Declare Sub Spawn(ByVal nbr As UShort)
		Declare Sub Draw()
		
		As Texture Ptr tex = 0
		
		As v2d Position = v2d0, PositionVar = v2d0
		
		As Single vel = 0, accel = 0
		As Single velVar = 0, accelVar = 0
		As Single angle = 180, angleVar = 180
		
		As Single force = 0, forceVar = 0
		As Single force_angle = 0, force_angleVar = 0
		
		As Single spin = 0, spinVar = 0, spinFlyVar = 0
		
		As Single life_time = 1, life_timeVar = 0
		As Single size = 8, sizeVar = 0
		As Single sizeFlyVar = 0
		
		As Single emitte_delay = 0.01 ' 10ms
		As Single particlesPerEmitte = 1
		
		As UShort max_particles = 200
		
		As T_Color clr = T_Color()
		As Short flyVar_R = 0, flyVar_G = 0, flyVar_B = 0, flyVar_A = 0
		As E_BLEND_MODE blendMode = BM_TRANS
		
		As BOOL actif = FALSE
		
		'Private:
		As Short _nbr_particles = 0
		As Particle Ptr array(0 To _MAX_PARTICLES_)
		
		Declare Sub __AddParticle()
		Declare Function __GetArrayFreeSlot() As Short
		Declare Function __GetAngle() As Single
		Declare Function __SpecialRandom_Int(ByVal value As Short, ByVal variation As Short) As Short
		Declare Function __SpecialRandom_Float(ByVal value As Single, ByVal variation As Single) As Single
		
		As Double emitte_timer = 0
		
		As Rect texRect
		
	End Type
	
	''===================================
	'' Draw Functions
	''===================================
	Declare Sub Draw_Point(ByVal position As v2d, ByVal _Color As UInteger, ByVal size As Integer = 1)
	Declare Sub Draw_PointGlow(ByVal position As v2d, ByVal _Color As UInteger, ByVal size As Integer = 8)
	Declare Sub Draw_Line(ByVal start As v2d, ByVal _end As v2d, ByVal _Color As UInteger, ByVal size As Integer = 1, ByVal smooth_edges As Integer = 1)
	Declare Sub Draw_LineGlow(ByVal start As v2d, ByVal _end As v2d, ByVal _Color As UInteger, ByVal lwidth as UShort = 1)
	Declare Sub Draw_Rect(ByVal _rect As Rect, ByVal _Color As UInteger, ByVal angle As Integer = 0, ByVal line_size As Integer = 1, ByVal smooth_edges As Integer = 1)	
	Declare Sub Draw_RectGlow(ByVal _rect As Rect, ByVal _Color As UInteger, ByVal angle As Integer = 0, ByVal line_size As Integer = 1)', ByVal smooth_edges As Integer = 1)
	Declare Sub Draw_RectFill(ByVal _rect As Rect, ByVal _Color As UInteger, ByVal angle As Integer = 0)
	Declare Sub Draw_RectCenter(ByVal center As v2d, ByVal size As v2d, ByVal _Color As UInteger, ByVal angle As Integer = 0, ByVal line_size As Integer = 1, ByVal smooth_edges As Integer = 1)
	Declare Sub Draw_RectCenterGlow(ByVal center As v2d, ByVal size As v2d, ByVal _Color As UInteger, ByVal angle As Integer = 0, ByVal line_size As Integer = 1)', ByVal smooth_edges As Integer = 1)
	Declare Sub Draw_RectCenterFill(ByVal center As v2d, ByVal size As v2d, ByVal _Color As UInteger, ByVal angle As Integer = 0)
	Declare Sub Draw_Ellipse(ByVal center As v2d, ByVal radiusX As Integer, ByVal radiusY As Integer, ByVal _Color As UInteger, ByVal angle As Integer = 0, ByVal line_size As Integer = 1, ByVal precision As Integer = 5)
	Declare Sub Draw_EllipseGlow(ByVal center As v2d, ByVal radiusX As Integer, ByVal radiusY As Integer, ByVal _Color As UInteger, ByVal angle As Integer = 0, ByVal line_size As Integer = 1, ByVal precision As Integer = 5)
	Declare Sub Draw_EllipseFill(ByVal center As v2d, ByVal radiusX As Integer, ByVal radiusY As Integer, ByVal _Color As UInteger, ByVal angle As Integer = 0, ByVal precision As Integer = 5)
	Declare Sub Draw_Triangle(ByVal p1 As v2d, ByVal p2 As v2d, ByVal p3 As v2d, ByVal _Color As UInteger, ByVal line_size As UShort = 1, ByVal smooth_edges As UByte = 1)
	Declare Sub Draw_TriangleGlow(ByVal p1 As v2d, ByVal p2 As v2d, ByVal p3 As v2d, ByVal _Color As UInteger, ByVal line_size As UShort = 1)', ByVal smooth_edges As UByte = 1)
	Declare Sub Draw_TriangleFill(ByVal p1 As v2d, ByVal p2 As v2d, ByVal p3 As v2d, ByVal _Color As UInteger)
	Declare Sub Draw_BlendMode(ByVal mode As E_BLEND_MODE = BM_TRANS)
	
End Namespace

#Include "src/misc.bi"
#Include "src/rect.bi"
#Include "src/vect2d.bi"
#Include "src/Color.bi"
#Include "src/system.bi"
#Include "src/texture.bi"
#Include "src/sprite.bi"
#Include "src/Dynamique.bi"
#Include "src/draw.bi"
#Include "src/animation.bi"
#Include "src/Particle.bi"