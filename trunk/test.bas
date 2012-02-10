#Include "glengin.bi"
#Include "chipmunk/easychipmunk.bi"

Using GLE

Dim main As Display = Display(800, 600, FALSE, "Test", 0, 0, 0)
'''

Dim physics As easyChipmunk = easyChipmunk()
physics.Lock()
	physics.space->damping = 0.8
	'''
	Dim Shared As cpBody Ptr body
	body = cpBodyNew(100, cpMomentForCircle(100, 32, 32, cpvzero))
	body->p = cpv(400, 300)
	Dim shape As cpShape Ptr = cpCircleShapeNew(body, 32, cpvzero)
	shape->e = 0.5
	shape->u = 0.8
	'''
	cpSpaceAddBody(physics.space, body)
	cpSpaceAddShape(physics.space, shape)
physics.Unlock()

''================
Declare Sub _KeyCallback(ByVal key As Integer, ByVal action As Integer)
glfwSetKeyCallback(@_KeyCallback)

Do
	main.Draw_Begin()
		Draw_Ellipse(v2d(body->p.x, body->p.y), 32, 32, GLE_RGBA(255,255,255,255))
	main.Draw_End()
Loop Until _RUNING_ = FALSE Or glfwGetKey(GLFW_KEY_ESC) = GLFW_PRESS

glfwSetKeyCallback(0)

Sub _KeyCallback(ByVal key As Integer, ByVal action As Integer)
	Select Case action
		Case GLFW_PRESS
			Select Case key
				Case 
					
				Case 
					
				Case 
					
				Case 
					
			End Select
		Case GLFW_RELEASE
			cpBodyResetForces(body)
	End Select
End Sub
