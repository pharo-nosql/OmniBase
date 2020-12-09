Class {
	#name : #ODBReadOnlyTransaction,
	#superclass : #ODBLocalTransaction,
	#category : 'OmniBase'
}

{ #category : #private }
ODBReadOnlyTransaction >> addLock: aLock [ 
	"Private - Add anODBLock to receiver."

	OmniBase signalError: 'Read-only transaction should not set locks'
]

{ #category : #public }
ODBReadOnlyTransaction >> checkpoint [
		"Do nothing."
]

{ #category : #public }
ODBReadOnlyTransaction >> commit [
		"Do nothing."

	self abort
]

{ #category : #public }
ODBReadOnlyTransaction >> isChanged [

	^false
]

{ #category : #public }
ODBReadOnlyTransaction >> isReadOnly [
		"Answer <true> if this is a read-only transaction."

	^true
]

{ #category : #public }
ODBReadOnlyTransaction >> lock: anObject [

	^true
]

{ #category : #public }
ODBReadOnlyTransaction >> makePersistent: anObject in: aContainerOrContainerName [
		"Do nothing."

	^anObject
]

{ #category : #public }
ODBReadOnlyTransaction >> markDirty: anObject [
		"Do nothing."
]

{ #category : #private }
ODBReadOnlyTransaction >> removeLock: aLock [ 
	"Private - Remove anODBLock from receiver."

	OmniBase signalError: 'Read-only transaction should not set locks'
]

{ #category : #public }
ODBReadOnlyTransaction >> store: anObject in: containerName ifLocked: aBlock [
		"Do nothing."

	^anObject
]

{ #category : #public }
ODBReadOnlyTransaction >> unlock: anObject [

	^true
]
