from case import Case
from lettre import Lettre
from mot import Mot
from partie import Partie
from recherche import *
from plateau import *


def takeSecond(elem):
    return elem[1]

if __name__ == '__main__':

    
    t=Trie()

    f = open("francais.dic", "r")

    ff = open("FR_Sorted.dic","w")

    lines = f.readlines()

	#fixe = 'BON'


    partie = Partie(True)
    partie.afficherPioche()
    partie.plateau.afficherPlateau()

    tempsRecherche=0
    tempsPlacement=0
    tempsCalcul=0
    ScoreFinal=0
    tour=0
    while tour<10 and partie.pioche != [] :
        partie.joueur.afficherChevalet()
        for mot in lines:
            mot2 = ''.join(sorted(mot))
            t.add(mot2.strip()).append(mot.strip())
        start_time2 = time.time()
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
########LIGNE
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
########CHEVALET
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
            start_time = time.time()
            listeC = recherche(t,'',partie.joueur.getChevalet())
            tempsPlacement  += time.time()-start_time

            start_time = time.time()
            possibilite = partie.plateau.placementPremierMot(listeC)
            tempsPlacement  += time.time()-start_time

            start_time = time.time()
            mylist+=partie.plateau.CalculScore(possibilite,t)
            tempsPlacement  += time.time()-start_time
            
        sortedlist = sorted(mylist,reverse = True, key=takeSecond)
        bestmot=partie.plateau.getBestWord(mylist)
        print("BestMOT",bestmot)
        partie.plateau.AjouterMot(bestmot[0],partie.joueur)
        ScoreFinal+=partie.plateau.getScore(bestmot)
        partie.plateau.afficherPlateau()
        tour+=1
        partie.piocher()
        print("SCORE PARTIE: ", ScoreFinal)
        print("Temps : ------------   ",time.time() - start_time2)
          
        print("Recherche:",tempsRecherche)
        print("Placement:",tempsPlacement)
        print("Calcul:",tempsCalcul)
    print("")
    print("Recherche final:",tempsRecherche)
    print("Placement final:",tempsPlacement)
    print("Calcul final:",tempsCalcul)
