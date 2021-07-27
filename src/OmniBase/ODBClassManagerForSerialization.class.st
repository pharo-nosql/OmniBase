Class {
	#name : #ODBClassManagerForSerialization,
	#superclass : #Object,
	#instVars : [
		'classesToDescription',
		'idToClassDescription'
	],
	#category : #'OmniBase-Base'
}

{ #category : #public }
ODBClassManagerForSerialization >> classDescriptionAt: anInteger [ 
	^idToClassDescription at: anInteger
		ifAbsent: [self error: '[Deserializer] Class description not found']
]

{ #category : #public }
ODBClassManagerForSerialization >> classDescriptionFor: aClass [

    ^ODBClassDescription new createFor: aClass
]

{ #category : #public }
ODBClassManagerForSerialization >> classDescriptionFrom: aStream [ 
	^ ODBClassDescription new loadFromStream: aStream
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
			classDescription := self classDescriptionFrom: stream.
			classDescription classID: i.
			idToClassDescription add: classDescription]
]

{ #category : #public }
ODBClassManagerForSerialization >> register: aClass [ 
	| classDescription |
	^classesToDescription at: aClass
		ifAbsentPut: 
			[classDescription := self classDescriptionFor: aClass.
			idToClassDescription add: classDescription.
			classDescription classID: idToClassDescription size.
			classDescription]
]

{ #category : #private }
ODBClassManagerForSerialization >> saveOnStream: stream [ 
	stream putPositiveInteger: idToClassDescription size.
	idToClassDescription do: [:each | each saveOnStream: stream]
]
