public
lock
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