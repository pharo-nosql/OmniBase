private
odbTransactionObject

	transactionObject isNil ifTrue: [demandLoader getObject].
	^transactionObject