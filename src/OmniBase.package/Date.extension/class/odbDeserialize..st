*omnibase
odbDeserialize: deserializer

	^deserializer register: (self fromDays: deserializer stream getInteger)