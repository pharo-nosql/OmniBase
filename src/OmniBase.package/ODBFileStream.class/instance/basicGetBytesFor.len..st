public
basicGetBytesFor: aByteCollection len: len
		"Read len bytes from stream to aByteCollection. 
		Answer number of bytes actualy read."

	^fileHandle flush; readInto: aByteCollection startingAt: 1 for: len