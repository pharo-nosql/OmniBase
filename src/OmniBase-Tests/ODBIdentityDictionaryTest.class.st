"
Tests for ODBIdentityDictionary
"
Class {
	#name : #ODBIdentityDictionaryTest,
	#superclass : #TestCase,
	#category : #'OmniBase-Tests'
}

{ #category : #tests }
ODBIdentityDictionaryTest >> testAssociationsDo [
	| dict |
	dict := ODBIdentityDictionary new.
	dict at: #hello put: true.
	dict at: #hell2 put: true.
	dict associationsDo: [ :each | self assert: each value ]
]

{ #category : #tests }
ODBIdentityDictionaryTest >> testAtifAbsentPut [
	| dict |
	dict := ODBIdentityDictionary new.
	dict at: #hello ifAbsentPut: #something.
	dict at: #hello ifAbsentPut: #somethingElse.
	self assert: (dict at: #hello) equals: #something
]

{ #category : #tests }
ODBIdentityDictionaryTest >> testIncludesKey [
	| dict |
	dict := ODBIdentityDictionary new.
	self deny: (dict includesKey: #hello).
	dict at: #hello put: #something.
	self assert: (dict includesKey: #hello).
]

{ #category : #tests }
ODBIdentityDictionaryTest >> testIsEmpty [
	| dict |
	dict := ODBIdentityDictionary new.
	self assert: dict isEmpty.
	dict at: #hello put: #something.
	self deny: dict isEmpty.
]

{ #category : #tests }
ODBIdentityDictionaryTest >> testRemoveKey [
	| dict |
	dict := ODBIdentityDictionary new.
	dict at: #hello put: #something.
	self assert: (dict includesKey: #hello).
	dict removeKey: #hello.
	self assert: dict isEmpty
]

{ #category : #tests }
ODBIdentityDictionaryTest >> testRemoveKeyIfAbsent [
	| dict bingo |
	dict := ODBIdentityDictionary new.
	dict at: #hello put: #something.
	self assert: (dict includesKey: #hello).
	bingo := false.
	dict removeKey: #hello ifAbsent: [bingo:= true.].
	self deny: bingo.
	self assert: dict isEmpty.
	dict at: #hello put: #something.
	dict removeKey: #nono ifAbsent: [bingo:= true.].
	self assert: bingo.
	self deny: dict isEmpty.
]
