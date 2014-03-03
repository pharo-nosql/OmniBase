public
unlockCurrentWith: lockID 
	"Try to unlock currentKey with lockID. 
        Answer <true> if successfull."

	| fileLockID |
	self lockTree.
	
	[self loadCurrentKey.
	currentKeyExists ifFalse: [^true].
	fileLockID := self lastPage lockID.
	fileLockID == 0 ifTrue: [^true].
	fileLockID == lockID 
		ifTrue: 
			[(self lastPage)
				lockID: 0;
				storeItem.
			^true]] 
			ensure: [self unlockTree].
	^false