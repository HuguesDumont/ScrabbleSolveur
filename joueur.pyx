from lettre import Lettre

cdef class Joueur :
    cdef public int points
    cdef public mots
    cdef public chevalet

    def __init__(self):
        self.points = 0
        self.mots = []
        self.chevalet = []

    cpdef void ajouterLettre(self,lettre):
        if len(self.chevalet) == 7:
            raise TypeError("le joueur à deja 7 lettres")
        self.chevalet.append(lettre)


    cpdef void afficherChevalet(self):
        for lettre in self.chevalet:
            print(lettre)
            

    cpdef str getChevalet(self):
        chevalet=''
        for lettre in self.chevalet:
            chevalet += lettre
        return chevalet

    cpdef void enleverChevalet(self,lettres):
        for lettre in lettres:
           del  self.chevalet[self.chevalet.index(lettre)]
