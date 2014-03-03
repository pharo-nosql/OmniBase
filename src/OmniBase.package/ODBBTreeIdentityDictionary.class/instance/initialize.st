private
initialize
	super initialize.
	keySize := ODBObjectID sizeInBytes.
	newKeys := IdentityDictionary new