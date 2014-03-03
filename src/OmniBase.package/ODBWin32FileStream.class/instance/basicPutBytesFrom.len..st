private
basicPutBytesFrom: aByteCollection len: len 
	"Private - Write len bytes from aByteCollection to file."

	(self 
		writeFile: fileHandle
		lpBuffer: aByteCollection asByteArray
		nNumberOfBytesToWrite: len
		lpNumberOfBytesWritten: externalLong
		lpOverlapped: nil) = 0 ifTrue: [self fileIOError]