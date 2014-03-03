*omnibase
odbDeserialize: deserializer

	| stream number |
	stream := deserializer stream.
	number := self basicNew: 4.
	1 to: 4 do: [:i | number basicAt: i put: stream getByte ].
	^number