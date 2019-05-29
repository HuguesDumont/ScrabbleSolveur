from case import Case
from typing import List
class Mot:

    def __init__(self,cases : List[Case],orientation):
        self.cases=cases
        self.orientation=orientation
        self._points=0
        self.multiplicateur=1

    def CalculerPoints(self):
        self._points=0
        self._multiplicateur=1
        for case in self.cases:
            case.calculerpoint(self)
        return self.GetPoint()

    def GetPoint(self):
        return self._points*self.multiplicateur

    def AjouterPoints(self,nombre):
        #print(nombre)
        self._points+=nombre