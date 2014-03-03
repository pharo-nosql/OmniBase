public
transactionID
	transactionID isNil 
		ifTrue: 
			[transactionID := stream
						position: self headerLength + 8;
						getWord].
	^transactionID