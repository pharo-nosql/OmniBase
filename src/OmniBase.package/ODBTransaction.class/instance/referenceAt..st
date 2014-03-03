private
referenceAt: objectID 
	"Private - Answer reference at objectID. If object is already loaded, answer its value."

	| refObj |
	objectID containerID == 0 ifTrue: [^self transactionReferenceAt: objectID index].
	(refObj := self cachedTransactionObjectAt: objectID) isNil ifFalse: [^refObj value].
	refObj := ODBReference new.
	^refObj odbSetLoader: (ODBDemandLoader new 
				setTransaction: self
				objectID: objectID
				proxyObject: refObj)