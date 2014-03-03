public
getSizeHolder
	^(ODBSizeHolder new)
		loadFromStream: stream at: self headerLength;
		yourself