Class {
	#name : #ODBDBBTreeIndexDictionary,
	#superclass : #ODBDatabaseObject,
	#instVars : [
		'iterator'
	],
	#category : 'OmniBase'
}

{ #category : #defining }
ODBDBBTreeIndexDictionary class >> classID [
        "Answer database object classID."

    ^67
]

{ #category : #public }
ODBDBBTreeIndexDictionary class >> hasExternalFiles [
	"Answer <true> if the object stores its contents into external files."

	^true
]

{ #category : #public }
ODBDBBTreeIndexDictionary >> associationsDo: aBlock [ 
	| association |
	iterator critical: [association := iterator getFirst].
	[association isNil] whileFalse: 
			[aBlock value: (Association key: association key
						value: (ODBValueHolder createOn: association value)).
			iterator critical: 
					[association := iterator
								goTo: association key;
								getNext]]
]

{ #category : #public }
ODBDBBTreeIndexDictionary >> at: aKey ifAbsent: aBlock [ 
	| association |
	^(association := iterator goToAndGetCurrentAt: ((ByteArray new: iterator keyLength) 
						replaceFrom: 1
						to: (aKey size min: iterator keyLength)
						with: aKey
						startingAt: 1)) 
		isNil ifTrue: [aBlock value] ifFalse: [ODBValueHolder createOn: association value]
]

{ #category : #public }
ODBDBBTreeIndexDictionary >> at: aKey put: value [ 
	iterator goTo: aKey put: value contents
]

{ #category : #public }
ODBDBBTreeIndexDictionary >> close [
	iterator notNil 
		ifTrue: 
			[objectHolder container closeObjectFile: objectHolder fileID.
			iterator := nil]
]

{ #category : #public }
ODBDBBTreeIndexDictionary >> createBackupCopyIn: newContainer versionDescriptor: versionDescriptor oldHolders: oldHolders versionNumber: versionNumber [ 
	"Create a backup copy of receiver in a newContainer."

	| newIterator assoc size realSize valueHolder |
	newContainer onNewObjectFileDo: 
			[:index :fileName | 
			objectHolder fileID: index.
			newIterator := (ODBGcBTreeIterator new)
						keyLength: iterator keyLength;
						valueLength: ODBValueHolder sizeInBytes;
						createOn: fileName.
			size := iterator getSizeAt: versionDescriptor oldHolders: oldHolders.
			realSize := 0.
			
			[assoc := iterator getFirst.
			[assoc isNil] whileFalse: 
					[valueHolder := ODBValueHolder createOn: assoc value.
					[versionDescriptor versionOK: valueHolder versionNumber] 
						whileFalse: [valueHolder loadPreviousVersionFrom: oldHolders].
					valueHolder isRemoved 
						ifFalse: 
							[realSize := realSize + 1.
							valueHolder versionNumber: versionNumber.
							newIterator goTo: assoc key put: valueHolder contents].
					assoc := iterator getNext].
			"realSize = size ifFalse: [OmniBase warningMessage: 'Cached dictionary size does not match real size']."
			newIterator putSizeHolder: ((ODBSizeHolder new)
						dictionarySize: realSize;
						previousVersionPosition: 0;
						versionNumber: versionNumber;
						yourself).
			newIterator close] 
					ifCurtailed: [newIterator remove].
			iterator := nil]
]

{ #category : #public }
ODBDBBTreeIndexDictionary >> createOn: anObjectHolder keySize: anInteger [ 
	objectHolder := anObjectHolder.
	objectHolder container onNewObjectFileDo: 
			[:index :fileName | 
			objectHolder fileID: index.
			iterator := (ODBBTreeIterator new)
						keyLength: anInteger;
						valueLength: ODBValueHolder sizeInBytes;
						createOn: fileName]
]

{ #category : #public }
ODBDBBTreeIndexDictionary >> garbageCollectOn: anODBGarbageCollector [ 
	anODBGarbageCollector reorganizeIndexSets ifTrue: [self reorganizeBTree]
]

{ #category : #'public/accessing' }
ODBDBBTreeIndexDictionary >> iterator [

    ^iterator
]

{ #category : #public }
ODBDBBTreeIndexDictionary >> makeTransactionObject: aTransaction [ 
	iterator version = aTransaction versionDescriptor 
		ifFalse: 
			[iterator
				clearSearchCache;
				version: aTransaction versionDescriptor].
	^(ODBBTreeIndexDictionary new)
		setObjectHolder: objectHolder
			dataBaseObject: self
			transaction: aTransaction;
		keySize: iterator keyLength
]

{ #category : #public }
ODBDBBTreeIndexDictionary >> openOn: anObjectHolder [ 
	objectHolder := anObjectHolder.
	iterator := objectHolder container openObjectFile: objectHolder fileID
				ifAbsentPut: [:fileName | ODBBTreeIterator openOn: fileName]
]

{ #category : #public }
ODBDBBTreeIndexDictionary >> remove [
	iterator isNil 
		ifFalse: 
			[objectHolder container removeObjectFile: objectHolder fileID.
			iterator := nil]
]

{ #category : #public }
ODBDBBTreeIndexDictionary >> reorganizeBTree [
	"Reorganize B-Tree dictionary."

	| newIterator assoc oldIndex |
	objectHolder container onNewObjectFileDo: 
			[:index :fileName | 
			oldIndex := objectHolder fileID.
			objectHolder fileID: index.
			newIterator := (ODBGcBTreeIterator new)
						keyLength: iterator keyLength;
						valueLength: ODBValueHolder sizeInBytes;
						createOn: fileName.
			
			[newIterator putSizeHolder: iterator getSizeHolder.
			assoc := iterator getFirst.
			[assoc isNil] whileFalse: 
					[(ODBValueHolder createOn: assoc value) isRemoved 
						ifFalse: [newIterator goTo: assoc key put: assoc value].
					assoc := iterator getNext].
			newIterator close] 
					ifCurtailed: [newIterator remove].
			objectHolder store.
			iterator := nil].
	objectHolder container removeObjectFile: oldIndex
]

{ #category : #public }
ODBDBBTreeIndexDictionary >> valuesDo: aBlock [ 
	| association |
	iterator critical: [association := iterator getFirst].
	[association isNil] whileFalse: 
			[aBlock value: (ODBValueHolder createOn: association value).
			iterator critical: 
					[association := iterator
								goTo: association key;
								getNext]]
]
