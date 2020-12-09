Class {
	#name : #ODBSerializedDBObject256References,
	#superclass : #ODBSerializedDBObjectWithoutReferences,
	#category : 'OmniBase'
}

{ #category : #'as yet unclassified' }
ODBSerializedDBObject256References class >> classID [
        "Answer database object classID."

    ^5
]

{ #category : #'public/transaction processing' }
ODBSerializedDBObject256References >> makeTransactionObject: aTransaction [

	| mStream bytes referenceManager |
	bytes := objectHolder loadBytes.
	mStream := ODBMemoryReadStream new
				createOn: bytes;
				position: ((referenceManager := ODBReferenceManager new) createMax256From: bytes).
	referenceManager transaction: aTransaction.
	^ODBSerializedObject new
		setObjectHolder: objectHolder
		dataBaseObject: (ODBDeserializer new
						deserializeFrom: mStream
						referenceManager: referenceManager
						transaction: aTransaction)
		transaction: aTransaction
]

{ #category : #public }
ODBSerializedDBObject256References >> referencesDo: aBlock [ 
	(ODBReferenceManager new)
		createMax256From: objectHolder loadBytes;
		referencesDo: aBlock
]
