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
	partie.afficherPioche()
	partie.plateau.afficherPlateau()


	tempsRecherche=0
	tempsPlacement=0
	tempsCalcul=0
	ScoreFinal=0
	tour=0
	mylist=['']
	while tour<30 and mylist!=[] and partie.pioche != [] :
		partie.joueur.afficherChevalet()
		start_time = time.time()
		listA=[]
		listB=[]
		mylist=[]
		if tour!=0:
############COLONNE
			for i in range(15):
				start_time = time.time()
				listA= recherche(t,partie.plateau.rechercheLettreColonne(i),partie.joueur.getChevalet())
				tempsRecherche  += time.time()-start_time

				start_time = time.time()
				possibiliteCol=(partie.plateau.placementMotsColonne(listA,i,partie.joueur))
				tempsPlacement  += time.time()-start_time

				start_time = time.time()
				mylist+=partie.plateau.CalculScore(possibiliteCol,t)
				tempsCalcul  += time.time()-start_time

############LIGNE
			for i in range(15):
				start_time = time.time()
				listB = recherche(t,partie.plateau.rechercheLettreLigne(i),partie.joueur.getChevalet())
				tempsRecherche  += time.time()-start_time

				start_time = time.time()
				possibiliteRow=(partie.plateau.placementMotsLigne(listB,i,partie.joueur))
				tempsPlacement  += time.time()-start_time

				start_time = time.time()
				mylist+=partie.plateau.CalculScore(possibiliteRow,t)
				tempsCalcul  += time.time()-start_time
				
###########CHEVALET
			start_time = time.time()
			listeC = recherche(t,'',partie.joueur.getChevalet())
			tempsRecherche  += time.time()-start_time

			start_time = time.time()
			chevaletlist = partie.plateau.PlacementMotChevalet(listeC)
			tempsPlacement  += time.time()-start_time

			start_time = time.time()
			mylist+=partie.plateau.CalculScore(chevaletlist,t)
			tempsCalcul  += time.time()-start_time
		else:
			listeC = recherche(t,'',partie.joueur.getChevalet())
			possibilite = partie.plateau.placementPremierMot(listeC)
			mylist+=partie.plateau.CalculScore(possibilite,t)
			
		sortedlist = sorted(mylist,reverse = True, key=takeSecond)
		testarray=partie.plateau.getBestWord(mylist)
		print("BestMOT",testarray)
		partie.plateau.AjouterMot(testarray[0],partie.joueur)
		ScoreFinal+=partie.plateau.getScore(testarray)
		partie.plateau.afficherPlateau()
		myin=[]
		tour+=1
		print("TOUR : ",tour)
		partie.piocher()
		print("SCORE PARTIE: ", ScoreFinal)
		print("Temps : ------------   ",time.time() - start_time)

		print("Recherche:",tempsRecherche)
		print("Placement:",tempsPlacement)
		print("Calcul:",tempsCalcul)

	print("")
	print("Recherche final:",tempsRecherche)
	print("Placement final:",tempsPlacement)
	print("Calcul final:",tempsCalcul)
