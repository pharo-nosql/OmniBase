accessing
odbGetTransaction
	"Answer transaction that owns the reference."

	transactionObject isNil ifTrue: [^demandLoader transaction].
	^transactionObject transaction