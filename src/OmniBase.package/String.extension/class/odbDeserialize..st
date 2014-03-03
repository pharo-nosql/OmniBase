*omnibase
odbDeserialize: deserializer

	| buf len |
	buf := ByteArray new: (len := deserializer stream getPositiveInteger).
	deserializer stream getBytesFor: buf len: len.
	^deserializer register: buf asString