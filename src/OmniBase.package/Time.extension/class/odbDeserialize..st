*omnibase
odbDeserialize: deserializer

	^deserializer register: (self fromSeconds: deserializer stream getPositiveInteger)