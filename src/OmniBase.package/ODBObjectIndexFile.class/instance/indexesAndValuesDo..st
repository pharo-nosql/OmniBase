public
indexesAndValuesDo: aBlock 
	| lastIndex buffer bufSize bufPos value |
	buffer := ByteArray new: 400 * valueLength.
	lastIndex := self getLastIndex.
	
	[gcCount := 0.
	gcPosition := lastIndex * valueLength + start.
	gcBuffer := ByteArray new: 1024.
	bufSize := stream
				position: start;
				getBytesFor: buffer.
	bufPos := 1.
	1 to: lastIndex
		do: 
			[:index | 
			value := buffer copyFrom: bufPos to: bufPos + valueLength - 1.
			(value at: 9) == 0 ifFalse: [aBlock value: index value: value].
			bufPos := bufPos + valueLength.
			bufPos >= bufSize 
				ifTrue: 
					[stream position: index * valueLength + start.
					bufSize := stream getBytesFor: buffer.
					bufPos := 1]].
	gcCount \\ 256 = 0 ifFalse: [self flushGCBuffer]] 
			ensure: 
				[gcCount := nil.
				gcBuffer := nil]