public
basicGetBytesFor: aByteCollection len: len 
	"Private - Read len bytes from stream to aByteCollection. 
	Answer number of bytes actualy read."

	| startTime currentTime errorCode |
	(self 
		readFile: fileHandle
		lpBuffer: aByteCollection
		nNumberOfBytesToRead: len
		lpNumberOfBytesRead: externalLong
		lpOverlapped: nil) = 0
			ifTrue: 
				[currentTime := startTime := Time millisecondClockValue.
				
				[errorCode := self getLastError.
				errorCode = 33 or: [errorCode = 5	"access denied"]	"lock violation"] 
						whileTrue: 
							[currentTime - startTime < self maxMillisecondsOfTolerance 
								ifFalse: 
									[ODBStreamLockedNotification signal 
										ifTrue: [startTime := currentTime]
										ifFalse: [self fileIOError: errorCode]].
							(self 
								readFile: fileHandle
								lpBuffer: aByteCollection
								nNumberOfBytesToRead: len
								lpNumberOfBytesRead: externalLong
								lpOverlapped: nil) = 0 ifFalse: [^externalLong odbLongAt: 1].
							currentTime := Time millisecondClockValue.
							currentTime < startTime ifTrue: [currentTime := currentTime + 86400000]].
				self fileIOError: errorCode].
	^externalLong odbLongAt: 1