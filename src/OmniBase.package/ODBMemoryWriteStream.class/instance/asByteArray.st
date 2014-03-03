public
asByteArray
	"Answer receiver as byte array."

	| i bytes pos len coll bytesSize |
	bytes := ByteArray new: (bytesSize := self size).
	pos := 0.
	i := 1.
	
	[coll := collections at: i.
	len := coll size.
	pos + len < bytesSize] whileTrue: 
				[bytes 
					replaceFrom: pos + 1
					to: (pos := pos + len)
					with: coll
					startingAt: 1.
				i := i + 1].
	bytes 
		replaceFrom: pos + 1
		to: bytesSize
		with: coll
		startingAt: 1.
	^bytes