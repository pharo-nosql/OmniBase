private
basicCompactContainerNamed: aString 
	| container |
	
	[container := objectManager containerNamed: aString
				ifAbsent: [OmniBase signalError: 'Container named ' , aString , ' does not exist'].
	(self checkDiskSpace: (Array with: container)) ifFalse: [^false].
	container
		createNewObjectSpace;
		swapObjectSpaces.
	self compactObjectSpaceForContainer: container reachableObjectsSet: nil] 
			ensure: 
				[self close.
				objectManager reopen.
				objectManager environment globalUnlock]