*omnibase
odbDeserialize: deserializer

	| array |
	array := self new: deserializer stream getPositiveInteger.
	deserializer register: array.
	1 to: array size do: [:i | array at: i put: deserializer odbNextObject ].
	^array