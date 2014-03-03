public
unlock
	"Unlock receiver."

	lockObject isNil 
		ifFalse: 
			[(holder unlockWith: lockObject lockID) ifFalse: [^false].
			transaction removeLock: lockObject.
			lockObject := nil].
	^true