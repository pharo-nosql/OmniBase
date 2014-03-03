public
transactionAborted: aTransaction 
	"Discard version descriptor. Default do nothing."

	committingTransaction == aTransaction 
		ifTrue: 
			[versionControl removeCommittingFor: aTransaction client clientID.
			committingTransaction := nil.
			serializingTransactionsSemaphore signal]