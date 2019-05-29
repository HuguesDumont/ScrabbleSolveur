from case import Case
from lettre import Lettre
from mot import Mot
from trie import Trie
from recherche import *
from joueur import Joueur
import copy
import sys

cdef class Plateau:

	cdef public valeurLettres
	cdef public cases

	def __init__(self):
		self.valeurLettres ={"E":1,"A": 1,"I": 1,"N": 1,"O": 1,"R": 1,"S": 1,"T": 1,"U": 1,"L": 1,"D": 2,"M": 2,"G": 2,"B": 3,"C": 3,"P": 3,"F": 4,"H": 4,"V": 4,"J": 8,"Q": 8,"K": 10,"W": 10,"X": 10,"Y": 10,"Z": 10}
		self.cases = [['' for x in range(15)] for x in range(15)]
		for i in range (0,15):
			for j in range(0,15):
				self.cases[i][j]=Case(i,j,"")		
		self.cases[0][0].setType("Mt")
		self.cases[1][1].setType("Md")
		self.cases[2][2].setType("Md")
		self.cases[3][3].setType("Md")
		self.cases[4][4].setType("Md")
		self.cases[5][5].setType("Lt")
		self.cases[6][6].setType("Ld")
		self.cases[7][7].setType("Md")
		self.cases[8][8].setType("Ld")
		self.cases[9][9].setType("Lt")
		self.cases[10][10].setType("Md")
		self.cases[11][11].setType("Md")
		self.cases[12][12].setType("Md")
		self.cases[13][13].setType("Md")
		self.cases[14][14].setType("Mt")
		self.cases[0][14].setType("Mt")
		self.cases[1][13].setType("Md")
		self.cases[2][12].setType("Md")
		self.cases[3][11].setType("Md")
		self.cases[4][10].setType("Md")
		self.cases[5][9].setType("Lt")
		self.cases[6][8].setType("Ld")
		self.cases[8][6].setType("Ld")
		self.cases[9][5].setType("Lt")
		self.cases[10][4].setType("Md")
		self.cases[11][3].setType("Md")
		self.cases[12][2].setType("Md")
		self.cases[13][1].setType("Md")
		self.cases[14][0].setType("Mt")
		self.cases[0][3].setType("Ld")
		self.cases[0][7].setType("Mt")
		self.cases[0][11].setType("Ld")
		self.cases[1][5].setType("Lt")
		self.cases[1][9].setType("Lt")
		self.cases[2][6].setType("Ld")
		self.cases[2][8].setType("Ld")
		self.cases[3][7].setType("Ld")
		self.cases[3][0].setType("Ld")
		self.cases[3][14].setType("Ld")
		self.cases[5][1].setType("Lt")
		self.cases[5][13].setType("Lt")
		self.cases[6][2].setType("Ld")
		self.cases[6][12].setType("Ld")
		self.cases[7][0].setType("Mt")
		self.cases[7][3].setType("Ld")
		self.cases[7][11].setType("Ld")
		self.cases[7][14].setType("Mt")
		self.cases[8][2].setType("Ld")
		self.cases[8][12].setType("Ld")
		self.cases[9][1].setType("Lt")
		self.cases[9][13].setType("Lt")
		self.cases[11][0].setType("Ld")
		self.cases[11][7].setType("Ld")
		self.cases[11][14].setType("Ld")
		self.cases[12][6].setType("Ld")
		self.cases[12][8].setType("Ld")
		self.cases[13][5].setType("Lt")
		self.cases[13][9].setType("Lt")
		self.cases[14][3].setType("Ld")
		self.cases[14][7].setType("Mt")
		self.cases[14][11].setType("Ld")

		#self.cases[7][7].AjouterLettre(Lettre('B',self.valeurLettres.get('B')))
		#self.cases[8][7].AjouterLettre(Lettre('O',self.valeurLettres.get('O')))
		#self.cases[9][7].AjouterLettre(Lettre('N',self.valeurLettres.get('N')))


	cpdef afficherPlateau(self):
		for ligne in self.cases:
			for case in ligne:
				print(case.lettre.valeur or '_', end=" ")
			print("")
		print("#############################")

