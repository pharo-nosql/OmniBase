*omnibase
odbBasicSerialize: serializer 
	self class == Message ifFalse: [^super odbBasicSerialize: serializer].
	serializer stream putByte: 17.
	selector odbSerialize: serializer.
	args odbSerialize: serializer