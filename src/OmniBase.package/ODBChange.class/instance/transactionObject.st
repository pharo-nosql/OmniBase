public
transactionObject
	^transactionObject isNil 
		ifFalse: [transactionObject]
		ifTrue: [transactionObject := transaction transactionObjectAt: objectID]