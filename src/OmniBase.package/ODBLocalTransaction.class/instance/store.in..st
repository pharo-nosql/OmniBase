public
store: anObject in: aContainerOrContainerName 
	^self 
		store: anObject
		in: aContainerOrContainerName
		ifLocked: [self signalLockingConflictAt: anObject]