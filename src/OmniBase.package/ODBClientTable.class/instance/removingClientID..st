public
removingClientID: clientID 
	"Client clientID is being removed."

	self lockTable.
	
	[self loadTable.
	self globalLockClientID == clientID ifTrue: [self globalLockClientID: 0].
	(self clientTableAt: clientID) > 0 ifTrue: [self clientTableAt: clientID put: 2]] 
			ensure: [self unlockTable]