public
createOn: aString 
	"Create new container on containerPath."

	path := aString.
	
	[indexFile := ODBObjectIndexFile createOn: self indexFileName.
	objectManager defaultObjectSpace == 0 
		ifTrue: 
			[dataFileA := ODBObjectStorage createOn: self dataFileNameA.
			activeDataFile := dataFileA]
		ifFalse: 
			[dataFileB := ODBObjectStorage createOn: self dataFileNameB.
			activeDataFile := dataFileB]] 
			ifCurtailed: [self close]