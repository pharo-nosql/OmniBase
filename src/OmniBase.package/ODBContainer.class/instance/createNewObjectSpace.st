public
createNewObjectSpace
	"Create new object space for garbage collection."

	dataFileA isNil 
		ifTrue: [dataFileA := ODBObjectStorage createOn: self dataFileNameA]
		ifFalse: 
			[dataFileB isNil ifTrue: [dataFileB := ODBObjectStorage createOn: self dataFileNameB]]