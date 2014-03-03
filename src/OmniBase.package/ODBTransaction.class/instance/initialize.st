private
initialize
	cacheMutex := Semaphore forMutualExclusion.
	objects := ODBObjectIDDictionary new.
	objectIndex := ODBIdentityDictionary new