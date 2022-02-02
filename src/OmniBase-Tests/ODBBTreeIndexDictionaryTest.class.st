Class {
	#name : #ODBBTreeIndexDictionaryTest,
	#superclass : #ODBDiskBasedTest,
	#category : #'OmniBase-Tests'
}

{ #category : #tests }
ODBBTreeIndexDictionaryTest >> testAtifAbsentPut [
 	| dict |
 	[ dict := (OmniBase newBTreeIndexDictionary: 10)
 		at: #test ifAbsentPut: [true];
		at: #test ifAbsentPut: [false];
 		yourself.
	 ] evaluateAndCommitIn: db newTransaction.
 	self assert: (dict at: #test)
]

{ #category : #tests }
ODBBTreeIndexDictionaryTest >> testDo [
 	| dict |
 	[ dict := (OmniBase newBTreeIndexDictionary: 10)
 		at: #test put: true;
 		yourself.
	 ] evaluateAndCommitIn: db newTransaction.
 	dict do: [ :each | self assert: each ].
]

{ #category : #tests }
ODBBTreeIndexDictionaryTest >> testFirst [
 	| dict |
 	[ dict := (OmniBase newBTreeIndexDictionary: 10)
 		at: #test put: true;
		at: #test2 put: true;
 		yourself.
	 ] evaluateAndCommitIn: db newTransaction.
	self assert: (dict first: 2) first.
	self assert: dict first.
]

{ #category : #tests }
ODBBTreeIndexDictionaryTest >> testGetLast [
 	| dict |
 	[ dict := (OmniBase newBTreeIndexDictionary: 10)
 		at: #test put: false;
		at: #test2 put: true;
 		yourself.
		self assert: dict getLast
	 ] evaluateAndCommitIn: db newTransaction.
	self assert: dict getLast
]

{ #category : #tests }
ODBBTreeIndexDictionaryTest >> testKeyLength [
 	| dict |
 	[ dict := (OmniBase newBTreeIndexDictionary: 10)
 		at: #test put: true;
 		yourself.
	 ] evaluateAndCommitIn: db newTransaction.
	"minimal is 10"
 	self assert: dict keyLength equals: 10
]

{ #category : #tests }
ODBBTreeIndexDictionaryTest >> testKeySize [
 	| dict |
 	[ dict := (OmniBase newBTreeIndexDictionary: 10)
 		at: #test put: true;
 		yourself.
	 ] evaluateAndCommitIn: db newTransaction.
	"minimal is 10"
 	self assert: dict keySize equals: 10
]

{ #category : #tests }
ODBBTreeIndexDictionaryTest >> testNewBTreeIndexDictionary [
 	| dict |
 	[ dict := (OmniBase newBTreeIndexDictionary: 10)
 		at: #test  put: true;
 		yourself.
	 ] evaluateAndCommitIn: db newTransaction.
 	self assert: (dict at: #test)
]

{ #category : #tests }
ODBBTreeIndexDictionaryTest >> testValues [
 	| dict |
 	[ dict := (OmniBase newBTreeIndexDictionary: 10)
 		at: #test put: true;
 		yourself.
	 ] evaluateAndCommitIn: db newTransaction.
 	self assert: dict values first
]
