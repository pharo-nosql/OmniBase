*omnibase
odbBasicSerialize: serializer

	serializer stream putByte: 31.
	key odbSerialize: serializer.
	value odbSerialize: serializer.