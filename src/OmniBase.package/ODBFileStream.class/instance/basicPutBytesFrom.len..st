public
basicPutBytesFrom: aByteArray len: length 
	(fileHandle
		writeFrom: aByteArray
		startingAt: 1
		for: length)
		= length ifFalse: [OmniBase signalError: 'Could not write the whole data'].
	fileHandle flush.
	position := position + length.
	^self
