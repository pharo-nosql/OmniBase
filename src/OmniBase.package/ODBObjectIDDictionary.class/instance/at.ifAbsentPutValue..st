public
at: objectID ifAbsentPutValue: anObject 
	| dict |
	(dict := dictionaries at: objectID containerID) isNil 
		ifTrue: [dictionaries at: objectID containerID put: (dict := ODBIdentityDictionary new)].
	^dict at: objectID index ifAbsentPutValue: anObject