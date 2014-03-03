*omnibase
odbDeserialize: deserializer

	^Smalltalk at: deserializer stream getString asSymbol ifAbsent: []