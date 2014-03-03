public
unlock: anObject 
	"Unlock anObject."

	| transactionObject |
	transactionObject := self getTransactionObject: anObject ifAbsent: [^true].
	transactionObject isChanged ifTrue: [^false].	"Changed objects can not be unlocked."
	^transactionObject unlock