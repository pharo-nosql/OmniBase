*omnibase
odbDeserialize: deserializer

	| bytes len |
	bytes := ByteArray new: (len := deserializer stream getPositiveInteger).
	deserializer stream getBytesFor: bytes len: len.
	^bytes asString asSymbol