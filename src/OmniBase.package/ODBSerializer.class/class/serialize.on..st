public
serialize: anObject on: aWriteStream 
	| classManager byteStream byteStream2 |
	classManager := ODBClassManagerForSerialization new initializeForSerialization.
	byteStream := ODBMemoryWriteStream new.
	self new 
		serialize: anObject
		onStream: byteStream
		referenceManager: nil
		classManager: classManager.
	byteStream2 := ODBMemoryWriteStream new.
	byteStream2 putPositiveInteger: 0.
	classManager saveOnStream: byteStream2.
	byteStream2 writeOn: aWriteStream.
	byteStream writeOn: aWriteStream