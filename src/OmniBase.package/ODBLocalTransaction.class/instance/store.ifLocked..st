public
store: anObject ifLocked: aBlock 
	^self 
		store: anObject
		in: dbConnection objectManager defaultContainer
		ifLocked: aBlock