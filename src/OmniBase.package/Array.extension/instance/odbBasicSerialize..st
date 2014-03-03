*omnibase
odbBasicSerialize: serializer

	serializer stream putByte: 35; putPositiveInteger: self size.
	1 to: self size do: [:i | (self at: i) odbSerialize: serializer ].