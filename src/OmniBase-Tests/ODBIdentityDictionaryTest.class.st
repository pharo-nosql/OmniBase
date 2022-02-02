"
Tests for ODBIdentityDictionary
"
Class {
	#name : #ODBIdentityDictionaryTest,
	#superclass : #TestCase,
	#instVars : [
		'dict'
	],
	#category : #'OmniBase-Tests'
}

{ #category : #running }
ODBIdentityDictionaryTest >> setUp [
	super setUp.
	dict := ODBIdentityDictionary new
]

{ #category : #tests }
ODBIdentityDictionaryTest >> testAssociationsDo [
	dict at: #hello put: true.
	dict at: #hell2 put: true.
	dict associationsDo: [ :each | self assert: each value ]
]

{ #category : #tests }
ODBIdentityDictionaryTest >> testAtifAbsent [
	dict at: #hello ifAbsentPut: #something.
	dict at: #hello ifAbsent: [ self error ].
	self assert: (dict at: #hello) equals: #something
]

{ #category : #tests }
ODBIdentityDictionaryTest >> testAtifAbsentPut [
	dict at: #hello ifAbsentPut: #something.
	dict at: #hello ifAbsentPut: #somethingElse.
	self assert: (dict at: #hello) equals: #something
]

{ #category : #tests }
ODBIdentityDictionaryTest >> testIncludesKey [
	self deny: (dict includesKey: #hello).
	dict at: #hello put: #something.
	self assert: (dict includesKey: #hello).
]

{ #category : #tests }
ODBIdentityDictionaryTest >> testIsEmpty [
	self assert: dict isEmpty.
	dict at: #hello put: #something.
	self deny: dict isEmpty.
]

{ #category : #tests }
ODBIdentityDictionaryTest >> testRemoveKey [
	dict at: #hello put: #something.
	self assert: (dict includesKey: #hello).
	dict removeKey: #hello.
	self assert: dict isEmpty
]

{ #category : #tests }
ODBIdentityDictionaryTest >> testRemoveKeyIfAbsent [
	| bingo |
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
