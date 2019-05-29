from lettre import Lettre

cdef class Case:

	cdef public str type
	cdef public int abscisse
	cdef public int ordonnee
	cdef public lettre

	def __init__(self,abscisse: int,ordonnee: int,type=" "):
		self.type=type
		self.abscisse=abscisse
		self.ordonnee=ordonnee
		self.lettre = Lettre('_',0)

	cdef int  __CalculeLettreDouble(self,mot):
		mot.AjouterPoints((self.lettre.points*2))
		return 0

	cdef int __CalculeLettreTriple(self,mot):
		mot.AjouterPoints((self.lettre.points*3))
		return 1

	cdef int  __CalculeMotDouble(self,mot):
		mot.AjouterPoints((self.lettre.points))
		mot.multiplicateur=((mot.multiplicateur*2))
		return 2

	cdef int __CalculeMotTriple(self,mot):
		mot.AjouterPoints((self.lettre.points))
		mot.multiplicateur = (mot.multiplicateur * 3)
		return 3

	cdef int __CalculSimple(self,mot):
		mot.AjouterPoints(self.lettre.points)
		return 4

	cpdef int calculerpoint(self,mot):
		from mot import Mot
		if not isinstance(mot,Mot):
			raise TypeError("le paramètre doit être une instance de mot")
		if self.type =="Ld":
			return self.__CalculeLettreDouble(mot)
		elif self.type =="Lt":
			return self.__CalculeLettreTriple(mot)

		elif self.type =="Md":
			return self.__CalculeMotDouble(mot)

		elif self.type =="Mt":
			return self.__CalculeMotTriple(mot)

		elif self.type =="":
			return self.__CalculSimple(mot)

	cpdef void AjouterLettre(self,lettre ):
		self.lettre=lettre

	cpdef void setType(self, str type):
		self.type=type