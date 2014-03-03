private
initialize
	dbFiles := ODBWeakValueIdentityDictionary new.
	dbFilesMutex := Semaphore forMutualExclusion.
	byteStorageQueue := OrderedCollection new.
	queueSize := 0