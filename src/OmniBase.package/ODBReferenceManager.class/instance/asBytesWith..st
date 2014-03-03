public
asBytesWith: endBytes 
	"Answer aByteArray with reference manager and endBytes as a single byte array."

	| pos oidSize bytes refsSize len |
	references isNil ifTrue: [^endBytes].
	refsSize := references size.
	oidSize := ODBObjectID sizeInBytes.
	len := refsSize * oidSize + endBytes size.
	references size > 256 
		ifFalse: 
			[bytes := ByteArray new: len + 1.
			bytes at: 1 put: refsSize - 1.
			pos := 2]
		ifTrue: 
			[bytes := ByteArray new: len + 2.
			bytes
				at: 1 put: (refsSize - 1 bitAnd: 255);
				at: 2 put: (refsSize - 1 bitShift: -8).
			pos := 3].
	references do: 
			[:each | 
			each putBytesTo: bytes at: pos.
			pos := pos + oidSize].
	bytes 
		replaceFrom: pos
		to: bytes size
		with: endBytes
		startingAt: 1.
	^bytes