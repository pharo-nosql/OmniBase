handling
setTransaction: aTransaction for: aProcess 
	"Private - Associaties a transaction to aProcess."

	processToTransactionMutex 
		critical: [processToTransactionDict at: aProcess put: aTransaction]