*omnibase
odbBasicSerialize: serializer

	serializer stream
		putByte: 81;
		putPositiveInteger: self size.
	self do: [:each | each odbSerialize: serializer ].