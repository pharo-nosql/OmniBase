public
serializeToBytes: anObject 
	"Serialize anObject to bytes."

	| classManager byteStream byteStream2 |
	classManager := ODBClassManagerForSerialization new initializeForSerialization.
	byteStream := ODBMemoryWriteStream new.
	self new 
		serialize: anObject
		onStream: byteStream
		referenceManager: nil
		classManager: classManager.
	byteStream2 := ODBMemoryWriteStream new.
	"brez reference manager-ja"
	byteStream2 putPositiveInteger: 0.
	classManager saveOnStream: byteStream2.
	^byteStream2 asByteArray , byteStream asByteArray