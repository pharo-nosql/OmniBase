public
addByteStorageRequest: anODBByteStorageRequest 
	byteStorageQueue add: anODBByteStorageRequest.
	queueSize := queueSize + anODBByteStorageRequest bytes size.
	queueSize > 65536 ifTrue: [self flushBytes]