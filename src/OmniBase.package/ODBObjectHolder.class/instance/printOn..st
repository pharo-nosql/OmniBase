public
printOn: aStream 
	super printOn: aStream.
	aStream nextPut: $(.
	objectID printOn: aStream.
	aStream nextPutAll: ';version='.
	self versionNumber printOn: aStream.
	aStream nextPutAll: ';pid='.
	self persistentClassID printOn: aStream.
	aStream nextPut: $)