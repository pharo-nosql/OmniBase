public
initialize
	processToTransactionMutex isNil 
		ifTrue: 
			[processToTransactionDict := IdentityDictionary new.
			processToTransactionMutex := Semaphore forMutualExclusion]