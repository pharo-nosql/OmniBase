private
removeCachedObjectID: objectID 
	"Remove transaction object associated with objectID."

	objects isNil ifFalse: [cacheMutex critical: [objects removeKey: objectID]]