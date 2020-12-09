Class {
	#name : #ODBRootObjectHolder,
	#superclass : #ODBTransactionObject,
	#instVars : [
		'changed'
	],
	#category : 'OmniBase'
}

{ #category : #public }
ODBRootObjectHolder >> commit: serializer [ 
	"Commit changes."

	| change newHolder |
	changed == true 
		ifTrue: 
			[newHolder := (holder makeNewVersion: transaction oldHolders)
						persistentClassID: ODBRootObjectDBHolder classID;
						versionNumber: transaction versionNumber;
						rootObjectID: (transaction getObjectID: dataBaseObject).
			change := (ODBNewObjectVersion new)
						setObjectID: holder objectID transactionObject: self;
						oldVersion: holder;
						newVersion: newHolder.
			transaction changesPackage add: change]
]

{ #category : #'transaction processing' }
ODBRootObjectHolder >> isChanged [
		"Answer <true> if object has been changed."

	^changed == true
]

{ #category : #public }
ODBRootObjectHolder >> objectCommitted [
	"Sent from change after it has committed."

	changed := false
]

{ #category : #public }
ODBRootObjectHolder >> objectLoaded [
	"Sent to transaction object when it has been loaded into transaction."

	dataBaseObject := transaction objectAt: dataBaseObject
]

{ #category : #accessing }
ODBRootObjectHolder >> rootObject [
        "Answer object represented by receiver."

    ^dataBaseObject
]

{ #category : #public }
ODBRootObjectHolder >> rootObject: anObject [ 
	"Set object represented by the receiver."

	changed := true.
	transaction makePersistent: anObject.
	dataBaseObject := anObject
]
