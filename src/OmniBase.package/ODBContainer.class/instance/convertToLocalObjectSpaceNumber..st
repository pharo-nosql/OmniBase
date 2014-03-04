public
convertToLocalObjectSpaceNumber: objectSpaceNumber 
	^indexFile swappedObjectSpaces ifTrue: [1 - objectSpaceNumber] ifFalse: [objectSpaceNumber]