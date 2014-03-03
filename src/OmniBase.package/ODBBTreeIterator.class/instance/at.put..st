public
at: aString put: anInteger 
	| key value |
	key := ByteArray new: keyLength.
	key 
		replaceFrom: 1
		to: (aString size min: keyLength)
		with: aString
		startingAt: 1.
	value := ByteArray new: 4.
	value odbLongAt: 1 put: anInteger.
	self
		goTo: key put: value;
		clearSearchCache.
	^anInteger