#mot contient un string du mot
#positionX,positionY contient des int pour la ligne et la colonne du mot
#orientation est un bool pour savoir si la postion est verticale ou horizontale
	cpdef ajouterMot(self,mot,positionX,positionY,orientation):
		if orientation: #Si horizontal
			self.cases[positionY][positionX:positionX+len(mot)]=mot
		else: #Si vertical
			for i,col in enumerate(self.cases[positionY:positionY+len(mot)]):
				col[positionX]=mot[i]

	cpdef placementPremierMot(self,listMot):
		possibilite=[]
		i=0
		for mot in listMot:
			i=0
			while i<len(mot):
				if len(mot)<8:  
					possibilite.append([mot,7,7-i,True])
					i+=1
		return possibilite


	def placementMotsColonne(self,listeMot,colonne, joueur):
		possibilite=[]
		for mot in listeMot:
			i=0
			lettresPlat=''
			while i<15:
				if self.cases[i][colonne].lettre.valeur=='_': #On cherche jusqu'a tomber sur une lettre
					i=i+1
					lettresPlat=''
				else:
					while i<15 and self.cases[i][colonne].lettre.valeur!='_': #on les enregistre dans un string
						lettresPlat=lettresPlat+self.cases[i][colonne].lettre.valeur
						i=i+1
					if all(l in mot for l in (lettresPlat+joueur.getChevalet())): #Si les lettres placées sont dans le mot cherche ou le placer
						idx=0
						indexs=[]
						l = lettresPlat[0]
						for char in mot:
							if char == l:
								if mot[idx:idx+len(lettresPlat)] == lettresPlat:
									indexs.append(idx)
							idx += 1
						for index in indexs:
							if (i-index-len(lettresPlat)==0) or (i-index-len(lettresPlat)==i-len(lettresPlat)) or (i-index-len(lettresPlat)>0 and all(self.cases[item][colonne].lettre.valeur=='_' for item in range(i-index-len(lettresPlat),i-len(lettresPlat)))):#Si le mot est collé en haut ou si les lettres sont le début du mot sinon on vérifie que toute les cases sont vides
								if (i-1+len(mot)-index-len(lettresPlat)<15):#Si le mot n'est pas trop grand
									motPlace=self.cases[i-index-len(lettresPlat):i+len(mot)-index-len(lettresPlat)][0]
									placable=True
									for e in range(len(mot)):
										if not (mot[e]==motPlace[e].lettre.valeur or motPlace[e].lettre.valeur=='_'):
											placable=False
									if(placable):
										possibilite.append([mot,i-index-len(lettresPlat),colonne,False])
			i=0
		return possibilite



	def placementMotsLigne(self,listeMot,ligne,joueur):
		possibilite=[]
		for mot in listeMot:
			i=0
			lettresPlat=''
			while i<15:
				if self.cases[ligne][i].lettre.valeur=='_': #On cherche jusqu'a tomber sur une lettre
					i=i+1
					lettresPlat=''
				else:
					while i<15 and self.cases[ligne][i].lettre.valeur!='_': #on les enregistre dans un string
						lettresPlat=lettresPlat+self.cases[ligne][i].lettre.valeur
						i=i+1

					if all(l in mot for l in (lettresPlat+joueur.getChevalet())): #Si les lettres placées sont dans le mot cherche ou le placer
						idx=0
						indexs=[]
						l = lettresPlat[0]
						for char in mot:
							if char == l:
								if mot[idx:idx+len(lettresPlat)] == lettresPlat:
									indexs.append(idx)
							idx += 1
						for index in indexs:
							if (all(item.lettre.valeur=='_' for item in self.cases[ligne][i-1-index-len(lettresPlat):i-len(lettresPlat)]) and ((i-1-index-len(lettresPlat))>0) or (i-index-len(lettresPlat)==0)):#Peut on placer le mot avant: Si toutes les cases sont vides ou si il est collé au bord
								if (i-1+len(mot)-index-len(lettresPlat)<15):#Si le mot n'est pas trop grand
									if all(item.lettre.valeur=='_' for item in self.cases[ligne][i:i+len(mot)-index-len(lettresPlat)]): #Si il y a assez de cases vides après pour placer le mot
										possibilite.append([mot,ligne,i-index-len(lettresPlat),True])

									else: #Si le mot peut etre placer sur d'autre lettres qui font partie du mot 
										motPlace=self.cases[ligne][i-index-len(lettresPlat):i+len(mot)-index-len(lettresPlat)]
										placable=True
										for e in range(len(mot)):
											if not (mot[e]==motPlace[e].lettre.valeur or motPlace[e].lettre.valeur=='_'):
												placable=False
										if(placable):
											possibilite.append([mot,ligne,i-index-len(lettresPlat),True])
			i=0
		return possibilite

	cpdef str rechercheLettreLigne(self,int ligne):
		i=0
		while i<15 and self.cases[ligne][i].lettre.valeur=='_':
			i=i+1
		lettres=''
		while i<15 and self.cases[ligne][i].lettre.valeur!='_':
			lettres= lettres+self.cases[ligne][i].lettre.valeur
			i=i+1
		return lettres

	cpdef str rechercheLettreColonne(self,int colonne):
		i=0
		while i<15 and self.cases[i][colonne].lettre.valeur=='_':
			i=i+1
		lettres=''
		while i<15 and self.cases[i][colonne].lettre.valeur!='_':
			lettres= lettres+self.cases[i][colonne].lettre.valeur
			i=i+1
		return lettres

	cpdef AjouterMot(self,mot,joueur : Joueur = None):
		listeCases=[]
		listeLettre=[]

		if mot[3]: #Place en ligne
			for idx,lettre in enumerate(mot[0]):
				if self.cases[mot[1]][mot[2]+idx].lettre.valeur== '_':
					listeLettre.append(lettre)
				self.cases[mot[1]][mot[2]+idx].lettre=Lettre(lettre,self.valeurLettres.get(lettre))

				listeCases.append(self.cases[mot[1]][mot[2]+idx])

		else: #Place en colonne
			for idx,lettre in enumerate(mot[0]):
				if self.cases[mot[1]+idx][mot[2]].lettre.valeur== '_':
					listeLettre.append(lettre)
				self.cases[mot[1]+idx][mot[2]].lettre=Lettre(lettre,self.valeurLettres.get(lettre))

				listeCases.append(self.cases[mot[1]+idx][mot[2]])
		if joueur != None :
			joueur.enleverChevalet(listeLettre)

		return Mot(listeCases,mot[3])

	cpdef AjouterMotTemp(self,mot,joueur : Joueur = None):
		listeCases=[]
		listeLettre=[]

		if mot[3]: #Place en ligne

			for idx,lettre in enumerate(mot[0]):

				if self.cases[mot[1]][mot[2]+idx].lettre.valeur== '_':
					listeLettre.append(lettre)
					self.cases[mot[1]][mot[2]+idx].lettre=Lettre(lettre,self.valeurLettres.get(lettre),True)

				listeCases.append(self.cases[mot[1]][mot[2]+idx])

		else: #Place en colonne


			for idx,lettre in enumerate(mot[0]):
				if self.cases[mot[1]+idx][mot[2]].lettre.valeur== '_':
					listeLettre.append(lettre)
					self.cases[mot[1]+idx][mot[2]].lettre=Lettre(lettre,self.valeurLettres.get(lettre),True)

				listeCases.append(self.cases[mot[1]+idx][mot[2]])
		if joueur != None :
			joueur.enleverChevalet(listeLettre)

		return Mot(listeCases,mot[3])


	cpdef RetirerMotTemp(self,mot,joueur : Joueur = None):
		listeCases=[]
		listeLettre=[]

		if mot[3]: #Place en ligne
			for idx,lettre in enumerate(mot[0]):
				if self.cases[mot[1]][mot[2]+idx].lettre.temp==True:
					self.cases[mot[1]][mot[2]+idx].lettre=Lettre('_',0,False)
		else: #Place en colonne
			for idx,lettre in enumerate(mot[0]):
				if self.cases[mot[1]+idx][mot[2]].lettre.temp==True:
					self.cases[mot[1]+idx][mot[2]].lettre=Lettre('_',0,False)


	cpdef CalculScore(self,mots,t):
		liste2=self.getListeMot2()	#On chercher tout les mots de l'ancien plateau même ce fait implicitement (TODO : stocke cette liste dans un attribut pour ne pas refaire le calcul à chaque fois)
		listedeMot=[]
		for mot in mots:
			newMot = self.AjouterMotTemp(mot)
			liste1=self.getListeMot2()
			listeMotDiff = [item for item in liste1 if item not in liste2] #Liste des nouveaux mots
			score=0
			if motsExist(listeMotDiff,t):
				for motNew in listeMotDiff:
					motPlace =self.AjouterMotTemp(motNew)
					score = score + motPlace.CalculerPoints()
					listedeMot.append([motNew,score])
					self.RetirerMotTemp(motNew)
			self.RetirerMotTemp(mot)
		return listedeMot


	cpdef getBestWord(self,list):
		bestScore=0
		mylist=[]
		for mot in list:
			if mot[1]>=bestScore:
				mylist=mot
				bestScore=mot[1]
		return mylist

	cpdef getScore(self, wordScore):
		return wordScore[1]



	def PlacementMotChevalet(self,mots):
		listeMot=[]
		for mot in mots: #Pour chaque mots que l'on peut faire avec le chevalet on va essayer de le placer
			for ligne in range(15): #On essaye de le placer sur chaque lignes
				for colonne in range(15-len(mot)+1):
					if(all(self.cases[ligne][x].lettre.valeur=='_' for x in range(colonne,colonne+len(mot)))): #Si on a que des cases vides (car l'autre fonction s'occupe de ce cas)
						if ligne==0: #Si on est en haut de la grille
							if any(self.cases[ligne+1][x].lettre.valeur!='_' for x in range(colonne,colonne+len(mot))): #Si on trouve 1 lettre en dessous du mot
								if(colonne+len(mot)==15 or self.cases[ligne][colonne+len(mot)].lettre.valeur=='_'): #si il y a une case vide après ou si on est au bout de la ligne (Pas besoin de chercher car explorer par l'autre fontion)
									listeMot.append([mot,ligne,colonne,True])
						elif ligne==14: 
							if any(self.cases[ligne-1][x].lettre.valeur!='_' for x in range(colonne,colonne+len(mot))): #Si on trouve 1 lettre au dessus du mot
								if(colonne+len(mot)==15 or self.cases[ligne][colonne+len(mot)].lettre.valeur=='_'): #si il y a une case vide après ou si on est au bout de la ligne (Pas besoin de chercher car explorer par l'autre fontion)
									listeMot.append([mot,ligne,colonne,True])
						else:
							if any((self.cases[ligne+1][x].lettre.valeur!='_' or self.cases[ligne-1][x].lettre.valeur!='_')  for x in range(colonne,colonne+len(mot))): #Si on trouve 1 lettre en dessous ou au dessus du mot
								if(colonne+len(mot)==15 or self.cases[ligne][colonne+len(mot)].lettre.valeur=='_'): #si il y a une case vide après ou si on est au bout de la ligne (Pas besoin de chercher car explorer par l'autre fontion)
									listeMot.append([mot,ligne,colonne,True])

			for colonne in range(15): #On essaye de le placer sur chaque colonne
				for ligne in range(15-len(mot)+1):
					if(all(self.cases[x][colonne].lettre.valeur=='_' for x in range(ligne,ligne+len(mot)))): #Si on a que des cases vides
						if colonne==0: #Si on est a gauche de la grille
							if any(self.cases[x][colonne+1].lettre.valeur!='_' for x in range(ligne,ligne+len(mot))): #Si on trouve 1 lettre en dessous du mot
								if(ligne+len(mot)==15 or self.cases[ligne+len(mot)][colonne].lettre.valeur=='_'): #si il y a une case vide après ou si on est au bout de la colonne (Pas besoin de chercher car explorer par l'autre fontion)
									listeMot.append([mot,ligne,colonne,False])
						elif colonne==14: #Si on est à droite de la grille
							if any(self.cases[x][colonne-1].lettre.valeur!='_' for x in range(ligne,ligne+len(mot))): #Si on trouve 1 lettre au dessus du mot
								if(ligne+len(mot)==15 or self.cases[ligne+len(mot)][colonne].lettre.valeur=='_'): #si il y a une case vide après ou si on est au bout de la colonne (Pas besoin de chercher car explorer par l'autre fontion)
									listeMot.append([mot,ligne,colonne,False])
						else:
							if any((self.cases[x][colonne+1].lettre.valeur!='_' or self.cases[x][colonne-1].lettre.valeur!='_')  for x in range(ligne,ligne+len(mot))): #Si on trouve 1 lettre en dessous ou au dessus du mot
								if(ligne+len(mot)==15 or self.cases[ligne+len(mot)][colonne].lettre.valeur=='_'): #si il y a une case vide après ou si on est au bout de la colonne (Pas besoin de chercher car explorer par l'autre fontion)
									listeMot.append([mot,ligne,colonne,False])
		return listeMot

	cpdef getListeMot(self,mot): #Cherche tout les mots du tableau de plus de 2 lettres
		listeMot=[]
		if mot[3]: #Si le mot est placé en ligne
			for colonne in range(mot[2],mot[2]+len(mot[0])): #On cherche dans les colonnes qui contiennent le mot
				i=0
				while i<15 and self.cases[i][colonne].lettre.valeur=='_': #On cherche jusqu'a tomber sur une lettre
					lettresPlat=""
					i=i+1
					while i<15 and self.cases[i][colonne].lettre.valeur!='_': #on les enregistre dans un string
						lettresPlat=lettresPlat+self.cases[i][colonne].lettre.valeur
						i=i+1
					if(lettresPlat is not "" and len(lettresPlat)>1):
						listeMot.append([lettresPlat,i-len(lettresPlat),colonne,False])
			ligne=mot[1]
			i=0
			while i<15 and self.cases[ligne][i].lettre.valeur=='_': #On cherche jusqu'a tomber sur une lettre
				lettresPlat=""
				i=i+1
				while i<15 and self.cases[ligne][i].lettre.valeur!='_': #on les enregistre dans un string
					lettresPlat=lettresPlat+self.cases[ligne][i].lettre.valeur
					i=i+1
				if(lettresPlat is not "" and len(lettresPlat)>1):
					listeMot.append([lettresPlat,ligne,i-len(lettresPlat),True])

		else: #Si le mot est placé en colonne
			for ligne in range(mot[1],mot[1]+len(mot[0])): #On cherche dans les colonnes qui contiennent le mot
				i=0
				while i<15 and self.cases[ligne][i].lettre.valeur=='_': #On cherche jusqu'a tomber sur une lettre
					lettresPlat=""
					i=i+1
					while i<15 and self.cases[ligne][i].lettre.valeur!='_': #on les enregistre dans un string
						lettresPlat=lettresPlat+self.cases[ligne][i].lettre.valeur
						i=i+1
					if(lettresPlat is not "" and len(lettresPlat)>1):
						listeMot.append([lettresPlat,ligne,i-len(lettresPlat),True])
			colonne=mot[2]
			i=0
			while i<15 and self.cases[i][colonne].lettre.valeur=='_': #On cherche jusqu'a tomber sur une lettre
				lettresPlat=""
				i=i+1
				while i<15 and self.cases[i][colonne].lettre.valeur!='_': #on les enregistre dans un string
					lettresPlat=lettresPlat+self.cases[i][colonne].lettre.valeur
					i=i+1
				if(lettresPlat is not "" and len(lettresPlat)>1):
					listeMot.append([lettresPlat,i-len(lettresPlat),colonne,False])
			pass
		return listeMot #On retourne la liste de mot à tester dans le dictionnaire


	cpdef getListeMot2(self): #Cherche tout les mots du tableau de plus de 2 lettres

		listeMot=[]
		for colonne in range(15):
			i=0
			lettresPlat=""
			while i<15:
				if self.cases[i][colonne].lettre.valeur=='_': #On cherche jusqu'a tomber sur une lettre
					lettresPlat=""
					i=i+1
				else:
					while i<15 and self.cases[i][colonne].lettre.valeur!='_': #on les enregistre dans un string
						lettresPlat=lettresPlat+self.cases[i][colonne].lettre.valeur
						i=i+1
					if(lettresPlat is not "" and len(lettresPlat)>1):
						listeMot.append([lettresPlat,i-len(lettresPlat),colonne,False])
		for ligne in range(15):
			i=0
			lettresPlat=""
			while i<15 :
				if self.cases[ligne][i].lettre.valeur=='_': #On cherche jusqu'a tomber sur une lettre
					lettresPlat=""
					i=i+1
				else:
					while i<15 and self.cases[ligne][i].lettre.valeur!='_': #on les enregistre dans un string
						lettresPlat=lettresPlat+self.cases[ligne][i].lettre.valeur
						i=i+1
					if(lettresPlat is not "" and len(lettresPlat)>1):
						listeMot.append([lettresPlat,ligne,i-len(lettresPlat),True])
		return listeMot
