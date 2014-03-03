private
progressNotification: aString value: aFraction 
	progressDialog isNil 
		ifFalse: 
			[aFraction isNil ifFalse: [progressValue value: 100 * aFraction]].