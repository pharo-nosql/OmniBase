public
lockCurrentValue: value with: lockID 
	"Try to lock currentKey & value with lockID. 
	Answer <true> if successfull."

	| result page |
	result := false.
	self lockTree.
	
	[self loadCurrentKey.
	currentKeyExists 
		ifTrue: 
			[page := self lastPage.
			(result := page lockID == 0 and: [page association value = value]) 
				ifTrue: 
					[page
						lockID: lockID;
						storeItem]]
		ifFalse: 
			[self insertValue: value lockID: lockID.
			result := true]] 
			ensure: [self unlockTree].
	^result