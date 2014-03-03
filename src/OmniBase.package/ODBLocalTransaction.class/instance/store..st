public
store: anObject 
	^self 
		store: anObject
		in: dbConnection objectManager defaultContainer
		ifLocked: [self signalLockingConflictAt: anObject]