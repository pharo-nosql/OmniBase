private
saveExternalReference: anObjectId 
	stream
		putByte: 5;
		putPositiveInteger: (referenceManager addReference: anObjectId)