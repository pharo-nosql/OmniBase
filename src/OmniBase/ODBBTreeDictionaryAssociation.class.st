Class {
	#name : #ODBBTreeDictionaryAssociation,
	#superclass : #Object,
	#instVars : [
		'valueHolder',
		'key',
		'transaction'
	],
	#category : 'OmniBase'
}

{ #category : #accessing }
ODBBTreeDictionaryAssociation >> < aBTreeDictionaryAssociation [

    ^key odbIsLessThan: aBTreeDictionaryAssociation key
]

{ #category : #accessing }
ODBBTreeDictionaryAssociation >> key [

    ^key
]

{ #category : #accessing }
ODBBTreeDictionaryAssociation >> keyAsInteger [
		"Convert from BCD encoded byte array into integer."

	| value |
	value := 0.
	1 to: key size do: [:i | value := (value * 100) + ((key at: i) & 15) + (((key at: i) bitShift: -4) * 10) ].
	^value
]

{ #category : #initialization }
ODBBTreeDictionaryAssociation >> setKey: aKey value: aValue [

    key := aKey.
    valueHolder := aValue
]

{ #category : #initialization }
ODBBTreeDictionaryAssociation >> setTransaction: aTransaction key: aKey value: aValue [

    transaction := aTransaction.
    key := aKey.
    valueHolder := aValue
]

{ #category : #accessing }
ODBBTreeDictionaryAssociation >> value [

    ^valueHolder getObjectIn: transaction
]

{ #category : #private }
ODBBTreeDictionaryAssociation >> valueHolder [
        "Private - Answer BTree valueHolder."

    ^valueHolder
]

{ #category : #accessing }
ODBBTreeDictionaryAssociation >> valueObjectID [

    ^valueHolder objectID
]

{ #category : #public }
ODBBTreeDictionaryAssociation >> valueOrObjectID [
	| obj |
	(obj := valueHolder object) isNil ifFalse: [^obj].
	^valueHolder objectID
]
