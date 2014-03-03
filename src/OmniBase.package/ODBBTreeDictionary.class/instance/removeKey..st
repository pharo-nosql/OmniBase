public
removeKey: aKey 
	^self removeKey: aKey ifLocked: [ODBCannotLockKey signal]