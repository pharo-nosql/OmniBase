"
ODBLockRegistry
=============== 

ODBLockRegistry is a central instance that coordinates locks across transaction boundaries. When Omnibase was created it was developped on an ancient windows platform. On this platform a lock to a file was always exclusive so no other attempt to access that same file was successful. A big part of the implementation relies on that.

In the context *nix systems this did not work because the semanics for file locks are different. In *nix system a file lock only protects file access between different OS processes. Within the same OS process these locks are not doing anything because it is assumed that the program that runs in a process has better ways to coordinate concurrent access to files.   

ODBLockRegistry closes this gap by providing a central way of managing locks. A Omnibase is contained in a file directory. Concurrent access is therefor only to be managed within one of this directories. Therefor all instances of Omnibase receive the same instance of a lock registry. The Omnibase instance itself registers each lock it acquires in the registry and this way we can detect early lock conflicts
"
Class {
	#name : #ODBLockRegistry,
	#superclass : #Object,
	#instVars : [
		'path',
		'locks',
		'mutex'
	],
	#classInstVars : [
		'registries'
	],
	#category : #'OmniBase-Base'
}

{ #category : #'instance creation' }
ODBLockRegistry class >> forPath: aFileReference [ 
	| path |
	"locks are managed per omnibase path on disk. So every instance of 
	OmniBase that access the same path gets the same lock registry to 
	manage conflicts across transaction boundaries"
	path := aFileReference asAbsolute.
	^ registries 
		at: path 
		ifAbsentPut: [ 
			self new path: path  ]
]

{ #category : #'class initialization' }
ODBLockRegistry class >> initialize [ 
	self reset
]

{ #category : #accessing }
ODBLockRegistry class >> registeredPaths [
	^ self registries keys
]

{ #category : #accessing }
ODBLockRegistry class >> registries [ 
	^ registries
]

{ #category : #removing }
ODBLockRegistry class >> remove: aRegistry [ 
	^ registries 
		removeKey: aRegistry path 
		ifAbsent: [ ]
]

{ #category : #removing }
ODBLockRegistry class >> removePath: aString [ 
	^ registries removeKey: aString
]

{ #category : #'class initialization' }
ODBLockRegistry class >> reset [ 
	registries := Dictionary new
]

{ #category : #adding }
ODBLockRegistry >> addLock: aKeyLock [ 
	^ self 
		lockAt: aKeyLock lockRegistryKey 
		put: aKeyLock
]

{ #category : #removing }
ODBLockRegistry >> checkRemoval [
	locks isEmpty ifTrue: [ 
		self remove ]
]

{ #category : #testing }
ODBLockRegistry >> hasForeignLockFor: aTransactionObject transaction: aTransaction [
	"test if there is a lock that is present and that belongs to aTransaction"
	^ mutex critical: [
		locks 
			at: aTransactionObject lockRegistryKey 
			ifPresent: [ :lock | (lock transaction = aTransaction) not  ]
			ifAbsent: [ false ] ]
]

{ #category : #testing }
ODBLockRegistry >> hasKeyLockOn: aBtreeDictionary key: key [ 
	^ mutex critical: [
		locks includesKey: (aBtreeDictionary lockRegistryKeyAt: key) ]
]

{ #category : #initialization }
ODBLockRegistry >> initialize [ 
	super initialize.
	mutex := Semaphore forMutualExclusion.
	locks := Dictionary new
]

{ #category : #testing }
ODBLockRegistry >> isEmpty [
	^ locks isEmpty
]

{ #category : #testing }
ODBLockRegistry >> keyLockOn: aBtreeDictionary key: key ifAbsent: aBlock [
	^ mutex critical: [
		locks 
			at: (aBtreeDictionary lockRegistryKeyAt: key) 
			ifAbsent: aBlock ]
]

{ #category : #adding }
ODBLockRegistry >> lockAt: key put: aLock [ 
	mutex critical: [  
		locks 
			at: key
			ifPresent: [ :lock |
				^ lock isSameTransaction: aLock transaction ].
		locks 
			at: key 
			put: aLock ].
	^ true
]

{ #category : #accessing }
ODBLockRegistry >> path [

	^ path
]

{ #category : #accessing }
ODBLockRegistry >> path: aFileReference [ 
	path := aFileReference
]

{ #category : #removing }
ODBLockRegistry >> remove [
	self class remove: self
]

{ #category : #removing }
ODBLockRegistry >> removeLock: anODBObjectLock [ 
	mutex critical: [
		locks 
			removeKey: anODBObjectLock lockRegistryKey 
			ifAbsent: [  ] ].
	self checkRemoval
]

{ #category : #initialization }
ODBLockRegistry >> reset [
	locks := Dictionary new
]

{ #category : #accessing }
ODBLockRegistry >> size [ 
	^ locks size
]
