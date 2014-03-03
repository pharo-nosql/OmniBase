public
goTo: aByteArray put: aValue 
	mutex critical: 
			[aByteArray isNil ifFalse: [nextKey := aByteArray].
			self basicPut: aValue].
	^aValue