*omnibasePatch
printOn: aStream

	super printOn: aStream.
	
	aStream nextPutAll: '(',self hash asString,')'