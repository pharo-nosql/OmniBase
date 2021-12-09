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
