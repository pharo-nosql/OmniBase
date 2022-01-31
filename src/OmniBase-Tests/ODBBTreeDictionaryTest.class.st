Class {
	#name : #ODBBTreeDictionaryTest,
	#superclass : #ODBDiskBasedTest,
	#category : #'OmniBase-Tests'
}

{ #category : #tests }
ODBBTreeDictionaryTest >> testNewBTreeDictionary [
 	| dict |
 	[ dict := (OmniBase newBTreeDictionary: 10)
 		at: #test  put: true;
 		yourself.
	 ] evaluateAndCommitIn: db newTransaction.
 	self assert: (dict at: #test)
]
