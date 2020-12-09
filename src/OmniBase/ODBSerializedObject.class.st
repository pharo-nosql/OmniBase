Class {
	#name : #ODBSerializedObject,
	#superclass : #ODBTransactionObject,
	#instVars : [
		'changed'
	],
	#category : 'OmniBase'
}

{ #category : #public }
ODBSerializedObject >> commit: serializer [ 
	"Commit changes."

	| change bytes referenceManager newHolder classID |
	changed == true ifFalse: [^self].
	referenceManager := ODBReferenceManager new.
	bytes := ODBMemoryWriteStream new.
	serializer 
		serialize: dataBaseObject odbObject
		onStream: bytes
		referenceManager: referenceManager
		classManager: transaction environment classManager.
	bytes := referenceManager asBytesWith: bytes asByteArray.
	classID := referenceManager databaseObjectClassID.
	newHolder := (holder makeNewVersion: transaction oldHolders)
				persistentClassID: classID;
				versionNumber: transaction versionNumber.
	newHolder storeBytes: bytes.
	change := (ODBNewObjectVersion new)
				setObjectID: holder objectID transactionObject: self;
				oldVersion: holder;
				newVersion: newHolder.
	transaction changesPackage add: change
]

{ #category : #'public/transaction processing' }
ODBSerializedObject >> isChanged [
        "Answer <true> if object has been changed."

    ^changed == true
]

{ #category : #public }
ODBSerializedObject >> objectChanged [
	"This message is sent from transaction the first time it is marked as dirty."

	changed := true
]

{ #category : #public }
ODBSerializedObject >> objectCommitted [
	"Sent from change after it has committed."

	changed := false
]

{ #category : #'public/transaction processing' }
ODBSerializedObject >> objectLoaded [
                "Sent to transaction object when it is loaded into transaction."

	dataBaseObject odbLoadedIn: transaction.
]

{ #category : #'public/transaction processing' }
ODBSerializedObject >> objectStored [
		"Sent to transaction object when object was made persistent."

	changed := true.
	dataBaseObject odbMadePersistentIn: transaction.
]

{ #category : #public }
ODBSerializedObject >> value [
	"Answer object represented by receiver."

	^dataBaseObject
]

{ #category : #public }
ODBSerializedObject >> value: anObject [ 
	"Set the object represented by the receiver."

	dataBaseObject := anObject.
	changed := true
]
