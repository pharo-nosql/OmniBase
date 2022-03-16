Class {
	#name : #ODBNewObjectVersion,
	#superclass : #ODBChange,
	#instVars : [
		'newVersion',
		'oldVersion'
	],
	#category : #'OmniBase-Events'
}

{ #category : #'as yet unclassified' }
ODBNewObjectVersion class >> changeClassID [
        "Answer unique class ID used for storing changes into 
        transaction file or <nil> if change does not need to be stored."

    ^1
]

{ #category : #'transaction processing' }
ODBNewObjectVersion >> commit [
        "Commit changes."

    newVersion store
]

{ #category : #'transaction processing' }
ODBNewObjectVersion >> committed [
        "Changes have been committed, update transaction object."

    transactionObject
        setObjectHolder: newVersion;
        objectCommitted
]

{ #category : #public }
ODBNewObjectVersion >> loadFromStream: aStream [

    objectID := ODBObjectID new loadFromStream: aStream.
    oldVersion := ODBObjectHolder new loadFromStream: aStream.
    newVersion := ODBObjectHolder new loadFromStream: aStream.
]

{ #category : #'public/accessing' }
ODBNewObjectVersion >> newVersion [

    ^newVersion
]

{ #category : #'public/accessing' }
ODBNewObjectVersion >> newVersion: anObjectHolder [

    newVersion := anObjectHolder
]

{ #category : #'public/accessing' }
ODBNewObjectVersion >> oldVersion [

    ^oldVersion
]

{ #category : #'public/accessing' }
ODBNewObjectVersion >> oldVersion: anObjectHolder [

    oldVersion := anObjectHolder
]

{ #category : #'transaction processing' }
ODBNewObjectVersion >> rollback [

	"Rollback changes."

	| currentHolder |
	(currentHolder := transaction objectHolderAt: objectID) ifNil: [ ^ self ].
	currentHolder versionNumber > newVersion versionNumber ifFalse: [ 
		currentHolder
			contents: oldVersion contents;
			store ]
]

{ #category : #'load/store' }
ODBNewObjectVersion >> storeOnStream: aStream [

	objectID storeOnStream: aStream.
	oldVersion storeOnStream: aStream.
	newVersion storeOnStream: aStream
]
