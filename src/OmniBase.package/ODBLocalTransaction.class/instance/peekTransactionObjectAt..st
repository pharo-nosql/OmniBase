private
peekTransactionObjectAt: objectID 
	"Answer transaction object at objectID but do not cache it in transaction."

	| holder transactionObject |
	(transactionObject := self cachedTransactionObjectAt: objectID) isNil 
		ifFalse: [^transactionObject].
	(holder := dbConnection objectManager holderAt: objectID) == nil 
		ifTrue: [OmniBase signalError: 'Invalid object ID'].
	[versionDescriptor versionOK: holder versionNumber] 
		whileFalse: [holder loadPreviousVersionFrom: self oldHolders].
	transactionObject := holder getObject makeTransactionObject: self.
	^transactionObject objectLoaded