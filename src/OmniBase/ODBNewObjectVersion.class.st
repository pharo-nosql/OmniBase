Class {
	#name : #ODBNewObjectVersion,
	#superclass : #ODBChange,
	#instVars : [
		'newVersion',
		'oldVersion'
	],
	#category : 'OmniBase'
}

{ #category : #'as yet unclassified' }
ODBNewObjectVersion class >> changeClassID [
        "Answer unique class ID used for storing changes into 
        transaction file or <nil> if change does not need to be stored."

    ^1
]

{ #category : #'public/transaction processing' }
ODBNewObjectVersion >> commit [
        "Commit changes."

    newVersion store
]

{ #category : #'public/transaction processing' }
ODBNewObjectVersion >> committed [
        "Changes have been committed, update transaction object."

    transactionObject
        setObjectHolder: newVersion;
        objectCommitted
]

{ #category : #'public/load/store' }
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

{ #category : #public }
ODBNewObjectVersion >> rollback [
	"Rollback changes."

	| currentHolder |
	(currentHolder := transaction objectHolderAt: objectID) isNil ifTrue: [^self].
	currentHolder versionNumber > newVersion versionNumber 
		ifFalse: 
			[currentHolder
				contents: oldVersion contents;
				store]
]

{ #category : #'public/load/store' }
ODBNewObjectVersion >> storeOnStream: aStream [

        objectID storeOnStream: aStream.
        oldVersion storeOnStream: aStream.
        newVersion storeOnStream: aStream
]
