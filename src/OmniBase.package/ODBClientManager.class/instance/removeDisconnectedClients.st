public
removeDisconnectedClients
	"Remove all disconnected clients."

	self clients do: 
			[:client | 
			(client isTerminated or: [idTable isBeingRemoved: client clientID]) 
				ifTrue: [client remove]]