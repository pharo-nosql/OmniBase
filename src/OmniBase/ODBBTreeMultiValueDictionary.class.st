"
This class is not yet implemented.
"
Class {
	#name : #ODBBTreeMultiValueDictionary,
	#superclass : #ODBBTreeIndexDictionary,
	#instVars : [
		'deltaSize',
		'initialSize',
		'newObjects'
	],
	#category : #'OmniBase-Transaction'
}

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

{ #category : #initialization }
ODBBTreeMultiValueDictionary >> initialize [

	super initialize.
	initialSize := 0.
	deltaSize := 0
]

{ #category : #public }
ODBBTreeMultiValueDictionary >> valuesAt: aKey [

]
