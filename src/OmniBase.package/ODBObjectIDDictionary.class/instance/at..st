public
at: objectID 
	"Answer transaction object at objectID or <nil> if absent."

	| dict |
	(dict := dictionaries at: objectID containerID) isNil ifTrue: [^nil].
	^dict at: objectID index