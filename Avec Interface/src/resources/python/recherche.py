from trie import *
from plateau import *
import time
import itertools

def word_generator(chars):
    for i in range(1, len(chars)+1):
        for s in itertools.combinations(chars,i):
            yield ''.join(s)


def containFixe(liste,fixe):
	for word in liste:
		if fixe in word and word != fixe:
			liste_finale.append(word)
	return liste_finale

def recherche(t, chevalet, lettres):
	list_possible = []
	list_result=[]
	list_possible = sorted(word_generator(lettres+chevalet))

	for word in list_possible:
		if sorted(word) not in list_result:
			list_result.append(sorted(word))
	liste =[]
	for word in list_result:
		if t.has_word(word):
			liste += t.getData(word)
	return liste


def motsExist(listeMot,trie):
	for mot in listeMot:
		if trie.has_word(sorted(mot[0])):
			if mot[0] not in trie.getData(sorted(mot[0])):
				return False
		else:
			return False
	return True
