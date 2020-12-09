Class {
	#name : #ODBDBBTreeMultiValueDictionary,
	#superclass : #ODBDBBTreeIndexDictionary,
	#category : 'OmniBase'
}

{ #category : #public }
ODBDBBTreeMultiValueDictionary class >> classID [
	"Answer database object classID."

	^69
]

{ #category : #public }
ODBDBBTreeMultiValueDictionary >> makeTransactionObject: aTransaction [ 
	iterator version = aTransaction versionDescriptor 
		ifFalse: 
			[iterator
				clearSearchCache;
				version: aTransaction versionDescriptor].
	^(ODBBTreeMultiValueDictionary new)
		setObjectHolder: objectHolder
			dataBaseObject: self
			transaction: aTransaction;
		keySize: iterator keyLength
]

{ #category : #public }
ODBDBBTreeMultiValueDictionary >> referencesDo: aBlock [ 
	| valueHolder association |
	iterator critical: [association := iterator getFirst].
	[association isNil] whileFalse: 
			[(valueHolder := ODBValueHolder createOn: association value) isRemoved 
				ifFalse: [aBlock value: valueHolder objectID].
			iterator critical: 
					[association := iterator
								goTo: association key;
								getNext]]
]
