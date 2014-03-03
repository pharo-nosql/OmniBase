public
currentTransaction
	| transaction |
	transaction := currentTransaction.
	processToTransactionMutex critical: 
			[transaction := processToTransactionDict at: Processor activeProcess
						ifAbsent: [transaction]].
	transaction isNil ifFalse: [^transaction].
	self signalError: 'No transaction is active'