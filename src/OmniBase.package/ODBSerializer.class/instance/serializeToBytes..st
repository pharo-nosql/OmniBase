public
serializeToBytes: anObject 
	| byteStream2 |
	self 
		serialize: anObject
		onStream: ODBMemoryWriteStream new
		referenceManager: ODBReferenceManager new
		classManager: ODBClassManagerForSerialization new initializeForSerialization.
	byteStream2 := ODBMemoryWriteStream new.
	referenceManager saveOnStream: byteStream2.
	classManager saveOnStream: byteStream2.
	^byteStream2 asByteArray , stream asByteArray