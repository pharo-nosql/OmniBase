private
lockID
	"Private - Answer unique lock ID. Create transaction 
	file, if no locks have been set before. Answer <nil> 
	if database is globally locked by another user and no 
	locks can currently be set."

	locks isNil 
		ifTrue: 
			[(transactionFile := client newTransactionFileFor: self) isNil ifTrue: [^nil].
			locks := OrderedCollection new].
	^transactionFile transactionID