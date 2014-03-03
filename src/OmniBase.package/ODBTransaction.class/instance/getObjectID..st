public
getObjectID: anObject 
	"Answer <objectID> coresponding to anObject."

	| transactionObject oid |
	anObject odbObjectID isNil ifFalse: [^anObject odbObjectID].
	cacheMutex critical: [transactionObject := objectIndex at: anObject].
	transactionObject isNil 
		ifTrue: 
			[OmniBase 
				signalError: 'Object is not persistent or is contained in another persistent object'].
	(oid := transactionObject objectID) index == 0 
		ifTrue: 
			[OmniBase 
				signalError: 'Object ID is not allocated yet. Object ID will be allocated after transaction checkpoint or commit.'].
	^oid