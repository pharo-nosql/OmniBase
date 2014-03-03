public
put: aValue 
	self updateCurrentKey.
	currentKeyExists 
		ifTrue: 
			[(self lastPage)
				value: aValue;
				store]
		ifFalse: [self insertValue: aValue lockID: 0]