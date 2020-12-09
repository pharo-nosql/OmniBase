Class {
	#name : #ODBSerializedDBObjectWithoutReferences,
	#superclass : #ODBDatabaseObject,
	#category : 'OmniBase'
}

{ #category : #defining }
ODBSerializedDBObjectWithoutReferences class >> classID [
        "Answer database object classID."

    ^3
]

{ #category : #public }
ODBSerializedDBObjectWithoutReferences class >> hasBytes [
	"Answer <true> if the object stores its contents as bytes."

	^true
]

{ #category : #public }
ODBSerializedDBObjectWithoutReferences >> garbageCollectOn: anODBGarbageCollector [ 
	objectHolder container 
		addByteStorageRequest: (ODBGarbageCollectorRequest new objectHolder: objectHolder
				bytes: objectHolder loadBytes)
]

{ #category : #'public/transaction processing' }
ODBSerializedDBObjectWithoutReferences >> makeTransactionObject: aTransaction [

	| mStream bytes |
	bytes := objectHolder loadBytes.
	mStream := ODBMemoryReadStream new createOn: bytes.
	^ODBSerializedObject new
		setObjectHolder: objectHolder
		dataBaseObject: (ODBDeserializer new
						deserializeFrom: mStream
						referenceManager: nil
						transaction: aTransaction)
		transaction: aTransaction
]
