public
at: anObject ifAbsentPut: aBlock 
	^self at: anObject ifAbsent: [self at: anObject put: aBlock value]