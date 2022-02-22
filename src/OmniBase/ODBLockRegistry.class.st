Class {
	#name : #ODBLockRegistry,
	#superclass : #Object,
	#instVars : [
		'path',
		'locks'
	],
	#classInstVars : [
		'registries'
	],
	#category : #'OmniBase-Base'
}

{ #category : #'as yet unclassified' }
ODBLockRegistry class >> forPath: aString [ 
	| path |
	path := aString asFileReference asAbsolute.
	^ registries 
		at: path 
		ifAbsentPut: [ 
			self new path: path  ] 
]

{ #category : #initialization }
ODBLockRegistry class >> initialize [ 
	registries := WeakValueDictionary new
]

{ #category : #'as yet unclassified' }
ODBLockRegistry class >> registeredPaths [
	^ self registries keys
]

{ #category : #accessing }
ODBLockRegistry class >> registries [ 
	^ registries 
]

{ #category : #adding }
ODBLockRegistry >> addLock: anODBObjectLock [ 
	locks 
		at: anODBObjectLock objectID 
		put: anODBObjectLock 
]

{ #category : #testing }
ODBLockRegistry >> hasLockFor: anODBObjectID [ 
	^ locks includesKey: anODBObjectID 
]

{ #category : #initialization }
ODBLockRegistry >> initialize [ 
	super initialize.
	locks := Dictionary new
]

{ #category : #testing }
ODBLockRegistry >> isEmpty [
	^ locks isEmpty
]

{ #category : #accessing }
ODBLockRegistry >> locks [
	^ locks
]

{ #category : #accessing }
ODBLockRegistry >> path: aFileReference [ 
	path := aFileReference 
]

{ #category : #removing }
ODBLockRegistry >> remove [
	
]

{ #category : #removing }
ODBLockRegistry >> removeLock: anODBObjectLock [ 
	locks 
		removeKey: anODBObjectLock objectID 
		ifAbsent: [  ]
]

{ #category : #initialization }
ODBLockRegistry >> reset [
	locks removeAll
]

{ #category : #accessing }
ODBLockRegistry >> size [ 
	^ locks size
]
