private/initialization
initialize
		"Private - Initialize receiver."

	searchPath := Array new: 20.
	searchPathHeight := 0.
	rootPagePosition := self headerLength + ODBSizeHolder sizeInBytes + 4.
	mutex := Semaphore forMutualExclusion.