Class {
	#name : #ODBLockRegistry,
	#superclass : #Object,
	#instVars : [
		'registry',
		'mutex'
	],
	#category : #OmniBase
}

{ #category : #adding }
ODBLockRegistry >> addLock: anODBObjectLock [ 
	mutex critical: [  
		registry 
			at: anODBObjectLock objectID 
			ifPresent: [ :lock | 
				(lock transaction == anODBObjectLock transaction) ifFalse: [ 
					Error signal: 'locked by another transaction' ] ].
		registry 
			at: anODBObjectLock objectID 
			put: anODBObjectLock ]
]

{ #category : #testing }
ODBLockRegistry >> hasLockForObjectID: anODBObjectID [ 
	^ registry includesKey: anODBObjectID 
]

{ #category : #initialization }
ODBLockRegistry >> initialize [ 
	super initialize.
	registry := WeakValueDictionary new.
	mutex := Semaphore forMutualExclusion 
]

{ #category : #accessing }
ODBLockRegistry >> lockAt: anODBObjectID [ 
	^ registry at: anODBObjectID 
]

{ #category : #removing }
ODBLockRegistry >> removeLockForObjectID: anODBObjectID [ 
	
	^ mutex critical: [ registry removeKey: anODBObjectID ifAbsent: [  ] ]
]

{ #category : #removing }
ODBLockRegistry >> removeLocksForTransaction: anODBLocalTransaction [ 
	| removed |
	mutex critical: [ 
		removed := OrderedCollection new.
		registry copy keysAndValuesDo: [ :key :value |
			(value transaction = anODBLocalTransaction) ifTrue: [ 
				removed add: (registry removeKey: key) ] ].
		^ removed ]
]
