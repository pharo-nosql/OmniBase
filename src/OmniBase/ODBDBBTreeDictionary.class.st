Class {
	#name : #ODBDBBTreeDictionary,
	#superclass : #ODBDBBTreeIndexDictionary,
	#category : 'OmniBase'
}

{ #category : #defining }
ODBDBBTreeDictionary class >> classID [
        "Answer database object classID."

    ^65
]

{ #category : #public }
ODBDBBTreeDictionary >> garbageCollectOn: anODBGarbageCollector [ 
	anODBGarbageCollector reorganizeDictionaries ifTrue: [self reorganizeBTree]
]

{ #category : #public }
ODBDBBTreeDictionary >> makeTransactionObject: aTransaction [ 
	iterator version = aTransaction versionDescriptor 
		ifFalse: 
			[iterator
				clearSearchCache;
				version: aTransaction versionDescriptor].
	^(ODBBTreeDictionary new)
		setObjectHolder: objectHolder
			dataBaseObject: self
			transaction: aTransaction;
		keySize: iterator keyLength
]

{ #category : #public }
ODBDBBTreeDictionary >> referencesDo: aBlock [ 
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

{ #category : #public }
ODBDBBTreeDictionary >> unlockKey: aKey with: lockID [ 
	| result |
	iterator critical: 
			[result := iterator
						goTo: aKey;
						unlockCurrentWith: lockID].
	^result
]
