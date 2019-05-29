from case import Case
from typing import List
cdef class Mot:

    cdef public  list cases
    cdef public orientation
    cdef public int points
    cdef public int multiplicateur

    def __init__(self,list cases, orientation):
        self.cases=cases
        self.orientation=orientation
        self.points=0
        self.multiplicateur=1

    cpdef int CalculerPoints(self):
        self.points=0
        self.multiplicateur=1
        for case in self.cases:
            case.calculerpoint(self)
        return self.GetPoint()

    cpdef int GetPoint(self):
        return self.points*self.multiplicateur

    cpdef void AjouterPoints(self,int nombre):
        #print(nombre)
        self.points+=nombre