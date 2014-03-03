handling
getCurrentAndSet: anOmniBaseTransaction for: aProcess 
	"Private - Associaties anOmniBaseTransaction with aProcess.
	Answer previous active transaction in case transactions are nested."

	| previousTxn |
	processToTransactionMutex critical: 
			[previousTxn := processToTransactionDict at: aProcess ifAbsent: [].
			processToTransactionDict at: aProcess put: anOmniBaseTransaction].
	^previousTxn