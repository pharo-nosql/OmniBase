private
cachedTransactionObjectAt: objectID 
	"Private - Answer cached transaction object at objectID."

	| obj |
	cacheMutex critical: [obj := objects at: objectID].
	^obj