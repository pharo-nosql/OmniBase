public
removeKey: objectID 
	"Remove transaction object association with objectID. 
	Do nothing if objectID is absent."

	| dict |
	(dict := dictionaries at: objectID containerID) isNil 
		ifFalse: [dict removeKey: objectID index]