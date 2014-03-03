public
openOn: aString fileHandle: anIOAccessor
		"Private - Initialize receiver."

	pathName := aString.
	fileHandle := anIOAccessor.
	position := 0.
	mutex := Semaphore forMutualExclusion.