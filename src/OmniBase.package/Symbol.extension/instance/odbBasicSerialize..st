*omnibase
odbBasicSerialize: serializer

	serializer stream
		putByte: 18;
		putPositiveInteger: self size;
		putBytesFrom: self asByteArray len: self size