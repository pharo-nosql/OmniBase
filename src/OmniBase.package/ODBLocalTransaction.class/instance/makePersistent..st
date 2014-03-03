public
makePersistent: anObject 
	^self makePersistent: anObject in: dbConnection objectManager defaultContainer