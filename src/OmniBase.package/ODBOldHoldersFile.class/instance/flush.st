public
flush
	(buffer isNil or: [bufPos == 0]) ifTrue: [^self].
	stream 
		atPosition: filePos
		putBytesFrom: buffer
		len: bufPos.
	buffer size - bufPos < 16 
		ifTrue: [buffer := nil]
		ifFalse: 
			[filePos := filePos + bufPos.
			buffer := buffer copyFrom: bufPos + 1 to: buffer size.
			bufPos := 0]