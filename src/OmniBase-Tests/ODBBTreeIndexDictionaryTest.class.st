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
ODBBTreeIndexDictionaryTest >> testFirst [
 	| dict |
 	[ dict := (OmniBase newBTreeIndexDictionary: 10)
 		at: #test put: true;
 		yourself.
	 ] evaluateAndCommitIn: db newTransaction.
 	self assert: dict first
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
