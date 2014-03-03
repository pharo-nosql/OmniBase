public
flush
	"Force all data written to the receiver to be recorded on disk."

	(self flushFileBuffers: fileHandle) = 0 ifTrue: [self fileIOError]