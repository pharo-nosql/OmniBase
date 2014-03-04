*omnibasePatch
markDirty: anObject 
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