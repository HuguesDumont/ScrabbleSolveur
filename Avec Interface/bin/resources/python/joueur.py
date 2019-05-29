from lettre import Lettre
class Joueur :

    def __init__(self):
        self.points = 0
        self.mots = []
        self.chevalet = []

    def ajouterLettre(self,lettre):
        if len(self.chevalet) == 7:
            raise TypeError("le joueur à deja 7 lettres")
        self.chevalet.append(lettre)


    def afficherChevalet(self):
        for lettre in self.chevalet:
            print(lettre)
            

    def getChevalet(self):
        chevalet=''
        for lettre in self.chevalet:
            chevalet += lettre
        return chevalet

    def enleverChevalet(self,lettres):
        for lettre in lettres:
           del  self.chevalet[self.chevalet.index(lettre)]
