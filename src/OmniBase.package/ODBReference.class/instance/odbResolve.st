public
odbResolve
	"See Object>>#odbResolve for comment."

	^transactionObject isNil 
		ifTrue: [demandLoader getObject]
		ifFalse: [transactionObject value]