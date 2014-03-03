initialization
initialize

	cache := Array
		with: (Array new: self cacheSize)
		with: (Array new: self cacheSize).
	top := 1.
	bottom := 1.
	filePos := self headerLength.
	valueSize := ODBObjectID sizeInBytes.