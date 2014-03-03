accessing
odbObjectID
	transactionObject == nil ifTrue: [^demandLoader odbObjectID].
	^transactionObject objectID