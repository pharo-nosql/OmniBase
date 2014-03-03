public
lock: anObject 
	"Lock anObject."

	| transactionObject |
	transactionObject := self getTransactionObject: anObject ifAbsent: [^true].
	transactionObject objectID index == 0 ifTrue: [^true].
	^transactionObject lock