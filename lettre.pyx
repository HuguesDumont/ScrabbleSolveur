cdef class Lettre:
	cdef public str valeur
	cdef public int points
	cdef public temp

	def __init__(self,str valeur ,int points,temp : bool = False):
		self.valeur=valeur
		self.points=points
		self.temp=temp

	cdef str getValue(self):
		return self.valeur