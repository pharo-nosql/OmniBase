Class {
	#name : #OmniBase,
	#superclass : #Object,
	#instVars : [
		'rootDir',
		'objectManager',
		'classManager',
		'clientManager',
		'transactionManager',
		'lockRegistry'
	],
	#classInstVars : [
		'currentTransaction',
		'processToTransactionDict',
		'processToTransactionMutex',
		'sessions'
	],
	#category : #'OmniBase-Base'
}

{ #category : #private }
OmniBase class >> add: anOmniBase [
		"Private - Registers an opened database session."

	sessions isNil ifTrue: [sessions := OrderedCollection new].
	sessions add: anOmniBase.
]

{ #category : #accessing }
OmniBase class >> allSessions [
		"Answers a collection of all opened database sessions."

	^sessions
]

{ #category : #public }
OmniBase class >> checkpoint [
	"Commit all changes in persistent objects to the database
	and leave all locks set. Current transaction can still be used
	to change more objects."

	self currentTransaction checkpoint
]

{ #category : #public }
OmniBase class >> closeAll [
	"Closes all opened database sessions. Do not use this method if you're using
	the Source Tracking System for development since it will also close its connection
	to the source code repository."

	sessions isNil ifTrue: [^false].
	sessions copy 
		do: [:each | [each close] on: Error do: [:er | sessions remove: each ifAbsent: []]]
]

{ #category : #public }
OmniBase class >> commit [
	"Commit all changes in persistent objects to the database
	and release all locks. Current transaction can not be used
	anymore."

	self currentTransaction commit
]

{ #category : #public }
OmniBase class >> confirmationMessage: aString [ 
	^self confirm: aString
]

{ #category : #public }
OmniBase class >> createOn: dirName [ 
	"Creates new database on a given directory pathname."

	^self new createOn: dirName
]

{ #category : #'transaction management' }
OmniBase class >> current [
		"Answers the database session of the current active transaction."

	^self currentTransaction environment
]

{ #category : #public }
OmniBase class >> currentTransaction [
	| transaction |
	transaction := currentTransaction.
	processToTransactionMutex critical: 
			[transaction := processToTransactionDict at: Processor activeProcess
						ifAbsent: [transaction]].
	transaction isNil ifFalse: [^transaction].
	self signalError: 'No transaction is active'
]

{ #category : #'transaction management' }
OmniBase class >> currentTransaction: anODBLocalTransaction [

	currentTransaction := anODBLocalTransaction
]

{ #category : #'transaction management' }
OmniBase class >> currentTransactionOrNil [
	| transaction |
	transaction := currentTransaction.
	processToTransactionMutex critical: 
			[transaction := processToTransactionDict at: Processor activeProcess
						ifAbsent: [transaction]].
	^transaction
]

{ #category : #handling }
OmniBase class >> getCurrentAndSet: anOmniBaseTransaction for: aProcess [ 
	"Private - Associaties anOmniBaseTransaction with aProcess.
	Answer previous active transaction in case transactions are nested."

	| previousTxn |
	processToTransactionMutex critical: 
			[previousTxn := processToTransactionDict at: aProcess ifAbsent: [].
			processToTransactionDict at: aProcess put: anOmniBaseTransaction].
	^previousTxn
]

{ #category : #'class initialization' }
OmniBase class >> initialize [
	processToTransactionMutex isNil 
		ifTrue: 
			[processToTransactionDict := IdentityDictionary new.
			processToTransactionMutex := Semaphore forMutualExclusion]
]

{ #category : #'instance creation' }
OmniBase class >> new [
	self initialize.
	^super new
]

{ #category : #public }
OmniBase class >> newBTreeDictionary: keySize [ 
	"Factory method - create a new instance of a persistent B-tree dictionary.
	This kind of persistent dictionary is using a file system b-tree below to store dictionary associations for quick access.
	A b-tree persistent dictionary can store any object that implements #asBtreeKeyOfSize: as key, and any persistent object as its value."

	^ODBBTreeDictionary createWithKeyLength: keySize
]

{ #category : #public }
OmniBase class >> newBTreeIdentityDictionary [
	"Factory method - create a new instance of a persistent B-tree identity dictionary.
	This kind of persistent dictionary is using a file system b-tree below to store dictionary associations for quick access.
	A b-tree persistent identity dictionary can store only persistent objects or nil as keys and persistent objects or nil as value."

	^ODBBTreeIdentityDictionary new
]

{ #category : #creating }
OmniBase class >> newBTreeIndexDictionary: keySize [

	^ODBBTreeIndexDictionary createWithKeyLength: keySize
]

{ #category : #public }
OmniBase class >> newPersistentDictionary [
	"Create new persistent dictionary. All dictionary keys will be 
	stored together with the dictionary if not already persistent. All
	dictionary values will be stored separately and will be made
	persistent each with its own object ID."

	| dict |
	dict := ODBPersistentDictionary new.
	self currentTransactionOrNil notNil ifTrue: [dict makePersistent].
	^dict
]

{ #category : #public }
OmniBase class >> objectAt: anODBObjectID [ 
	"Answer a persistent object with a given object id. The object will be fetched right away 
	without instantiating a proxy object first. Answer <nil> if object id is nonexistent i.e. 
	there is no persistent object with such oid."

	^self currentTransaction objectAt: anODBObjectID
]

{ #category : #creating }
OmniBase class >> openOn: dirName [

	^self new openOn: dirName
]

{ #category : #private }
OmniBase class >> remove: anOmniBase [ 
	"Private - Deregisters an opened database session."

	sessions isNil ifTrue: [^self].
	sessions remove: anOmniBase ifAbsent: []
]

{ #category : #handling }
OmniBase class >> removeFor: aProcess [ 
	"Private - Disassociaties a transaction from aProcess."

	processToTransactionMutex 
		critical: [processToTransactionDict removeKey: aProcess ifAbsent: []]
]

{ #category : #public }
OmniBase class >> reset [
	"Use wisely. Makes a complete reset of all related to this persistance clients."
	self closeAll.
	processToTransactionDict := IdentityDictionary new.
	processToTransactionMutex := Semaphore forMutualExclusion.
	currentTransaction := nil.
	
]

{ #category : #public }
OmniBase class >> rollback [
	"Release all locks set in the current transaction and forget 
	all changes done on persistent objects."

	self currentTransaction abort
]

{ #category : #public }
OmniBase class >> root [
	"Answer the database root object. Root object represents an entry point into the database.
	Only objects referenced from the root object will remain after the garbage collection is 
	performed on the database. By default the root object is a dictionary with persistent objects
	as its values. This can be changed if needed using message #root: on transaction."

	^self currentTransaction root
]

{ #category : #handling }
OmniBase class >> setTransaction: aTransaction for: aProcess [ 
	"Private - Associaties a transaction to aProcess."

	processToTransactionMutex 
		critical: [processToTransactionDict at: aProcess put: aTransaction]
]

{ #category : #private }
OmniBase class >> signalError: errorMessage [ 
	ODBError signal: errorMessage
]

{ #category : #public }
OmniBase class >> warningMessage: aString [ 
	self inform: aString
]

{ #category : #private }
OmniBase >> classManager [

	^ classManager ifNil: [ 
		classManager := self classManagerClass new ]
]

{ #category : #'as yet unclassified' }
OmniBase >> classManagerClass [ 

	^ ODBClassManager 
]

{ #category : #private }
OmniBase >> clientManager [

	^ clientManager ifNil: [ 
		clientManager := self clientManagerClass new ]
]

{ #category : #public }
OmniBase >> clientManagerClass [ 

	^ ODBClientManager
]

{ #category : #public }
OmniBase >> close [
	clientManager notNil 
		ifTrue: 
			[clientManager close.
			clientManager := nil].
	classManager notNil 
		ifTrue: 
			[classManager close.
			classManager := nil].
	objectManager notNil 
		ifTrue: 
			[objectManager close.
			objectManager := nil].
	transactionManager notNil 
		ifTrue: 
			[transactionManager close.
			transactionManager := nil].
	lockRegistry notNil 
		ifTrue: [ 
			lockRegistry checkRemoval.
			lockRegistry := nil ].
	self class remove: self
]

{ #category : #public }
OmniBase >> containerNamed: aName [
	 "Answer container with containerName or default container, if container is not found."

	^ objectManager containerNamed: aName
]

{ #category : #public }
OmniBase >> containerNamed: aName ifAbsent: aBlock [
	"Answers the container the receiver locates at aName or executes aBlock if not found."

	^ objectManager containerNamed: aName ifAbsent: aBlock 
]

{ #category : #public }
OmniBase >> createBackupOn: newDirectoryName [
	"Starts an on-line backup process and creates a backup copy
	of the receiver database.
	The database will be copied based on the current version of the data.
	The copy of the database will have its containers compacted with no old versions.
	The version counter will be reset to zero and b-trees will be reorganized to be up to 1 node full."

	OmniBaseArchiver new onlineBackup: self to: newDirectoryName
]

{ #category : #public }
OmniBase >> createOn: dirName [ 
	"Create new database. If a database already exists signal error."

	
	[rootDir := dirName.
	(ODBFileStream directoryExists: rootDir) 
		ifFalse: [ODBFileStream directoryCreate: rootDir].
	classManager := self classManager createOn: self.
	objectManager := self objectManager createOn: self.
	transactionManager := self transactionManager createOn: self.
	clientManager := self clientManager createOn: self.
	lockRegistry := ODBLockRegistry forPath: dirName.
	self opened.
	clientManager localClient makeRootObject] 
			ifCurtailed: [self close]
]

{ #category : #accessing }
OmniBase >> dirName [

    ^rootDir
]

{ #category : #accessing }
OmniBase >> existsContainerNamed: aString [
        "Answer <true> if container named aString exists."

    objectManager containerNamed: aString ifAbsent: [^false].
    ^true
]

{ #category : #public }
OmniBase >> freeDiskSpace [
	self odbToDo.
	^1024 * 1024 * 1024
]

{ #category : #public }
OmniBase >> garbageCollect [
	"Garbage collect the database.
	This will do the following:
		- remove all objects which are not referenced from the database root
		- compact all container files and remove old object versions
	B-tree dictionaries will not be compacted."

	(ODBGarbageCollector new)
		reorganizeDictionaries: false;
		reorganizeIndexSets: false;
		runOn: self
]

{ #category : #public }
OmniBase >> globalLock [
	"Lock database so that only one user can change objects in
	it. No locks will be made to objects stored in the database
	files while the database is globaly locked. Answer <true>
	if successfull or <false> if failed. Global write lock will
	fail if there are read-write transactions already running."

	clientManager removeDisconnectedClients.
	^clientManager localClient globalLock
]

{ #category : #public }
OmniBase >> globalUnlock [
	"Release global write lock set by the local client."

	^clientManager localClient globalUnlock
]

{ #category : #initialization }
OmniBase >> initialize [

    ODBDatabaseObject initialize
]

{ #category : #accessing }
OmniBase >> isGlobalLocked [

    ^self localClient isGlobalLocked
]

{ #category : #administration }
OmniBase >> localClient [

    ^clientManager localClient
]

{ #category : #accessing }
OmniBase >> lockRegistry [
	^ lockRegistry
]

{ #category : #accessing }
OmniBase >> newBTreeDictionary: keySize [

	^self class newBTreeDictionary: keySize
]

{ #category : #public }
OmniBase >> newBTreeIdentityDictionary [
	"Factory method - create a new instance of a persistent B-tree identity dictionary.
	This kind of persistent dictionary is using a file system b-tree below to store dictionary associations for quick access.
	A b-tree persistent identity dictionary can store only persistent objects or nil as keys and persistent objects or nil as value."

	^self class newBTreeIdentityDictionary
]

{ #category : #accessing }
OmniBase >> newBTreeIndexDictionary: keySize [

    ^self class newBTreeIndexDictionary: keySize
]

{ #category : #accessing }
OmniBase >> newContainer: aString [
        "Create new container named aString."

    ^objectManager containerNew: aString
]

{ #category : #accessing }
OmniBase >> newPersistentDictionary [

	^self class newPersistentDictionary
]

{ #category : #public }
OmniBase >> newReadOnlyTransaction [
	"Answer new read-only transaction. Read only transactions
	are here only to prevent user code from writing into the database.
	Read-only transaction are not meant to improve concurrency since
	multi-version concurrency control is used in OmniBase and therefore
	all transactions run as read-only transactions up to the point when the
	first object is locked."

	^clientManager localClient newReadOnlyTransaction
]

{ #category : #accessing }
OmniBase >> newTransaction [
    ^clientManager localClient newTransaction
]

{ #category : #public }
OmniBase >> numberOfClients [
	"Answer total number of client connections currently working with database.
	(this will answer how many times a database on a given directory has been opened)"

	| clients count |
	count := 0.
	clients := clientManager
				removeDisconnectedClients;
				clients.
	clients do: [:eachClient | eachClient isTerminated ifFalse: [count := count + 1]].
	clientManager closeForeignClients.
	^count
]

{ #category : #private }
OmniBase >> objectManager [

	^ objectManager ifNil: [ 
		objectManager := self objectManagerClass new ]
]

{ #category : #public }
OmniBase >> objectManagerClass [ 

	^ ODBObjectManager
]

{ #category : #private }
OmniBase >> odbObjectID [
	"Private - answer an object ID of the database connection instance.
	This is used when a persistent object is referencing current database connection.
	When deserialized it will set reference to the current database connection."

	^ODBObjectID containerID: 0 index: 4
]

{ #category : #public }
OmniBase >> openOn: dirName [ 
	"Open an already existing database environment. 
	Trigger an exception if failed."

	
	[rootDir := dirName.
	classManager := self classManager openOn: self.
	objectManager := self objectManager openOn: self.
	transactionManager := self transactionManager openOn: self.
	clientManager := self clientManager openOn: self.
	lockRegistry := ODBLockRegistry forPath: dirName.
	self opened] 
			ifCurtailed: [self close].
	self freeDiskSpace < 5242880 ifTrue: [OmniBase warningMessage: 'Low disk space !']
]

{ #category : #private }
OmniBase >> opened [
	"Private - Receiver has just been opened."

	self class add: self.
	
	[clientManager
		removeDisconnectedClients;
		closeForeignClients] on: Error
			do: [:er | #odbTODO]
]

{ #category : #public }
OmniBase >> printOn: aStream [

	super printOn: aStream.
	
	aStream nextPutAll: '(',self hash asString,')'
]

{ #category : #public }
OmniBase >> reorganize [
	"Reorganize database files.
	This will do the following:
		- remove all objects which are not referenced from the database root
		- compact all container files and remove old object versions
		- compact b-tree index files"

	(ODBGarbageCollector new)
		reorganizeDictionaries: true;
		reorganizeIndexSets: true;
		runOn: self
]

{ #category : #public }
OmniBase >> setUserDescription: aString [ 
	"Set user description.
	This string can be read by other database connections to identify who has opened a database."

	self localClient description: aString
]

{ #category : #private }
OmniBase >> transactionManager [

    ^ transactionManager ifNil: [ 
		transactionManager := self transactionManagerClass new ]
]

{ #category : #public }
OmniBase >> transactionManagerClass [ 
	^ ODBTransactionManager
]
