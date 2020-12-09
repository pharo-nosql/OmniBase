Class {
	#name : #ODBClassManagerForSerialization,
	#superclass : #Object,
	#instVars : [
		'classesToDescription',
		'idToClassDescription'
	],
	#category : 'OmniBase'
}

{ #category : #public }
ODBClassManagerForSerialization >> classDescriptionAt: anInteger [ 
	^idToClassDescription at: anInteger
		ifAbsent: [self error: '[Deserializer] Class description not found']
]

{ #category : #private }
ODBClassManagerForSerialization >> initializeForSerialization [
	idToClassDescription := OrderedCollection new.
	classesToDescription := IdentityDictionary new
]

{ #category : #private }
ODBClassManagerForSerialization >> loadFromStream: stream [ 
	| n classDescription |
	n := stream getPositiveInteger.
	n > 10000 ifTrue: [self error: '[Deserializer] Number of classes is too big'].
	idToClassDescription := OrderedCollection new.
	1 to: n
		do: 
			[:i | 
			classDescription := ODBSerializer classDescriptionFrom: stream.
			classDescription classID: i.
			idToClassDescription add: classDescription]
]

{ #category : #public }
ODBClassManagerForSerialization >> register: aClass [ 
	| classDescription |
	^classesToDescription at: aClass
		ifAbsentPut: 
			[classDescription := ODBSerializer classDescriptionFor: aClass.
			idToClassDescription add: classDescription.
			classDescription classID: idToClassDescription size.
			classDescription]
]

{ #category : #private }
ODBClassManagerForSerialization >> saveOnStream: stream [ 
	stream putPositiveInteger: idToClassDescription size.
	idToClassDescription do: [:each | each saveOnStream: stream]
]
