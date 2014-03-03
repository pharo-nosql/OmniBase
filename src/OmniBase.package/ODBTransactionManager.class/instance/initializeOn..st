private
initializeOn: aDatabase 
	dbConnection := aDatabase.
	mutex := Semaphore forMutualExclusion.
	serializingTransactionsSemaphore := Semaphore new.
	serializingTransactionsSemaphore signal