Class {
	#name : #ODBPersistentDictionaryTest,
	#superclass : #ODBDiskBasedTest,
	#category : #'OmniBase-Tests'
}

{ #category : #tests }
ODBPersistentDictionaryTest >> testAdd [
	| dict |
	[ dict := OmniBase newPersistentDictionary
		add: (#test -> true);
		yourself] evaluateAndCommitIn: db newTransaction.
	self assert: (dict at: #test)
]

{ #category : #tests }
ODBPersistentDictionaryTest >> testAddImmediateObject [
	| dict |
	[ dict := OmniBase newPersistentDictionary
		add: (#test -> 1);
		yourself] evaluateAndCommitIn: db newTransaction.
	self assert: (dict at: #test) equals: 1.
]

{ #category : #tests }
ODBPersistentDictionaryTest >> testNewPersistentDictionary [
	| dict |
	[ dict := OmniBase newPersistentDictionary
		at: #test  put: true;
		yourself.
	dict := dict asDictionary ] evaluateAndCommitIn: db newTransaction.
	self assert: (dict at: #test)
]

{ #category : #tests }
ODBPersistentDictionaryTest >> testRemoveKeyifAbsent [
	| dict tag |
	tag := false.
	[ dict := OmniBase newPersistentDictionary
		add: (#test -> true);
		add: (#tt -> true);
		yourself.
	dict removeKey: #test ifAbsent: [ self error ].	
	dict removeKey: #test ifAbsent: [ tag := true ].	
		] evaluateAndCommitIn: db newTransaction.
	self assert: (dict at: #tt).
	self assert: tag
]

{ #category : #tests }
ODBPersistentDictionaryTest >> testTransaction [
	| dict transaction |
	transaction := db newTransaction.
	[ dict := OmniBase newPersistentDictionary
		add: (#test -> true);
		yourself.
		self assert: dict transaction equals: transaction.	
		] evaluateAndCommitIn: transaction.
	self assert: (dict at: #test)
]
