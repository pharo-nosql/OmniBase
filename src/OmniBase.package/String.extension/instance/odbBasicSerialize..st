*omnibase
odbBasicSerialize: serializer

	| buf |
	(buf := self asByteArray) size < 10
		ifTrue: [
			^serializer stream
				putByte: 70 + buf size;
				putBytesFrom: buf len: buf size ].
	serializer stream
		putByte: 34;
		putPositiveInteger: buf size;
		putBytesFrom: buf len: buf size