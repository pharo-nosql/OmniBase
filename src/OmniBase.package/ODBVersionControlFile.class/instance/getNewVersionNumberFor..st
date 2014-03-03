public
getNewVersionNumberFor: clientID 
	"Answer new version number for clientID."

	| versionNumber |
	(clientID > 0 and: [clientID <= ODBClientTable maxClients]) 
		ifFalse: [OmniBase signalError: 'Bad OmniBase connection ID'].
	self waitForLockAt: self headerLength length: 4.
	versionNumber := (stream atPositionGetLong: self headerLength) + 1.
	stream
		atPosition: self headerLength putLong: versionNumber;
		atPosition: clientID * 4 + self headerLength putLong: versionNumber;
		flush.
	self unlockAt: self headerLength length: 4.
	^versionNumber