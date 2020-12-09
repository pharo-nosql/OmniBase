Class {
	#name : #ODBGlobalLockedTransaction,
	#superclass : #ODBLocalTransaction,
	#category : 'OmniBase'
}

{ #category : #private }
ODBGlobalLockedTransaction >> addLock: aLock [ 
	"Private - Add aLock to receiver."

	OmniBase signalError: 'Global transaction should not set locks'
]

{ #category : #public }
ODBGlobalLockedTransaction >> isGlobalLocked [
	"Answer <true> if transaction was started in a global locked database session."

	^true
]

{ #category : #private }
ODBGlobalLockedTransaction >> removeLock: aLock [ 
	"Private - Remove aLock from receiver."

	OmniBase signalError: 'Global transaction should not set locks'
]
