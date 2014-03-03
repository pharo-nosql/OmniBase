public
transactionReferenceAt: index 
	^(index > transactionReferences size or: [index = 0]) 
		ifFalse: [transactionReferences at: index]