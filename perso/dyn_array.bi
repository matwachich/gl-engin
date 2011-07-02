''==========================================================================
''	Simply Dynamique Integer/Pointers array UDT
''		Matwachich
''		01/07/2011
''==========================================================================
Type Dyn_Array
	Declare Property Elem(ByVal index As Integer) As Integer
	Declare Property Elem(ByVal index As Integer, ByVal value As Integer)
	'''
	Declare Sub Add(ByVal value As Integer)
	Declare Sub Del(ByVal index As Integer)
	'''
	Declare Function UBound() As Integer
	'''
	Declare Destructor()
	Private:
	_iterate As Integer = 0
	_ptr As Integer Ptr = 0
	_nbr As Integer = 0
End Type

Property Dyn_Array.Elem(ByVal index As Integer) As Integer
	If index > This._nbr Then Return 0
	'''
	Return _ptr[index]
End Property
Property Dyn_Array.Elem(ByVal index As Integer, ByVal value As Integer)
	If index < This._nbr Then 
		_ptr[index] = value
	EndIf
End Property

Sub Dyn_Array.Add(ByVal value As Integer)
	This._ptr = ReAllocate(This._ptr, (This._nbr + 1) * SizeOf(Integer))
	This._ptr[This._nbr] = value
	This._nbr += 1
End Sub
Sub Dyn_Array.Del(ByVal index As Integer)
	If This._nbr <= 0 Or index > This._nbr Then
		Exit Sub
	Else
		Delete This._ptr[index]
		For i As Integer = index To This._nbr - 1
			This._ptr[i] = This._ptr[i + 1]
		Next i
		This._nbr -= 1
		This._ptr = ReAllocate(This._ptr, This._nbr * SizeOf(Integer))
	EndIf
End Sub

Function Dyn_Array.UBound() As Integer
	Return This._nbr
End Function

Destructor Dyn_Array()
	If This._nbr <> 0 Then
		For i As Integer = 0 To This._nbr
			Delete This._ptr[i]
		Next i
	EndIf
	DeAllocate(This._ptr)
End Destructor
