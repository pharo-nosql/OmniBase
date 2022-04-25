Class {
	#name : #ODBTransactionObject,
	#superclass : #Object,
	#instVars : [
		'transaction',
		'lockObject',
		'holder',
		'dataBaseObject',
		'changed'
	],
	#category : #'OmniBase-Transaction'
}

{ #category : #testing }
ODBTransactionObject class >> isAbstract [
		
	^ self == ODBTransactionObject
]

{ #category : #accessing }
ODBTransactionObject >> dataBaseObject [

    ^dataBaseObject
]

{ #category : #testing }
ODBTransactionObject >> isChanged [
	^ self subclassResponsibility
]

{ #category : #'transaction processing' }
ODBTransactionObject >> isLocked [
        "Answer <true> if the receiver is localy locked."

    ^lockObject notNil
]

{ #category : #testing }
ODBTransactionObject >> isODBTransactionObject [

    ^true
]

{ #category : #public }
ODBTransactionObject >> lock [

	"Lock receiver."

	| lockID lockObj |
	lockObject ifNil: [ 
		(transaction hasForeignLockFor: self) ifTrue: [ ^ false ].
		(lockID := transaction lockID) ifNil: [ ^ false ].
		transaction isGlobalLocked ifTrue: [ ^ true ].
		lockObj := ODBObjectLock new.
		lockObj
			objectID: holder objectID;
			lockID: lockID.
		transaction addLock: lockObj.
		(holder lockWith: lockID) ifFalse: [ 
			transaction removeLock: lockObj.
			^ false ].
		lockObject := lockObj ].
	^ true
]

{ #category : #accessing }
ODBTransactionObject >> lockRegistryKey [
	^ self objectID lockRegistryKey
]

{ #category : #public }
ODBTransactionObject >> objectChanged [
	"This message is sent from transaction the first time it is marked as dirty."
]

{ #category : #public }
ODBTransactionObject >> objectCommitted [
	^ self subclassResponsibility
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

{ #category : #printing }
ODBTransactionObject >> printOn: aStream [ 
	super printOn: aStream.
	aStream << ' '.
	holder objectID printOn: aStream
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

	lockObject ifNotNil: [ 
		(holder unlockWith: lockObject lockID) ifFalse: [ ^ false ].
		transaction removeLock: lockObject.
		lockObject := nil ].
	^ true
]
