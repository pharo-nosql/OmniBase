public
containerNew: aString path: path 
	"Private - Create new container named aString 
	on given path. Signal an error if failed."

	| containerName containerID containerPath dirName cont pos stream |
	path = '' ifFalse: [OmniBase signalError: 'Not supported'].
	infoFile isLocked ifTrue: [OmniBase signalError: 'Object manager is currently locked !'].
	idTable waitForAddingLock.
	
	[(cont := self containerNamed: aString ifAbsent: []) isNil 
		ifFalse: [OmniBase signalError: 'Container with this name allready exists'].
	containerName := self unifyContainerName: aString.
	containerID := idTable add: 0.
	pos := 0.
	dirName := self convert: aString.
	
	[containerPath := (path isEmpty ifTrue: [self dirName] ifFalse: [path]) 
				, ODBFileStream pathSeparatorString , dirName.
	ODBFileStream directoryExists: containerPath] 
			whileTrue: 
				[pos := pos + 1.
				dirName := (dirName copyFrom: 1 to: (dirName size min: 7)) , pos printString].
	ODBFileStream directoryCreate: containerPath.
	cont := (ODBContainer new)
				name: containerName;
				id: containerID;
				objectManager: self;
				createOn: containerPath.
	stream := infoFile stream.
	pos := stream setToEnd.
	stream
		putWord: containerID;
		putString: containerName;
		putString: path;
		putString: dirName.
	idTable at: containerID put: pos.
	infoFile at: containerName put: pos] 
			ensure: [idTable unlockAdding].
	containerID > containers size 
		ifTrue: 
			[pos := Array new: containerID.
			pos 
				replaceFrom: 1
				to: containers size
				with: containers
				startingAt: 1.
			containers := pos].
	^containers at: containerID put: cont