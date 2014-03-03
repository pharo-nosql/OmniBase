*omnibase
odbDeserialize: deserializer

	| result |
	deserializer register: (result := self new).
	^result
		key: deserializer odbNextObject;
		value: deserializer odbNextObject