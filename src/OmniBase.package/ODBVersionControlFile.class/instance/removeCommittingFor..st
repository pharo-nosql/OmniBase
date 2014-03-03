public
removeCommittingFor: clientID 
	"Remove committing version number for clientID."

	(clientID > 0 and: [clientID <= ODBClientTable maxClients]) 
		ifFalse: [OmniBase signalError: 'Bad client ID'].
	stream atPosition: clientID * 4 + self headerLength putLong: 0.
	versionDescriptor := nil