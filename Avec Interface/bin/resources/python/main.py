from case import Case
from lettre import Lettre
from mot import Mot
from partie import Partie
from recherche import *
from plateau import *
import ast
import os

def takeSecond(elem):
	return elem[1]

if __name__ == '__main__':
	t=Trie()
	f = open(os.path.dirname(os.path.realpath(__file__)) + "/francais.dic", "r")
	ff = open(os.path.dirname(os.path.realpath(__file__)) + "/FR_Sorted.dic","w")
	lines = f.readlines()


	for mot in lines:
		mot2 = ''.join(sorted(mot))
		t.add(mot2.strip()).append(mot.strip())
	partie = Partie(True)

	tour=0
	mylist=['']
	
	while mylist!=[] or partie.pioche != [] :
		partie.joueur.afficherChevalet()
		sys.stdout.flush()
		
		listA=[]
		listB=[]
		mylist=[]
		
		if tour!=0:
############COLONNE
			for i in range(15):
				listA=recherche(t,partie.plateau.rechercheLettreColonne(i),partie.joueur.getChevalet())
				possibiliteCol=(partie.plateau.placementMotsColonne(listA,i,partie.joueur))
				mylist+=partie.plateau.CalculScore(possibiliteCol,t)
			
############LIGNE
			for i in range(15):
				listB=recherche(t,partie.plateau.rechercheLettreLigne(i),partie.joueur.getChevalet())
				possibiliteRow=(partie.plateau.placementMotsLigne(listB,i,partie.joueur))
				mylist+=partie.plateau.CalculScore(possibiliteRow,t)

###########CHEVALET
			listeC=recherche(t,'',partie.joueur.getChevalet())
			chevaletlist=partie.plateau.PlacementMotChevalet(listeC)
			mylist+=partie.plateau.CalculScore(chevaletlist,t)
			
		else:
			listeC=recherche(t,'',partie.joueur.getChevalet())
			possibilite=partie.plateau.placementPremierMot(listeC)
			mylist=partie.plateau.CalculScore(possibilite,t)
			
		sortedlist = sorted(mylist,reverse = True, key=takeSecond)
		for elem in sortedlist:
			print(elem)
			sys.stdout.flush()
		print("*")
		sys.stdout.flush()
		
		myIn = input()
		if myIn == "!":
			partie.echangeLettre()
		else:
			testArray = ast.literal_eval(myIn)
			partie.plateau.AjouterMot(testArray[0],partie.joueur)
			partie.piocher()

		myin=[]
		tour+=1
