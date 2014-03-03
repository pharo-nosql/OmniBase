public
createOn: aClientManager clientID: anInteger 
	| userName machineName |
	"get logged in user and local hostname"
	self odbToDo.
	userName := nil.
	machineName := nil.
	(userName isNil or: [userName isEmpty]) ifTrue: [userName := 'unknown-user'].
	(machineName isNil or: [machineName isEmpty]) ifTrue: [machineName := 'unknown-host'].
	id := anInteger.
	clientManager := aClientManager.
	clientFile := ODBClientFile createOn: (clientManager clientFileName: id).
	clientManager addOpenedClient: self.
	self description: 'OmniBase 2.1 [clientID=' , id printString , '] ' , userName , '@' 
				, machineName