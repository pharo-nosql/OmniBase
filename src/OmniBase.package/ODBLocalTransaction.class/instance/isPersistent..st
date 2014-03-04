public
isPersistent: anObject
	"Answers true if anObject is persistent, false otherwise."
	
	^ (self getTransactionObject: anObject ifAbsent:[nil]) notNil
	