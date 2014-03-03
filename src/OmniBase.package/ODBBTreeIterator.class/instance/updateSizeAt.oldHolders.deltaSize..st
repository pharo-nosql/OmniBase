public
updateSizeAt: versionNumber oldHolders: oldHolders deltaSize: deltaSize 
	| oldHolder newHolder pos |
	pos := self headerLength.
	self waitForLockAt: pos length: ODBSizeHolder sizeInBytes.
	
	[oldHolder := (ODBSizeHolder new)
				loadFromStream: stream at: pos;
				yourself.
	oldHolders isNil 
		ifTrue: [newHolder := oldHolder]
		ifFalse: 
			[newHolder := oldHolder makeNewVersion: oldHolders.
			oldHolders flush].
	newHolder
		dictionarySize: oldHolder dictionarySize + deltaSize;
		versionNumber: versionNumber.
	newHolder storeOnStream: stream at: pos] 
			ensure: [self unlockAt: pos length: ODBSizeHolder sizeInBytes]