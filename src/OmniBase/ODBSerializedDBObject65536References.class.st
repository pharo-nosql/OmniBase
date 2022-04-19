Class {
	#name : #ODBSerializedDBObject65536References,
	#superclass : #ODBSerializedDBObjectWithoutReferences,
	#category : #'OmniBase-Model'
}

{ #category : #defining }
ODBSerializedDBObject65536References class >> classID [
        "Answer database object classID."

    ^6
]

{ #category : #public }
ODBSerializedDBObject65536References >> makeTransactionObject: aTransaction [ 
	| mStream bytes referenceManager |
	bytes := objectHolder loadBytes.
	mStream := (ODBMemoryStreamWrapper on: bytes readStream)
				position: ((referenceManager := ODBReferenceManager new) createMax65536From: bytes).
	referenceManager transaction: aTransaction.
	^ODBSerializedObject new 
		setObjectHolder: objectHolder
		dataBaseObject: (ODBDeserializer new 
				deserializeFrom: (ODBEncodingStream on: mStream)
				referenceManager: referenceManager
				transaction: aTransaction)
		transaction: aTransaction
]

{ #category : #public }
ODBSerializedDBObject65536References >> referencesDo: aBlock [ 
	(ODBReferenceManager new)
		createMax65536From: objectHolder loadBytes;
		referencesDo: aBlock
]
