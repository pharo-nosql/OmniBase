Class {
	#name : #ODBDBBTreeIntegerIndexDictionary,
	#superclass : #ODBDBBTreeIndexDictionary,
	#category : 'OmniBase'
}

{ #category : #public }
ODBDBBTreeIntegerIndexDictionary class >> classID [
	"Answer database object classID."

	^70
]

{ #category : #public }
ODBDBBTreeIntegerIndexDictionary >> makeTransactionObject: aTransaction [ 
	iterator version = aTransaction versionDescriptor 
		ifFalse: 
			[iterator
				clearSearchCache;
				version: aTransaction versionDescriptor].
	^(ODBBTreeIntegerIndexDictionary new)
		setObjectHolder: objectHolder
			dataBaseObject: self
			transaction: aTransaction;
		keySize: iterator keyLength
]
