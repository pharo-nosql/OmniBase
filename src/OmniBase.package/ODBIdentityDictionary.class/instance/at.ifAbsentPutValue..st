public
at: aKey ifAbsentPutValue: anObject 
	^self at: aKey ifAbsent: [self at: aKey put: anObject]