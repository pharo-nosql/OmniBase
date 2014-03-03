*omnibase
odbDeserialize: deserializer

	| coll size |
	size := deserializer stream getPositiveInteger.
	deserializer register: (coll := self new: size).
	size timesRepeat: [ coll addLast: deserializer odbNextObject ].
	^coll