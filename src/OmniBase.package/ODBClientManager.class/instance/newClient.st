public
newClient
	"Answer new local client."

	| newClient |
	idTable 
		onNewClientIDDo: [:newID | newClient := ODBLocalClient new createOn: self clientID: newID].
	newClient isNil ifTrue: [OmniBase signalError: 'Maximum number of clients reached'].
	^newClient