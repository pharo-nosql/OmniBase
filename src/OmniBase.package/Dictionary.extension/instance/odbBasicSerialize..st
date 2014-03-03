*omnibase
odbBasicSerialize: serializer

	self class == Dictionary ifFalse: [ ^super odbBasicSerialize: serializer ].
	serializer
		stream putByte: 37;
		putPositiveInteger: self size.
	self keysAndValuesDo: [:key :value |
		key odbSerialize: serializer.
		value odbSerialize: serializer.
	].