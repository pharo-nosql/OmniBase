public
unlockWith: lockID 
	oldVersion ifTrue: [^false].
	^container indexFile stream unlockAt: self lockStartPosition + objectID index length: 1