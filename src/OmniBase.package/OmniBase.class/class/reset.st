public
reset
	"Use wisely. Makes a complete reset of all related to this persistance clients."
	self closeAll.
	processToTransactionDict := IdentityDictionary new.
	processToTransactionMutex := Semaphore forMutualExclusion.
	currentTransaction := nil.
	