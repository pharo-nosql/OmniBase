*omnibase
odbDeserialize: deserializer

	| size dict key |
	size := deserializer stream getPositiveInteger.
	dict := self new: size.
	deserializer register: dict.
	size timesRepeat: [
		key := deserializer odbNextObject.
		dict at: key put: deserializer odbNextObject.
	].
	^dict