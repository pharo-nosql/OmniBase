public
flushGCBuffer
	stream 
		atPosition: gcPosition
		putBytesFrom: gcBuffer
		len: ((gcCount - 1) \\ 256 + 1) * 4.
	gcPosition := stream position.
	stream
		truncate: gcPosition;
		flush;
		atPosition: self headerLength + 8 putLong: gcCount;
		flush