Class {
	#name : #ODBDBBTreeIdentityDictionary,
	#superclass : #ODBDBBTreeDictionary,
	#category : 'OmniBase'
}

{ #category : #public }
ODBDBBTreeIdentityDictionary class >> classID [
	"Answer database object classID."

	^68
]

{ #category : #public }
ODBDBBTreeIdentityDictionary >> makeTransactionObject: aTransaction [ 
	iterator version = aTransaction versionDescriptor 
		ifFalse: 
			[iterator
				clearSearchCache;
				version: aTransaction versionDescriptor].
	^(ODBBTreeIdentityDictionary new)
		setObjectHolder: objectHolder
			dataBaseObject: self
			transaction: aTransaction;
		keySize: iterator keyLength
]

{ #category : #public }
ODBDBBTreeIdentityDictionary >> referencesDo: aBlock [ 
	"A key is a persistent object and a value is a persistent object.
	Therefore we need to iterate over both."

	| valueHolder association |
	iterator critical: [association := iterator getFirst].
	[association isNil] whileFalse: 
			[(valueHolder := ODBValueHolder createOn: association value) isRemoved 
				ifFalse: 
					[aBlock value: (ODBObjectID new fromBytes: association key at: 1).
					aBlock value: valueHolder objectID].
			iterator critical: 
					[association := iterator
								goTo: association key;
								getNext]]
]
