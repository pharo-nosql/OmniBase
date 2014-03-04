accessing
openOn: aString 
	path := aString.
	
	[indexFile := ODBObjectIndexFile openOn: self indexFileName.
	[dataFileA := ODBObjectStorage openOn: self dataFileNameA] on: Error do: [:ex | ].
	[dataFileB := ODBObjectStorage openOn: self dataFileNameB] on: Error do: [:ex | ].
	self localDefaultObjectSpace = 0 
		ifTrue: [(activeDataFile := dataFileA) isNil ifTrue: [activeDataFile := dataFileB]]
		ifFalse: [(activeDataFile := dataFileB) isNil ifTrue: [activeDataFile := dataFileA]].
	activeDataFile isNil 
		ifTrue: [OmniBase signalError: 'Object storage file ' , self dataFileNameA , ' can not be opened']] 
			ifCurtailed: [self close]