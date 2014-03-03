*omnibase
odbBasicSerialize: serializer

	self asInteger < 256 ifTrue: [
		serializer stream putByte: 13; putChar: self.
		^self
	].
	serializer stream putByte: 29; putWord: self asInteger