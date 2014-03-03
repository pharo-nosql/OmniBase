private
transactionObjectAt: objectID 
	"Private - Answer transaction object at objectID."

	| holder transactionObject t2 |
	cacheMutex isNil ifTrue: [^ODBExpiredProxyObject on: objectID].
	cacheMutex critical: [transactionObject := objects at: objectID].
	transactionObject isNil ifFalse: [^transactionObject].
	(holder := dbConnection objectManager holderAt: objectID) isNil 
		ifTrue: 
			["OID (1:1) = nil"
			^transactionObject := (objectID index = 1 and: [objectID containerID = 1]) 
						ifFalse: [OmniBase signalError: 'Invalid object ID']].
	[versionDescriptor versionOK: holder versionNumber] 
		whileFalse: [holder loadPreviousVersionFrom: self oldHolders].
	[transactionObject := holder getObject makeTransactionObject: self] 
		ifCurtailed: [self becomeInconsistent].
	cacheMutex critical: 
			[(t2 := objects at: objectID) isNil 
				ifTrue: 
					[objects at: objectID put: transactionObject.
					objectIndex at: transactionObject value put: transactionObject]].
	^t2 isNil ifTrue: [transactionObject objectLoaded] ifFalse: [t2]