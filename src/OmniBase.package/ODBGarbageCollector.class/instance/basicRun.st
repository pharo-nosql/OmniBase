private
basicRun
	
	[self progressNotification: 'Starting garbage collection' value: 0.
	self lockObjectManager.	"doesn't realy lock it, see method #lockObjectManager"
	containers := objectManager containers.
	(self checkDiskSpace: containers) ifFalse: [^false].
	self
		createNewObjectSpaces;
		selectNewObjectSpace;
		swapObjectSpaces;
		walkObjects;
		copyObjects;
		complete] 
			ensure: 
				[self close.
				objectManager reopen.
				objectManager environment globalUnlock]