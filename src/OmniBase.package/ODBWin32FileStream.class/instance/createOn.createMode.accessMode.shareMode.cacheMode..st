private
createOn:  aPathname createMode: createMode accessMode: accessMode shareMode: shareMode cacheMode: cacheMode 
	| fd |
	2 timesRepeat: [(fd := self
				createFile: aPathname
				dwDesiredAccess: accessMode
				dwSharedMode: shareMode
				lpSecurityAttributes: nil
				dwCreationDistribution: createMode
				dwFlagsAndAttributes: (128 bitOr: cacheMode) "FILE_ATTRIBUTE_NORMAL | cacheMode"
				hTemplateFile: nil) = -1 "INVALID_HANDLE_VALUE "
		ifFalse: [^self openOn: aPathname fileHandle: fd].
	(Delay forMilliseconds: 500) wait.
	].
	self fileIOError