
'File: Draw
'	Primitives drawing functions.

Namespace GLE
	
	Declare function get_glow_image() as GLuint
	
	/'
	Function: Draw_Point
		Draw a point.
	
	Protoype:
		>Sub Draw_Point(ByVal position As v2d, ByVal _Color As UInteger, ByVal size As Integer = 1)
	
	Parameters:
		position (v2d) - Position to draw to
		_Color (UInteger) - Color (use <GLE_RGBA>)
		size (Integer) - Size of the point
	'/
	Sub Draw_Point(ByVal position As v2d, ByVal _Color As UInteger, ByVal size As Integer = 1)
		glDisable(GL_TEXTURE_2D)
		
		glColor4ubv(cast(GLubyte ptr, @_Color))
		
		glPointSize(size)
		'glLineWidth(1)
		
		glBegin(GL_POINTS)
			glVertex2d(position.x, position.y)
		glEnd()
		
		glEnable(GL_TEXTURE_2D)
	End Sub
	
	/'
	Function: Draw_PointGlow
		Draw a glowy point
	
	Prototype:
		>Sub Draw_PointGlow(ByVal position As v2d, ByVal _Color As UInteger, ByVal size As Integer = 8)
	
	Parameters:
		position (v2d) - Position to draw to
		_Color (UInteger) - Color (use <GLE_RGBA>)
		size (Integer) - Size of the point
	'/
	Sub Draw_PointGlow(ByVal position As v2d, ByVal _Color As UInteger, ByVal size As Integer = 8)
		'glDisable(GL_TEXTURE_2D)
		
		__GLOW_Texture->Activate()
		glColor4ubv(cast(GLubyte ptr, @_Color))
		
		glPointSize(size)
		'glLineWidth(1)
		
		glBegin(GL_POINTS)
			glVertex2d(position.x, position.y)
		glEnd()
		
		'glEnable(GL_TEXTURE_2D)
	End Sub
	
	/'
	Function: Draw_Line
		Draw a line
	
	Prototype:
		>Sub Draw_Line(ByVal start As v2d, ByVal _end As v2d, ByVal _Color As UInteger, ByVal size As Integer = 1, ByVal smooth_edges As Integer = 1)
	
	Parameters:
		start (v2d) - Start point of the line
		_end (v2d) - End point of the line
		_Color (UInteger) - Color (use <GLE_RGBA>)
		size (Integer) - Width of the line (thickness)
		smooth_edges (BOOL) - Smooth the edges when size is bigger than 1
	'/
	Sub Draw_Line(ByVal start As v2d, ByVal _end As v2d, ByVal _Color As UInteger, ByVal size As Integer = 1, ByVal smooth_edges As BOOL = TRUE)
		glDisable(GL_TEXTURE_2D)
		
		glColor4ubv(cast(GLubyte ptr, @_Color))
		
		'glPointSize(1)
		glLineWidth(size)
		
		glBegin(GL_LINES)
			glVertex2d(start.x, start.y)
			glVertex2d(_end.x, _end.y)
		glEnd()
		
		If smooth_edges = TRUE And size > 1 Then
			glPointSize(size)
			glBegin(GL_POINTS)
				glVertex2d(start.x, start.y)
				glVertex2d(_end.x, _end.y)
			glEnd()
		EndIf
		
		glEnable(GL_TEXTURE_2D)
	End Sub
	
	/'
	Function: Draw_LineGlow
		Draw a glowy line
	
	Prototype:
		>Sub Draw_LineGlow(ByVal start As v2d, ByVal _end As v2d, ByVal _Color As UInteger, ByVal lwidth as UShort = 1)
	
	Parameters:
		start (v2d) - Start point of the line
		_end (v2d) - End point of the line
		_Color (UInteger) - Color (use <GLE_RGBA>)
		lwidth (Integer) - Width of the line (thickness)
	'/
	Sub Draw_LineGlow(ByVal start As v2d, ByVal _end As v2d, ByVal _Color As UInteger, ByVal lwidth as UShort = 1)

		__GLOW_Texture->Activate()
		
		Dim As Single nx,ny	
		nx = -(_end.y-start.y)
		ny =  (_end.x-start.x)
		
		Dim leng As Single
	    leng = sqr(nx * nx + ny * ny )
	    nx = nx / leng
	    ny = ny / leng
	
		nx *= lwidth/2
		ny *= lwidth/2
		 	
		Dim As single lx1, ly1, lx2, ly2, lx3, ly3, lx4, ly4
		
		lx1 = _end.x+nx
	    ly1 = _end.y+ny
	    lx2 = _end.x-nx
	    ly2 = _end.y-ny                            
	    lx3 = start.x-nx
	    ly3 = start.y-ny
	    lx4 = start.x+nx
	    ly4 = start.y+ny 
	
		glColor4ubv (cast(GLubyte ptr, @_Color))
	
		''MAIN
		glbegin(GL_QUADS)
			glTexCoord2f( 0.5,0 )
			glVertex3f( lx1,ly1,0 )
	
			glTexCoord2f( 0.5,1 )
			glVertex3f( lx2,ly2,0 )
	
			glTexCoord2f( 0.5,1 )
			glVertex3f( lx3, ly3,0 )
	
			glTexCoord2f( 0.5,0 )
			glVertex3f( lx4,ly4,0 )
		glend()
	
		'RIGHT
		dim as single lx5, ly5,lx6,ly6,vx,vy
		vx = (_end.x-start.x)
		vy = (_end.y-start.y)
		leng = sqr(vx * vx + vy * vy )
		vx = vx / leng
		vy = vy / leng
		vx *= lwidth/2
		vy *= lwidth/2
		
		lx5 = lx1 + vx
		ly5 = ly1 + vy
		lx6 = lx2 + vx
		ly6 = ly2 + vy
		
		glbegin(GL_QUADS)
			glTexCoord2f( 0.5,0 )
			glVertex3f( lx1,ly1,0 )
	
			glTexCoord2f( 1,0 )
			glVertex3f( lx5,ly5,0 )
	
			glTexCoord2f( 1,1 )
			glVertex3f( lx6, ly6,0 )
	
			glTexCoord2f( 0.5,1 )
			glVertex3f( lx2,ly2,0 )
		glend() 
	
		'LEFT
		lx5 = lx4 -vx
		ly5 = ly4 -vy
		lx6 = lx3 -vx
		ly6 = ly3 -vy
		glbegin(GL_QUADS)
			glTexCoord2f( 0.5,0 )
			glVertex3f( lx4,ly4,0 )
			
			glTexCoord2f( 0.5,1 )
			glVertex3f( lx3,ly3,0 )
	
			glTexCoord2f( 1,1 )
			glVertex3f( lx6, ly6,0 )
	
			glTexCoord2f( 1,0 )
			glVertex3f( lx5,ly5,0 )
			
		glend()
		
	end Sub
	
	/'
	Function: Draw_Rect
		Draw a rectangle
	
	Prototype:
		>Sub Draw_Rect(ByVal _rect As Rect, ByVal _Color As UInteger, ByVal angle As Integer = 0, ByVal line_size As Integer = 1, ByVal smooth_edges As Integer = 1)
	
	Parameters:
		
	'/
	Sub Draw_Rect(ByVal _rect As Rect, ByVal _Color As UInteger, ByVal angle As Integer = 0, ByVal line_size As Integer = 1, ByVal smooth_edges As Integer = 1)
		glDisable(GL_TEXTURE_2D)
		glPushMatrix()
		
		glTranslated(_rect.x, _rect.y, 0)
		glRotated(angle, 0, 0, 1)
		
		glColor4ubv(cast(GLubyte ptr, @_Color))
		
		glLineWidth(line_size)
		
		glBegin(GL_LINE_LOOP)
			glVertex2d(0, 0)
			glVertex2d(_rect.w, 0)
			glVertex2d(_rect.w, _rect.h)
			glVertex2d(0, _rect.h)
		glEnd()
		
		If smooth_edges > 0 And line_size > 1 Then
			glPointSize(line_size)
			glBegin(GL_POINTS)
				glVertex2d(0, 0)
				glVertex2d(_rect.w, 0)
				glVertex2d(_rect.w, _rect.h)
				glVertex2d(0, _rect.h)
			glEnd()
		EndIf
		
		glPopMatrix()
		glEnable(GL_TEXTURE_2D)
	End Sub
	
	/'
	Function: Draw_
		
	
	Prototype:
		>
	
	Parameters:
		
	'/
	Sub Draw_RectGlow(ByVal _rect As Rect, ByVal _Color As UInteger, ByVal angle As Integer = 0, ByVal line_size As Integer = 1)', ByVal smooth_edges As Integer = 1)
		glPushMatrix()
		
		glTranslated(_rect.x, _rect.y, 0)
		glRotated(angle, 0, 0, 1)
		
		'glColor4ubv(cast(GLubyte ptr, @_Color))
		
		'glBegin(GL_QUADS)
		'	glVertex2d(0, 0)
		'	glVertex2d(_rect.w, 0)
		'	glVertex2d(_rect.w, _rect.h)
		'	glVertex2d(0, _rect.h)
		'glEnd()
		
		Draw_LineGlow(v2d(0,0), v2d(_rect.w, 0), _Color, line_size)
		Draw_LineGlow(v2d(_rect.w, 0), v2d(_rect.w, _rect.h), _Color, line_size)
		Draw_LineGlow(v2d(_rect.w, _rect.h), v2d(0, _rect.h), _Color, line_size)
		Draw_LineGlow(v2d(0, _rect.h), v2d(0,0), _Color, line_size)
		
		glPopMatrix()
	End Sub	
	
	/'
	Function: Draw_
		
	
	Prototype:
		>
	
	Parameters:
		
	'/
	Sub Draw_RectFill(ByVal _rect As Rect, ByVal _Color As UInteger, ByVal angle As Integer = 0)
		glDisable(GL_TEXTURE_2D)
		glPushMatrix()
		
		glTranslated(_rect.x, _rect.y, 0)
		glRotated(angle, 0, 0, 1)
		
		glColor4ubv(cast(GLubyte ptr, @_Color))
		
		glBegin(GL_QUADS)
			glVertex2d(0, 0)
			glVertex2d(_rect.w, 0)
			glVertex2d(_rect.w, _rect.h)
			glVertex2d(0, _rect.h)
		glEnd()
		
		glPopMatrix()
		glEnable(GL_TEXTURE_2D)
	End Sub
	
	/'
	Function: Draw_
		
	
	Prototype:
		>
	
	Parameters:
		
	'/
	Sub Draw_RectCenter(ByVal center As v2d, ByVal size As v2d, ByVal _Color As UInteger, ByVal angle As Integer = 0, ByVal line_size As Integer = 1, ByVal smooth_edges As Integer = 1)
		glDisable(GL_TEXTURE_2D)
		glPushMatrix()
		
		glTranslated(center.x, center.y, 0)
		glRotated(angle, 0, 0, 1)
		
		glColor4ubv(cast(GLubyte ptr, @_Color))
		
		glLineWidth(line_size)
		
		glBegin(GL_LINE_LOOP)
			glVertex2d(-size.x/2, -size.y/2)
			glVertex2d(size.x/2, -size.y/2)
			glVertex2d(size.x/2, size.y/2)
			glVertex2d(-size.x/2, size.y/2)
		glEnd()
		
		If smooth_edges > 0 And line_size > 1 Then
			glPointSize(line_size)
			glBegin(GL_POINTS)
				glVertex2d(-size.x/2, -size.y/2)
				glVertex2d(size.x/2, -size.y/2)
				glVertex2d(size.x/2, size.y/2)
				glVertex2d(-size.x/2, size.y/2)
			glEnd()
		EndIf
		
		glPopMatrix()
		glEnable(GL_TEXTURE_2D)
	End Sub
	
	/'
	Function: Draw_
		
	
	Prototype:
		>
	
	Parameters:
		
	'/
	Sub Draw_RectCenterGlow(ByVal center As v2d, ByVal size As v2d, ByVal _Color As UInteger, ByVal angle As Integer = 0, ByVal line_size As Integer = 1)', ByVal smooth_edges As Integer = 1)
		glPushMatrix()
		
		glTranslated(center.x, center.y, 0)
		glRotated(angle, 0, 0, 1)
		
		'glColor4ubv(cast(GLubyte ptr, @_Color))
		
		'glLineWidth(line_size)
		
		Draw_LineGlow(v2d(-size.x/2, -size.y/2), v2d(size.x/2, -size.y/2), _Color, line_size)
		Draw_LineGlow(v2d(size.x/2, -size.y/2), v2d(size.x/2, size.y/2), _Color, line_size)
		Draw_LineGlow(v2d(size.x/2, size.y/2), v2d(-size.x/2, size.y/2), _Color, line_size)
		Draw_LineGlow(v2d(-size.x/2, size.y/2), v2d(-size.x/2, -size.y/2), _Color, line_size)
		
		glPopMatrix()
		'glEnable(GL_TEXTURE_2D)
	End Sub
	
	/'
	Function: Draw_
		
	
	Prototype:
		>
	
	Parameters:
		
	'/
	Sub Draw_RectCenterFill(ByVal center As v2d, ByVal size As v2d, ByVal _Color As UInteger, ByVal angle As Integer = 0)
		glDisable(GL_TEXTURE_2D)
		glPushMatrix()
		
		glTranslated(center.x, center.y, 0)
		glRotated(angle, 0, 0, 1)
		
		glColor4ubv(cast(GLubyte ptr, @_Color))
		
		glBegin(GL_QUADS)
			glVertex2d(-size.x/2, -size.y/2)
			glVertex2d(size.x/2, -size.y/2)
			glVertex2d(size.x/2, size.y/2)
			glVertex2d(-size.x/2, size.y/2)
		glEnd()
		
		glPopMatrix()
		glEnable(GL_TEXTURE_2D)
	End Sub
	
	/'
	Function: Draw_
		
	
	Prototype:
		>
	
	Parameters:
		
	'/
	Sub Draw_Ellipse(ByVal center As v2d, ByVal radiusX As Integer, ByVal radiusY As Integer, ByVal _Color As UInteger, ByVal angle As Integer = 0, ByVal line_size As Integer = 1, ByVal precision As Integer = 5)
		glDisable(GL_TEXTURE_2D)
		glPushMatrix()
		
		Dim i As Single
		If precision <= 0 Then precision = 1
		If precision > 90 Then precision = 90
		Dim precisionRad As Single = precision * _PI / 180
		
		glTranslated(center.x, center.y, 0)
		glRotated(angle, 0, 0, 1)
		glScalef(radiusX, radiusY, 1)
		
		glColor4ubv(cast(GLubyte ptr, @_Color))
		
		glLineWidth(line_size)
		
		glBegin(GL_LINE_LOOP)
			For i = 0 To 2 * _PI Step precisionRad
				glVertex2f(Sin(i), Cos(i))
			Next i
		glEnd()
		
		glPopMatrix()
		glEnable(GL_TEXTURE_2D)
	End Sub
	
	/'
	Function: Draw_
		
	
	Prototype:
		>
	
	Parameters:
		
	'/
	Sub Draw_EllipseGlow(ByVal center As v2d, ByVal radiusX As Integer, ByVal radiusY As Integer, ByVal _Color As UInteger, ByVal angle As Integer = 0, ByVal line_size As Integer = 1, ByVal precision As Integer = 5)
		'glDisable(GL_TEXTURE_2D)
		glPushMatrix()
		
		Dim i As Single
		If precision <= 0 Then precision = 1
		If precision > 90 Then precision = 90
		Dim precisionRad As Single = precision * _PI / 180
		
		glTranslated(center.x, center.y, 0)
		glRotated(angle, 0, 0, 1)
		'glScalef(radiusX, radiusY, 1)
		
		'glColor4ubv(cast(GLubyte ptr, @_Color))
		
		'glLineWidth(line_size)
		
		'glBegin(GL_LINE_LOOP)
			For i = 0 To (2 * _PI) - precisionRad Step precisionRad
				'glVertex2f(Sin(i), Cos(i))
				Draw_LineGlow(v2d(Sin(i) * radiusX, Cos(i) * radiusY), v2d(Sin(i + precisionRad) * radiusX, Cos(i + precisionRad) * radiusY), _Color, line_size)
			Next i
		'glEnd()
		
		glPopMatrix()
		'glEnable(GL_TEXTURE_2D)
	End Sub
	
	/'
	Function: Draw_
		
	
	Prototype:
		>
	
	Parameters:
		
	'/
	Sub Draw_EllipseFill(ByVal center As v2d, ByVal radiusX As Integer, ByVal radiusY As Integer, ByVal _Color As UInteger, ByVal angle As Integer = 0, ByVal precision As Integer = 5)
		glDisable(GL_TEXTURE_2D)
		glPushMatrix()
		
		Dim i As Single
		If precision <= 0 Then precision = 1
		If precision > 90 Then precision = 90
		Dim precisionRad As Single = precision * _PI / 180
		
		glTranslated(center.x, center.y, 0)
		glRotated(angle, 0, 0, 1)
		glScalef(radiusX, radiusY, 1)
		
		glColor4ubv(cast(GLubyte ptr, @_Color))
		
		glBegin(GL_TRIANGLE_FAN)
			For i = 0 To 2 * _PI Step precisionRad
				glVertex2f(Sin(i), Cos(i))
			Next i
		glEnd()
		
		glPopMatrix()
		glEnable(GL_TEXTURE_2D)
	End Sub
	
	/'
	Function: Draw_
		
	
	Prototype:
		>
	
	Parameters:
		
	'/
	Sub Draw_Triangle(ByVal p1 As v2d, ByVal p2 As v2d, ByVal p3 As v2d, ByVal _Color As UInteger, ByVal line_size As UShort = 1, ByVal smooth_edges As UByte = 1)
		glDisable(GL_TEXTURE_2D)
		
		glColor4ubv(cast(GLubyte ptr, @_Color))
		
		glLineWidth(line_size)
		
		glBegin(GL_LINE_LOOP)
			glVertex2f(p1.x, p1.y)
			glVertex2f(p2.x, p2.y)
			glVertex2f(p3.x, p3.y)
		glEnd()
		
		If smooth_edges > 0 And line_size > 1 Then
			glPointSize(line_size)
			glBegin(GL_POINTS)
				glVertex2f(p1.x, p1.y)
				glVertex2f(p2.x, p2.y)
				glVertex2f(p3.x, p3.y)
			glEnd()
		EndIf
		
		glEnable(GL_TEXTURE_2D)
	End Sub
	
	/'
	Function: Draw_
		
	
	Prototype:
		>
	
	Parameters:
		
	'/
	Sub Draw_TriangleGlow(ByVal p1 As v2d, ByVal p2 As v2d, ByVal p3 As v2d, ByVal _Color As UInteger, ByVal line_size As UShort = 1)', ByVal smooth_edges As UByte = 1)
		Draw_LineGlow(p1, p2, _Color, line_size)
		Draw_LineGlow(p2, p3, _Color, line_size)
		Draw_LineGlow(p3, p1, _Color, line_size)
	End Sub	
	
	/'
	Function: Draw_
		
	
	Prototype:
		>
	
	Parameters:
		
	'/
	Sub Draw_TriangleFill(ByVal p1 As v2d, ByVal p2 As v2d, ByVal p3 As v2d, ByVal _Color As UInteger)
		glDisable(GL_TEXTURE_2D)
		
		glColor4ubv(cast(GLubyte ptr, @_Color))
		
		glBegin(GL_TRIANGLES)
			glVertex2f(p1.x, p1.y)
			glVertex2f(p2.x, p2.y)
			glVertex2f(p3.x, p3.y)
		glEnd()
		
		glEnable(GL_TEXTURE_2D)
	End Sub
	
	/'
	Function: Draw_BlendMode
		Change the blending mode of the upsequent drawings
	
	Protoype:
		>Sub Draw_BlendMode(ByVal mode As E_BLEND_MODE = BM_TRANS)
	
	Parameters:
		mode (E_BLEND_MODE) - Blend mode (<E_BLEND_MODE>)
	'/
	Sub Draw_BlendMode(ByVal mode As E_BLEND_MODE = BM_TRANS)
		_SetBlendMode(mode)
	End Sub
	
	''==========================================
	
End Namespace
