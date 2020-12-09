Class {
	#name : #ODBSizeChanged,
	#superclass : #ODBChange,
	#instVars : [
		'deltaSize'
	],
	#category : 'OmniBase'
}

{ #category : #'as yet unclassified' }
ODBSizeChanged class >> changeClassID [
        "Answer unique class ID used for storing changes into 
        transaction file or <nil> if change does not need to be stored."

    ^4
]

{ #category : #'public/transaction processing' }
ODBSizeChanged >> commit [

    transaction := transactionObject transaction.
    transactionObject dataBaseObject iterator
        updateSizeAt: transaction versionNumber
        oldHolders: transaction oldHolders
        deltaSize: deltaSize
]

{ #category : #'public/accessing' }
ODBSizeChanged >> deltaSize: anInteger [

    deltaSize := anInteger
]

{ #category : #'public/load/store' }
ODBSizeChanged >> loadFromStream: aStream [

    objectID := ODBObjectID new loadFromStream: aStream.
    deltaSize := aStream getInteger
]

{ #category : #'public/transaction processing' }
ODBSizeChanged >> rollback [

    self transactionObject dataBaseObject iterator
        updateSizeAt: transaction versionNumber
        oldHolders: transaction oldHolders
        deltaSize: 0 - deltaSize
]

{ #category : #'public/load/store' }
ODBSizeChanged >> storeOnStream: aStream [

    objectID storeOnStream: aStream.
    aStream putInteger: deltaSize
]
