*omnibase
odbDeserialize: deserializer

	^self numerator: deserializer stream getInteger
		denominator: deserializer stream getInteger