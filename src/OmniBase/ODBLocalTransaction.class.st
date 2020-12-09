Class {
	#name : #ODBLocalTransaction,
	#superclass : #ODBTransaction,
	#instVars : [
		'application',
		'changesPackage',
		'inconsistent',
		'newObjects'
	],
	#category : 'OmniBase'
}

{ #category : #private }
ODBLocalTransaction >> addLock: aLock [
        "Private - Add aLock to receiver."

    locks add: aLock
]

{ #category : #private }
ODBLocalTransaction >> addLoggedLock: aLock [ 
	"Private - Add aLock to receiver and store it to transaction file."

	locks add: aLock.
	transactionFile lockAdd: aLock
]

{ #category : #public }
ODBLocalTransaction >> application [
	^application
]

{ #category : #public }
ODBLocalTransaction >> application: anObject [ 
	"Set application object for the transaction.
	This is just a value holder that can be used by the end user.
	Setting application has no effect in OmniBase."

	application := anObject
]

{ #category : #public }
ODBLocalTransaction >> becomeInconsistent [
	"Mark that transaction changes are inconsistent. 
	If transaction is inconsistent, it can not be committed! "

	inconsistent := true
]

{ #category : #private }
ODBLocalTransaction >> changesPackage [
	^changesPackage
]

{ #category : #public }
ODBLocalTransaction >> checkpoint [
	"Checkpoint transaction i.e. write all persistent objects that are marked as dirty or new into database.
	Only changes are written into the database. This is an atomic operation which will either complete successfully
	or fail completely with no changes whatsoever written into the database. After writing changes all locks on already
	existing object will still be set. Objects that were new, had no locks set and are thus not locked. Transaction can
	be checkpointed more than once. As seen below the whole process of writing changes into the database (files)
	is executed using a semaphore therefore only one transaction per database session can write its changes at a time."

	self isInconsistent ifTrue: [OmniBase signalError: 'Transaction is inconsistent'].
	transactionManager ifNil:[ODBTransactionCanNotCommit signal].
	
	transactionManager critical: 
			[[self prepare] ifCurtailed: 
					[self becomeInconsistent.
					transactionManager transactionCommitEnd: self].
			[changesPackage commit] ifCurtailed: 
					[self
						becomeInconsistent;
						basicAbort]].
	self committed
]

{ #category : #public }
ODBLocalTransaction >> commit [

	"Transcript cr; show: 'committing t: ', self hash asString,' p: ',Processor activeProcess hash asString."
	
	self
		checkpoint;
		abort
]

{ #category : #private }
ODBLocalTransaction >> committed [
        "Private - Transaction has just been committed."

    "End of transaction"
    transactionFile recovery: nil.
    transactionManager transactionCommitEnd: self.
    "Update transaction objects"        
    changesPackage committed.
    changesPackage := nil.
]

{ #category : #initialization }
ODBLocalTransaction >> initialize [
        "Private - Initialize receiver."

    super initialize.
    newObjects := Array new: 16
]

{ #category : #public }
ODBLocalTransaction >> isChanged [
	"Answer true if changes were made to objects in this transaction."

	objectIndex do: [:transactionObject | transactionObject isChanged ifTrue: [^true]].
	^false
]

{ #category : #public }
ODBLocalTransaction >> isInconsistent [
	"Answer true if transaction changes are inconsistent. 
	If transaction is inconsistent, it can not be committed."

	^inconsistent == true
]

{ #category : #public }
ODBLocalTransaction >> isPersistent: anObject [
	"Answers true if anObject is persistent, false otherwise."
	
	^ (self getTransactionObject: anObject ifAbsent:[nil]) notNil
	
]

{ #category : #public }
ODBLocalTransaction >> lock: anObject [ 
	"Lock anObject."

	| transactionObject |
	transactionObject := self getTransactionObject: anObject ifAbsent: [^true].
	transactionObject objectID index == 0 ifTrue: [^true].
	^transactionObject lock
]

{ #category : #private }
ODBLocalTransaction >> lockID [
	"Private - Answer unique lock ID. Create transaction 
	file, if no locks have been set before. Answer <nil> 
	if database is globally locked by another user and no 
	locks can currently be set."

	locks isNil 
		ifTrue: 
			[(transactionFile := client newTransactionFileFor: self) isNil ifTrue: [^nil].
			locks := OrderedCollection new].
	^transactionFile transactionID
]

{ #category : #public }
ODBLocalTransaction >> locks [
	^ locks 
]

{ #category : #public }
ODBLocalTransaction >> makePersistent: anObject [ 
	^self makePersistent: anObject in: dbConnection objectManager defaultContainer
]

{ #category : #public }
ODBLocalTransaction >> makePersistent: anObject in: aContainerOrContainerName [ 
	"Store anObject into specified container if it is not stored yet, else do nothing.
	Answer anObject."

	| container |
	anObject odbObjectID isNil ifFalse: [^anObject].
	self getTransactionObject: anObject
		ifAbsent: 
			[(aContainerOrContainerName isKindOf: String)
				ifTrue: 
					[container := dbConnection objectManager containerNamed: aContainerOrContainerName
								ifAbsent: [OmniBase signalError: 'Container does not exist']]
				ifFalse: [container := aContainerOrContainerName].
			self storeNewObject: anObject inContainer: container].
	^anObject
]

{ #category : #public }
ODBLocalTransaction >> markDirty: anObject [ 
	"Mark anObject as dirty so that it will be written to the 
	database when message #commit is sent.
	Note: if an object is not loaded yet i.e. the message #markDirty is sent to an unresolved ODBReference the object will not be marked as dirty.
	Therefore send #markDirty after you've loaded and changed the object, not before, else use #odbResolve before sending #markDirty."

	| objectToStore transactionObject |
	cacheMutex isNil 
		ifTrue: 
			["transaction is already aborted"
			ODBTransactionAlreadyAborted signal: 'Transaction is already aborted.'].
	(objectToStore := anObject) odbObjectID isNil 
		ifFalse: 
			[anObject isODBReference ifFalse: [^self].
			anObject odbNotLoaded ifTrue: [^self].
			anObject odbTransaction == self ifFalse: [objectToStore := anObject odbResolve]].
	transactionObject := self getTransactionObject: objectToStore
				ifAbsent:[
					ODBNotPersistent signal: 'Object is not persistent or is a part of composite persistent object'].
	transactionObject objectID index = 0 ifTrue: [^true].
	transactionObject lock ifFalse: [^self signalLockingConflictAt: anObject].
	transactionObject objectChanged
]

{ #category : #private }
ODBLocalTransaction >> peekTransactionObjectAt: objectID [ 
	"Answer transaction object at objectID but do not cache it in transaction."

	| holder transactionObject |
	(transactionObject := self cachedTransactionObjectAt: objectID) isNil 
		ifFalse: [^transactionObject].
	(holder := dbConnection objectManager holderAt: objectID) == nil 
		ifTrue: [OmniBase signalError: 'Invalid object ID'].
	[versionDescriptor versionOK: holder versionNumber] 
		whileFalse: [holder loadPreviousVersionFrom: self oldHolders].
	transactionObject := holder getObject makeTransactionObject: self.
	^transactionObject objectLoaded
]

{ #category : #private }
ODBLocalTransaction >> prepare [
	"Private - Prepare for commit."

	| serializer coll holder array index allObjects lastSize notFirstPass |
	allObjects := IdentitySet new: objectIndex size.
	notFirstPass := false.
	"send #odbAboutToCommitIn: to every persistent object in cache"
	"if any object stores additional objects do it again for new objects"
	
	[lastSize := objectIndex size.
	objectIndex values do: 
			[:each | 
			(notFirstPass and: [allObjects includes: each]) 
				ifFalse: 
					[each odbAboutToCommitIn: self.
					allObjects add: each]].
	lastSize = objectIndex size] 
			whileFalse: [notFirstPass := true].
	cacheMutex critical: 
			["initialize object ID indexes for new objects & lock & store them"
			1 to: newObjects size
				do: 
					[:i | 
					(coll := newObjects at: i) isNil 
						ifFalse: 
							[array := Array new: coll size.
							index := 0.
							coll do: 
									[:each | 
									index := index + 1.
									holder := each objectHolder.
									array at: index put: holder].
							holder container initHolders: array.
							coll do: [:each | objects at: each objectHolder objectID put: each].
							newObjects at: i put: nil]].
			self lockID isNil 
				ifTrue: [OmniBase signalError: 'Database is globaly locked by another user'].
			"make reference map"
			serializer := ODBSerializer new.
			self transactionReferences 
				do: [:each | serializer addExternalReference: each key objectId: each value].
			objectIndex 
				keysAndValuesDo: [:key :value | serializer addExternalReference: key objectId: value objectID]].
	"get new version number"
	transactionManager transactionCommitBegin: self.
	transactionFile versionNumber: versionDescriptor versionNumber.
	"collect changes on transaction objects"
	changesPackage := ODBChangesPackage new.
	allObjects do: [:transactionObject | transactionObject commit: serializer].
	dbConnection objectManager flushContainers.
	self oldHolders flush.
	transactionFile recovery: changesPackage
]

{ #category : #public }
ODBLocalTransaction >> printOn: aStream [

	super printOn: aStream.
	
	aStream nextPutAll: '(',self hash asString,')'
]

{ #category : #private }
ODBLocalTransaction >> removeCachedObjectID: objectID [ 
	"Remove transaction object associated with objectID."

	objects isNil ifFalse: [cacheMutex critical: [objects removeKey: objectID]]
]

{ #category : #private }
ODBLocalTransaction >> removeLock: aLock [ 
	"Private - Remove aLock from collection of set locks."

	locks remove: aLock ifAbsent: []
]

{ #category : #private }
ODBLocalTransaction >> removeLoggedLock: aODBLock [ 
	"Private - Remove anODBLock from receiver and remove it from transaction file."

	locks remove: aODBLock ifAbsent: [].
	transactionFile lockRemove: aODBLock
]

{ #category : #public }
ODBLocalTransaction >> root: anObject [ 
	"Set the root object of the database."

	| rootObjectHolder rootOID |
	rootOID := ODBObjectID containerID: 1 index: 1.
	(rootObjectHolder := self objectAt: rootOID) isNil 
		ifTrue: 
			[rootObjectHolder := ODBRootObjectHolder new.
			self store: rootObjectHolder.
			cacheMutex critical: [objects at: rootOID put: rootObjectHolder]].
	rootObjectHolder rootObject: anObject
]

{ #category : #private }
ODBLocalTransaction >> signalLockingConflictAt: anObject [ 
	"Private - anObject could not have been locked. 
	Signal an error."

	| transactionObject |
	transactionObject := self getTransactionObject: anObject
				ifAbsent: [OmniBase signalError: 'Internal locking error'].
	transactionObject objectHolder oldVersion 
		ifTrue: 
			[ODBCannotLockObject signal: 'Object has already been changed in another transaction']
		ifFalse: [ODBCannotLockObject signal: 'Object is already locked in another transaction']
]

{ #category : #public }
ODBLocalTransaction >> start [
	"Start transaction. Transaction is read-only 
	until no objects are locked."

	transactionManager transactionStart: self
]

{ #category : #public }
ODBLocalTransaction >> startFrom: aTransaction [ 
	"Start transaction.
	Transaction is read-only until no objects are locked.
	Version descriptor from aTransaction is valid at start."

	versionDescriptor := aTransaction versionDescriptor copy
]

{ #category : #initialization }
ODBLocalTransaction >> startInVersion: aVersionDescriptor [

    versionDescriptor := aVersionDescriptor
]

{ #category : #public }
ODBLocalTransaction >> store: anObject [ 
	^self 
		store: anObject
		in: dbConnection objectManager defaultContainer
		ifLocked: [self signalLockingConflictAt: anObject]
]

{ #category : #public }
ODBLocalTransaction >> store: anObject ifLocked: aBlock [ 
	^self 
		store: anObject
		in: dbConnection objectManager defaultContainer
		ifLocked: aBlock
]

{ #category : #public }
ODBLocalTransaction >> store: anObject in: aContainerOrContainerName [ 
	^self 
		store: anObject
		in: aContainerOrContainerName
		ifLocked: [self signalLockingConflictAt: anObject]
]

{ #category : #public }
ODBLocalTransaction >> store: anObject in: anODBContainerOrString ifLocked: aBlock [ 
	"Store anObject into given container anODBContainerOrString which can be either a String (container name) or an ODBContainer.
	Evaluate aBlock if anObject can not be locked."

	| objectToStore transactionObject container |
	(objectToStore := anObject) odbObjectID isNil 
		ifFalse: 
			[anObject isODBReference ifFalse: [^self].
			anObject odbNotLoaded ifTrue: [^self].
			anObject odbTransaction == self ifFalse: [objectToStore := anObject odbResolve]].
	transactionObject := self getTransactionObject: objectToStore
				ifAbsent: 
					[anODBContainerOrString class == String 
						ifTrue: 
							[container := dbConnection objectManager containerNamed: anODBContainerOrString
										ifAbsent: [OmniBase signalError: 'Invalid container name']]
						ifFalse: [container := anODBContainerOrString].
					^self storeNewObject: objectToStore inContainer: container].
	"* namesto: (self lock: anObject) ifFalse: [ ^aBlock value ]."
	transactionObject objectID index == 0 ifTrue: [^true].	"*"
	transactionObject lock ifFalse: [^aBlock value].	"*"
	transactionObject objectChanged
]

{ #category : #private }
ODBLocalTransaction >> storeNewObject: anObject inContainer: aContainer [ 
	"Store anObject into specified container."

	| transactionObject holder coll id |
	holder := aContainer newObjectHolder.
	anObject isODBTransactionObject 
		ifFalse: [transactionObject := ODBSerializedObject new value: anObject]
		ifTrue: [transactionObject := anObject].
	transactionObject setObjectHolder: holder transaction: self.
	cacheMutex critical: 
			[(id := aContainer id) > newObjects size 
				ifTrue: 
					[(coll := Array new: id) 
						replaceFrom: 1
						to: newObjects size
						with: newObjects
						startingAt: 1.
					newObjects := coll].
			(coll := newObjects at: id) isNil 
				ifTrue: 
					[coll := OrderedCollection new: 32.
					newObjects at: id put: coll].
			coll add: transactionObject.
			objectIndex at: anObject put: transactionObject].
	transactionObject objectStored
]

{ #category : #public }
ODBLocalTransaction >> unlock: anObject [ 
	"Unlock anObject."

	| transactionObject |
	transactionObject := self getTransactionObject: anObject ifAbsent: [^true].
	transactionObject isChanged ifTrue: [^false].	"Changed objects can not be unlocked."
	^transactionObject unlock
]
