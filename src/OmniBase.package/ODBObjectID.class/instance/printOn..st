public
printOn: aStream 
	super printOn: aStream.
	aStream nextPut: $(.
	containerID printOn: aStream.
	aStream nextPut: $:.
	index printOn: aStream.
	aStream nextPut: $)