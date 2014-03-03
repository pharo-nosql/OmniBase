public
putByte: aByte 
	position < readLimit ifFalse: [self moveToNext].
	current at: (position := position + 1) put: aByte