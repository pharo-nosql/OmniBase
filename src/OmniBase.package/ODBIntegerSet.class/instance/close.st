public
close
	"Close stream associated with receiver."

	stream isNil 
		ifFalse: 
			[(changed and: [currentPage ~~ nil]) 
				ifTrue: 
					[stream
						position: (currentPage bitShift: 12) + self headerLength;
						putBytesFrom: bitField len: 4096	"2^12=4096"]].
	^super close