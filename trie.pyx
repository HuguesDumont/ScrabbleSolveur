import sys

from collections import Counter 

cdef class Node:

	cdef public label
	cdef public data
	cdef public children
	cdef public real_word


	def __init__(self, label=None, data=None,real_word=None):

		self.label = label

		self.data = data

		self.children = dict()

		self.real_word = []

	

	cpdef void addChild(self, key, data=None):

		if not isinstance(key, Node):

			self.children[key] = Node(key, data)

		else:

			self.children[key.label] = key

	

	def __getitem__(self, key):

		return self.children[key]



cdef class Trie:

	cdef public head

	def __init__(self):

		self.head = Node()

	

	def __getitem__(self, key):

		return self.head.children[key]

	

	cpdef add(self, word):

		current_node = self.head

		word_finished = True

		

		for i in range(len(word)):

			if word[i] in current_node.children:

				current_node = current_node.children[word[i]]

			else:

				word_finished = False

				break

		

		# For ever new letter, create a new child node

		if not word_finished:

			while i < len(word):

				current_node.addChild(word[i])

				current_node = current_node.children[word[i]]


				i += 1

		

		# Let's store the full word at the end node so we don't need to

		# travel back up the tree to reconstruct the word

		current_node.data = word

		return current_node.real_word

	

	cpdef has_word(self, word):

		if word == '':

			return False

		if word == None:

			raise ValueError('Trie.has_word requires a not-Null string')

		

		# Start at the top

		current_node = self.head

		exists = True

		for letter in word:

			if letter in current_node.children:

				current_node = current_node.children[letter]

			else:

				exists = False

				break

		

		# Still need to check if we just reached a word like 't'

		# that isn't actually a full word in our dictionary

		if exists:

			if current_node.data == None:

				exists = False

		

		return exists

	

	cpdef list start_with_prefix(self, prefix):

		""" Returns a list of all words in tree that start with prefix """

		words = list()

		if prefix == None:

			raise ValueError('Requires not-Null prefix')

		

		# Determine end-of-prefix node

		top_node = self.head

		for letter in prefix:

			if letter in top_node.children:

				top_node = top_node.children[letter]

			else:

				# Prefix not in tree, go no further

				return words

		

		# Get words under prefix

		if top_node == self.head:

			queue = [node for key, node in top_node.children.items()]

		else:

			queue = [top_node]

		

		# Perform a breadth first search under the prefix

		# A cool effect of using BFS as opposed to DFS is that BFS will return

		# a list of words ordered by increasing length

		while queue:

			current_node = queue.pop()

			if current_node.data != None:

				# Isn't it nice to not have to go back up the tree?

				words.append(current_node.data)

			

			queue = [node for key,node in current_node.children.items()] + queue

		

		return words

	

	cpdef getData(self, word):

		""" This returns the 'data' of the node identified by the given word """

		if not self.has_word(word):

			raise ValueError('{} not found in trie'.format(word))

		

		# Race to the bottom, get data

		current_node = self.head

		for letter in word:

			current_node = current_node[letter]

		

		return current_node.real_word



cpdef void possibleWords(input,charSet):

	# traverse words in list one by one 

	for word in input: 

  

		# convert word into dictionary 

		dict = Counter(word) 

		  

		# now check if all keys of current word  

		# are present in given character set 

		flag = 1 

		for key in dict.keys(): 

			if key not in charSet: 

				flag = 0

		  

		# if all keys are present ( flag=1 )  

		# then print the word 

		if flag==1: 

			print(word)