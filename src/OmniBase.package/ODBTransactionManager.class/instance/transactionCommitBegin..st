public
transactionCommitBegin: aTransaction 
	| versionNumber |
	serializingTransactionsSemaphore wait.
	committingTransaction notNil 
		ifTrue: [OmniBase signalError: 'Concurrent commit is not allowed'].
	committingTransaction := aTransaction.
	versionNumber := versionControl getNewVersionNumberFor: aTransaction client clientID.
	aTransaction versionDescriptor versionNumber: versionNumber