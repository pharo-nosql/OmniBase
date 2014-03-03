public
at: objectID put: anObject 
	| dict |
	(dict := dictionaries at: objectID containerID) isNil 
		ifTrue: [dictionaries at: objectID containerID put: (dict := ODBIdentityDictionary new)].
	^dict at: objectID index put: anObject