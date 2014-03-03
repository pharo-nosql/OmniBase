public
at: aKey put: anObject 
	"Associate aKey with anObject.
	aKey can be any object which implements method #asBtreeKeyOfSize:
	Trigger an exception if aKey has already been locked or changed in a concurrently running transaction."

	^self 
		at: aKey
		put: anObject
		ifLocked: [ODBCannotLockKey signal]