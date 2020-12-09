Class {
	#name : #ODBTransactionObject,
	#superclass : #Object,
	#instVars : [
		'transaction',
		'lockObject',
		'holder',
		'dataBaseObject'
	],
	#category : 'OmniBase'
}

{ #category : #'instance creation' }
ODBTransactionObject class >> new [

    ^super new initialize
]

{ #category : #accessing }
ODBTransactionObject >> dataBaseObject [

    ^dataBaseObject
]

{ #category : #initialization }
ODBTransactionObject >> initialize [
]

{ #category : #'transaction processing' }
ODBTransactionObject >> isLocked [
        "Answer <true> if the receiver is localy locked."

    ^lockObject notNil
]

{ #category : #accessing }
ODBTransactionObject >> isODBTransactionObject [

    ^true
]

{ #category : #public }
ODBTransactionObject >> lock [
	"Lock receiver."

	| lockID lockObj |
	lockObject isNil 
		ifTrue: 
			[(lockID := transaction lockID) isNil ifTrue: [^false].
			transaction isGlobalLocked ifTrue: [^true].
			lockObj := ODBObjectLock new.
			lockObj
				objectID: holder objectID;
				lockID: lockID.
			transaction addLock: lockObj.
			(holder lockWith: lockID) 
				ifFalse: 
					[transaction removeLock: lockObj.
					^false].
			lockObject := lockObj].
	^true
]

{ #category : #public }
ODBTransactionObject >> objectChanged [
	"This message is sent from transaction the first time it is marked as dirty."

	
]

{ #category : #accessing }
ODBTransactionObject >> objectHolder [

    ^holder
]

{ #category : #accessing }
ODBTransactionObject >> objectID [

    ^holder objectID
]

{ #category : #public }
ODBTransactionObject >> objectLoaded [
	"Sent to transaction object when it is loaded into transaction."

	
]

{ #category : #public }
ODBTransactionObject >> objectStored [
	"Sent to transaction object when it is stored for the first time."

	
]

{ #category : #initialization }
ODBTransactionObject >> setDataBaseObject: anObject [

    dataBaseObject := anObject
]

{ #category : #initialization }
ODBTransactionObject >> setObjectHolder: anObjectHolder [

    holder := anObjectHolder
]

{ #category : #initialization }
ODBTransactionObject >> setObjectHolder: anObjectHolder dataBaseObject: aDatabaseObject transaction: aTransaction [

    holder := anObjectHolder.
    dataBaseObject := aDatabaseObject.
    transaction := aTransaction
]

{ #category : #initialization }
ODBTransactionObject >> setObjectHolder: anObjectHolder transaction: aTransaction [

    holder := anObjectHolder.
    transaction := aTransaction
]

{ #category : #accessing }
ODBTransactionObject >> transaction [

    ^transaction
]

{ #category : #public }
ODBTransactionObject >> unlock [
	"Unlock receiver."

	lockObject isNil 
		ifFalse: 
			[(holder unlockWith: lockObject lockID) ifFalse: [^false].
			transaction removeLock: lockObject.
			lockObject := nil].
	^true
]

{ #category : #accessing }
ODBTransactionObject >> value [
        "Answer object represented by receiver. Default <self>."
]
