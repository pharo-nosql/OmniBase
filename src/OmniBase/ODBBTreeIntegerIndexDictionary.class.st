Class {
	#name : #ODBBTreeIntegerIndexDictionary,
	#superclass : #ODBBTreeIndexDictionary,
	#category : #'OmniBase-Transaction'
}

{ #category : #'instance creation' }
ODBBTreeIntegerIndexDictionary class >> new [
	^super new keySize: 4
]

{ #category : #private }
ODBBTreeIntegerIndexDictionary >> bytesFromKey: anInteger [ 
	^((ByteArray new: 4) odbLongAt: 1 put: anInteger) reverse
]

{ #category : #private }
ODBBTreeIntegerIndexDictionary >> databaseObjectClass [
	^ODBDBBTreeIntegerIndexDictionary
]

{ #category : #initialization }
ODBBTreeIntegerIndexDictionary >> initialize [

	super initialize.
	keySize := 4
]

{ #category : #private }
ODBBTreeIntegerIndexDictionary >> keyFromBytes: aByteArray [ 
	^aByteArray reverse odbLongAt: 1
]
