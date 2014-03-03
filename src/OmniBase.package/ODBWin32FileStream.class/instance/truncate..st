public
truncate: anInteger 
	"Truncate stream so that its size will be anInteger. 
	Position to anInteger."

	mutex critical: 
			[self basicPosition: anInteger.
			(self setEndOfFile: fileHandle) = 0 ifTrue: [self fileIOError]]