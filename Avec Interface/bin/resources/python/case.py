from lettre import Lettre

class Case:

    def __init__(self,abscisse: int,ordonnee: int,type=" "):
        self.type=type
        self.abscisse=abscisse
        self.ordonnee=ordonnee
        self.lettre = Lettre('_',0)

    def __CalculeLettreDouble(self,mot):
        mot.AjouterPoints((self.lettre.points*2))
        return 0

    def __CalculeLettreTriple(self,mot):
        mot.AjouterPoints((self.lettre.points*3))
        return 1

    def __CalculeMotDouble(self,mot):
        mot.AjouterPoints((self.lettre.points))
        mot.multiplicateur=((mot.multiplicateur*2))
        return 2

    def __CalculeMotTriple(self,mot):
        mot.AjouterPoints((self.lettre.points))
        mot.multiplicateur = (mot.multiplicateur * 3)
        return 3

    def __CalculSimple(self,mot):
        mot.AjouterPoints(self.lettre.points)
        return 4

    def calculerpoint(self,mot):
        from mot import Mot
        if not isinstance(mot,Mot):
            raise TypeError("le paramètre doit être une instance de mot")
        if self.type =="Ld":
            return self.__CalculeLettreDouble(mot)
        elif self.type=="Lt":
            return self.__CalculeLettreTriple(mot)

        elif self.type =="Md":
            return self.__CalculeMotDouble(mot)

        elif self.type =="Mt":
            return self.__CalculeMotTriple(mot)

        elif self.type =="":
            return self.__CalculSimple(mot)


    def AjouterLettre(self,lettre : Lettre):
        self.lettre=lettre


    def setType(self,type):
        self.type=type