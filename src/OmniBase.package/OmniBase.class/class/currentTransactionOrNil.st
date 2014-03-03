transaction management
currentTransactionOrNil
	| transaction |
	transaction := currentTransaction.
	processToTransactionMutex critical: 
			[transaction := processToTransactionDict at: Processor activeProcess
						ifAbsent: [transaction]].
	^transaction