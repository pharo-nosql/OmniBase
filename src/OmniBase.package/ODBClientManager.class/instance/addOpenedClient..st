private
addOpenedClient: aClient 
	"Private - Add opened client to array of clients."

	(clients at: aClient clientID) isNil 
		ifFalse: [OmniBase signalError: 'Client already exists'].
	clients at: aClient clientID put: aClient