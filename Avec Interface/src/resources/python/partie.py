from case import Case
from lettre import Lettre
from mot import Mot
from plateau import Plateau
from joueur import Joueur
import random
class Partie :

   def  __init__(self, demo : bool = True):

       self.pioche = []
       self.demo=demo
       for i in range(1, 15):
           self.pioche.append("E")
       for i in range(1, 9):
           self.pioche.append("A")
       for i in range(1, 8):
           self.pioche.append("I")
       for i in range(1, 6):
           self.pioche.append("N")
           self.pioche.append("O")
           self.pioche.append("R")
           self.pioche.append("S")
           self.pioche.append("T")
           self.pioche.append("U")
       for i in range(1, 5):
           self.pioche.append("L")
       for i in range(1, 3):
           self.pioche.append("D")
           self.pioche.append("M")
       for i in range(1, 2):
           self.pioche.append("G")
           self.pioche.append("B")
           self.pioche.append("C")
           self.pioche.append("P")
           self.pioche.append("F")
           self.pioche.append("H")
           self.pioche.append("V")
       for i in range(1, 2):
           self.pioche.append("J")
           self.pioche.append("Q")
           self.pioche.append("K")
           self.pioche.append("W")
           self.pioche.append("X")
           self.pioche.append("Y")
           self.pioche.append("Z")

       self.plateau = Plateau()

       self.joueur = Joueur()
       if demo :
        random.Random(7).shuffle(self.pioche)
        for i in range(0, 7):
            self.joueur.ajouterLettre(self.pioche[0])
            del self.pioche[0]
       else :
         random.shuffle(self.pioche)
         for i in range (1, 8):
           rand = random.randint(0, len(self.pioche))
           self.joueur.ajouterLettre(self.pioche[rand])
           del self.pioche[rand]

   def piocher(self):
       while len(self.pioche)>0 and len(self.joueur.chevalet) <7 :
           if(self.demo) :
            self.joueur.ajouterLettre(self.pioche[0])
            del self.pioche[0]
           else :
            rand = random.randint(0, len(self.pioche))
            self.joueur.ajouterLettre(self.pioche[rand])
            del self.pioche[rand]


   def echangeLettre(self):
       if len(self.pioche) < 7:
           raise TypeError("la pioche contient 7 lettres ou moins l'échange n'est pas permis")

       tmp = self.joueur.chevalet
       for i in range (1,len(self.joueur.chevalet)):
        del self.joueur.chevalet[i]
        self.piocher()
       for l in tmp :
        self.pioche.append(l)


   def afficherPioche(self):
     for lettre in self.pioche:
        print(lettre)


   def PlacerMot(self,mot):
       listeLettre= self.plateau.ajouterMot(mot)
       self.joueur.enleverChevalet(listeLettre)