Class {
	#name : #ODBBTreeMultiValueDictionary,
	#superclass : #ODBBTreeIndexDictionary,
	#instVars : [
		'deltaSize',
		'initialSize',
		'newObjects'
	],
	#category : 'OmniBase'
}

{ #category : #public }
ODBBTreeMultiValueDictionary >> COMMENT [
	"This class is not yet implemented."

	
]

{ #category : #public }
ODBBTreeMultiValueDictionary >> add: anAssociation [ 
"
	self atKey: anAssociation key put: anAssociation value.
	^anAssociation"
]

{ #category : #public }
ODBBTreeMultiValueDictionary >> at: aKey [ 
	^self valuesAt: aKey
]

{ #category : #public }
ODBBTreeMultiValueDictionary >> at: aKey put: anObject [ 
	^self atKey: aKey add: anObject
]

{ #category : #public }
ODBBTreeMultiValueDictionary >> atKey: aKey add: anObject [
]

{ #category : #private }
ODBBTreeMultiValueDictionary >> initialize [
	"Private - Initialize receiver."

	super initialize.
	initialSize := 0.
	deltaSize := 0
]

{ #category : #public }
ODBBTreeMultiValueDictionary >> valuesAt: aKey [

]
