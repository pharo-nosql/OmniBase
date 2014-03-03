private
newTransactionFileFor: aTransaction 
	| transactionFile transactionID count |
	count := transactionFiles size.
	freeTransactionFile isNil ifFalse: [count := count - 1].
	hasGlobalLock 
		ifTrue: 
			[aTransaction isGlobalLocked ifFalse: [^nil].
			count == 0 ifFalse: [^nil]]
		ifFalse: 
			[aTransaction isGlobalLocked ifTrue: [^nil].
			count == 0 ifTrue: [(clientManager requestLocksFor: id) ifFalse: [^nil]]].
	freeTransactionFile isNil 
		ifFalse: 
			[transactionFile := freeTransactionFile.
			freeTransactionFile := nil.
			transactions add: aTransaction.
			^transactionFile].
	transactionID := id bitShift: 8.
	256 timesRepeat: 
			[(transactionFiles includes: transactionID) 
				ifFalse: 
					[transactionFiles add: transactionID.
					clientFile transactionIDs: transactionFiles.
					[transactionFile := ODBTransactionFile createOn: (self trnFileName: transactionID)] 
						on: Error
						do: [:er | transactionFile := nil].
					transactionFile isNil 
						ifTrue: [transactionFiles remove: transactionID]
						ifFalse: 
							[transactions add: aTransaction.
							^transactionFile transactionID: transactionID]].
			transactionID := transactionID + 1].
	OmniBase signalError: 'Maximum number of active read-write transactions reached'