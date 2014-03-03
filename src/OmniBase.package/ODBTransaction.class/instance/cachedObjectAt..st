public
cachedObjectAt: objectID 
	"Answer object identified by the given objectID.
	Answer <nil> if the object is not found in the local transaction cache.
	This method will not load the object from the disk drive."

	| transactionObject |
	^(objects isNil 
		or: [(transactionObject := self cachedTransactionObjectAt: objectID) isNil]) 
			ifFalse: [transactionObject value]