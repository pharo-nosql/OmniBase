*omnibase
odbBasicSerialize: serializer 
	self class == MessageSend ifFalse: [^super odbBasicSerialize: serializer].
	serializer stream putByte: 20.
	receiver odbSerialize: serializer.
	selector odbSerialize: serializer.
	arguments odbSerialize: serializer