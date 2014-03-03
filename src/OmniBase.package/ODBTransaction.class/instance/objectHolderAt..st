private
objectHolderAt: objectID 
	"Private - Answer object holder at objectID."

	| trObj |
	^(trObj := self cachedTransactionObjectAt: objectID) isNil 
		ifFalse: [trObj objectHolder]
		ifTrue: [dbConnection objectManager holderAt: objectID]