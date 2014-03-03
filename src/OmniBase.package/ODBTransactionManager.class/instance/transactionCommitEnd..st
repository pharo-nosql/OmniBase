public
transactionCommitEnd: aTransaction 
	committingTransaction == aTransaction 
		ifTrue: 
			[versionControl removeCommittingFor: aTransaction client clientID.
			committingTransaction := nil.
			serializingTransactionsSemaphore signal]