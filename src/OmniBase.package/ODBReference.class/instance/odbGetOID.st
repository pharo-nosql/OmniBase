accessing
odbGetOID
	transactionObject == nil ifTrue: [^demandLoader odbObjectID].
	^transactionObject objectID