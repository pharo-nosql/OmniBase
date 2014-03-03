*omnibase
odbBasicSerialize: serializer

	self < 0 ifTrue: [
		self > -4 ifTrue: [ ^serializer stream putByte: self + 70 ].
		^serializer stream putByte: 12; putPositiveInteger: 0 - self.
	].
	self < 17 ifTrue: [ ^serializer stream putByte: self + 50 ].
	serializer stream putByte: 11; putPositiveInteger: self