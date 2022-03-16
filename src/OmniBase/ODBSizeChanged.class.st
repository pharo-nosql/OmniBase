Class {
	#name : #ODBSizeChanged,
	#superclass : #ODBChange,
	#instVars : [
		'deltaSize'
	],
	#category : #'OmniBase-Events'
}

{ #category : #'as yet unclassified' }
ODBSizeChanged class >> changeClassID [
        "Answer unique class ID used for storing changes into 
        transaction file or <nil> if change does not need to be stored."

    ^4
]

{ #category : #'transaction processing' }
ODBSizeChanged >> commit [

    transaction := transactionObject transaction.
    transactionObject dataBaseObject iterator
        updateSizeAt: transaction versionNumber
        oldHolders: transaction oldHolders
        deltaSize: deltaSize
]

{ #category : #accessing }
ODBSizeChanged >> deltaSize: anInteger [

    deltaSize := anInteger
]

{ #category : #public }
ODBSizeChanged >> loadFromStream: aStream [

    objectID := ODBObjectID new loadFromStream: aStream.
    deltaSize := aStream getInteger
]

{ #category : #'transaction processing' }
ODBSizeChanged >> rollback [

    self transactionObject dataBaseObject iterator
        updateSizeAt: transaction versionNumber
        oldHolders: transaction oldHolders
        deltaSize: 0 - deltaSize
]

{ #category : #'load/store' }
ODBSizeChanged >> storeOnStream: aStream [

    objectID storeOnStream: aStream.
    aStream putInteger: deltaSize
]
