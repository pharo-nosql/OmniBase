public
unlockKey: aKey 
	"Unlocks key aKey. Answer <true> if successfull."

	| lock key |
	dataBaseObject isNil ifTrue: [^true].
	key := self bytesFromKey: aKey.
	changed isNil ifFalse: [(changed includes: key) ifTrue: [^false]].
	locks isNil ifTrue: [^transaction isGlobalLocked].
	lock := locks at: key ifAbsent: [^false].
	(dataBaseObject unlockKey: key with: lock lockID) ifFalse: [^false].
	transaction removeLoggedLock: lock.
	locks removeKey: key.
	^true