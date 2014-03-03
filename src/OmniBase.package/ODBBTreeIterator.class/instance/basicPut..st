private
basicPut: aValue 
	self lockTree.
	
	[self loadCurrentKey.
	currentKeyExists 
		ifTrue: 
			[(self lastPage)
				value: aValue;
				storeItemLocked]
		ifFalse: [self insertValue: aValue lockID: 0]] 
			ensure: [self unlockTree]