Class {
	#name : #ODBChange,
	#superclass : #Object,
	#instVars : [
		'objectID',
		'transactionObject',
		'transaction'
	],
	#category : 'OmniBase'
}

{ #category : #public }
ODBChange class >> changeClassID [
	"Answer unique class ID used for storing changes into 
	transaction file or <nil> if change does not need to be stored."

	^nil
]

{ #category : #public }
ODBChange class >> new [
	^super new initialize
]

{ #category : #'transaction processing' }
ODBChange >> commit [
        "Commit changes."
]

{ #category : #'transaction processing' }
ODBChange >> committed [
]

{ #category : #private }
ODBChange >> initialize [
	
]

{ #category : #public }
ODBChange >> loadFromStream: aStream [ 
	"Load receiver from aStream.  Implemented by subclasses."

	
]

{ #category : #accessing }
ODBChange >> objectID [

    ^objectID
]

{ #category : #'transaction processing' }
ODBChange >> rollback [
]

{ #category : #initialization }
ODBChange >> setObjectID: anObjectID transactionObject: aTransactionObject [

    objectID := anObjectID.
    transactionObject := aTransactionObject
]

{ #category : #'load/store' }
ODBChange >> storeOnStream: aStream [
        "Store receiver on aStream. 
        Implemented by subclasses."
]

{ #category : #accessing }
ODBChange >> transaction: aTransaction [

    transaction := aTransaction
]

{ #category : #public }
ODBChange >> transactionObject [
	^transactionObject isNil 
		ifFalse: [transactionObject]
		ifTrue: [transactionObject := transaction transactionObjectAt: objectID]
]

{ #category : #accessing }
ODBChange >> transactionObject: aTransactionObject [

    transactionObject := aTransactionObject
]
