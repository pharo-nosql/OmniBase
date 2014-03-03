private
opened
	"Private - Receiver has just been opened."

	self class add: self.
	
	[clientManager
		removeDisconnectedClients;
		closeForeignClients] on: Error
			do: [:er | #odbTODO]